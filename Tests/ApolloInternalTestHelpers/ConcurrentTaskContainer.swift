import Foundation

public class ConcurrentTaskContainer {
  private let actor = Actor()

  private actor Actor {
    private var tasks = [UUID: Task<Void, Error>]()
    private var waitForAllTaskContinuations = [CheckedContinuation<Void, Never>]()

    deinit {
      for task in tasks.values {
        task.cancel()
      }
    }

    func dispatch(_ operation: @escaping @Sendable () async throws -> Void) {
      let taskID = UUID()
      let task = Task {
        try await operation()
        self.tasks.removeValue(forKey: taskID)
        self.didFinishTask()
      }
      tasks[taskID] = task
    }

    func didFinishTask() {
      if tasks.isEmpty {
        for continuation in waitForAllTaskContinuations {
          continuation.resume()
        }
      }
    }

    func waitForAllTasks() async {
      guard !tasks.isEmpty else { return }

      await withCheckedContinuation { continuation in
        waitForAllTaskContinuations.append(continuation)
      }
    }
  }

  public init() { }

  @discardableResult
  public func dispatch(
    _ operation: @escaping @Sendable () async throws -> Void
  ) -> Task<Void, Error> {
    return Task {
      await actor.dispatch(operation)
    }
  }

  public func waitForAllTasks() async {
    await actor.waitForAllTasks()
  }

}
