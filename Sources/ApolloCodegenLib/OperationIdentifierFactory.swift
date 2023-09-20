import Foundation
import IR
import CryptoKit

typealias OperationIdentifierProvider = (_ operation: OperationDescription) async throws -> String

actor OperationIdentifierFactory {

  private enum CacheEntry {
    case inProgress(Task<String, Error>)
    case ready(String)
  }

  let idProvider: OperationIdentifierProvider

  private var computedIdentifiersCache: [ObjectIdentifier: CacheEntry] = [:]

  init(
    idProvider: @escaping OperationIdentifierProvider = DefaultOperationIdentifierProvider) {
    self.idProvider = idProvider
  }

  func identifier(for operation: OperationDescription) async throws -> String {
    let operationObjectID = ObjectIdentifier(operation.underlyingDefinition)
    if let cached = computedIdentifiersCache[operationObjectID] {
      switch cached {
      case let .ready(identifier): return identifier
      case let .inProgress(task): return try await task.value
      }
    }

    let task = Task {      
      try await idProvider(operation)
    }

    computedIdentifiersCache[operationObjectID] = .inProgress(task)

    let identifier = try await task.value
    computedIdentifiersCache[operationObjectID] = .ready(identifier)
    return identifier
  }

}

private let DefaultOperationIdentifierProvider =
{ (operation: OperationDescription) -> String in
  var hasher = SHA256()
  func updateHash(with source: inout String) {
    source.withUTF8({ buffer in
      hasher.update(bufferPointer: UnsafeRawBufferPointer(buffer))
    })
  }
  var definitionSource = operation.rawSourceText
  updateHash(with: &definitionSource)

  let digest = hasher.finalize()
  return digest.compactMap { String(format: "%02x", $0) }.joined()
}
