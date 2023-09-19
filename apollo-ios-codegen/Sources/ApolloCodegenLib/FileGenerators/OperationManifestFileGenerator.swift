import Foundation
import OrderedCollections
import IR
import GraphQLCompiler

protocol OperationManifestTemplate {
  /// A tuple representing an operation in an operation manifest.
  /// It contains an operation and its persisted query identifier.
  typealias OperationManifestItem = (operation: OperationDescription, identifier: String)

  /// An array of ``OperationManifestItem``s
  typealias OperationManifest = [OperationManifestItem]

  func render(operations: OperationManifest) throws -> String
}

/// File generator to create an operation manifest file.
struct OperationManifestFileGenerator {
  /// The `OperationManifestFileOutput` used to generated the operation manifest file.
  let config: ApolloCodegen.ConfigurationContext

  /// Collection of operation identifiers to be serialized.
  private var operationManifest: OperationManifestTemplate.OperationManifest = []

  /// Designated initializer.
  ///
  /// Parameters:
  ///  - config: A configuration object specifying output behavior.
  init?(config: ApolloCodegen.ConfigurationContext) {
    guard config.operationManifest != nil else {
      return nil
    }

    self.config = config
  }

  /// Appends the operation to the collection of identifiers to be written to be serialized.
  mutating func collectOperationIdentifier(_ operation: OperationManifestTemplate.OperationManifestItem) {
    operationManifest.append(operation)
  }

  /// Generates a file containing the operation identifiers.
  ///
  /// Parameters:
  ///  - fileManager: `ApolloFileManager` object used to create the file. Defaults to
  ///  `ApolloFileManager.default`.
  func generate(fileManager: ApolloFileManager = .default) throws {
    let rendered: String = try template.render(operations: operationManifest)

    var manifestPath = config.operationManifest.unsafelyUnwrapped.path
    let relativePrefix = "./"
      
    // if path begins with './' the path should be relative to the config.rootURL
    if manifestPath.hasPrefix(relativePrefix) {
      let fileURL = URL(fileURLWithPath: String(manifestPath.dropFirst(relativePrefix.count)), relativeTo: config.rootURL)
      manifestPath = fileURL
          .resolvingSymlinksInPath()
          .path
    }
    
    if !manifestPath.hasSuffix(".json") {
      manifestPath.append(".json")
    }
      
    try fileManager.createFile(
      atPath: manifestPath,
      data: rendered.data(using: .utf8),
      overwrite: true
    )
  }

  var template: any OperationManifestTemplate {
    switch config.operationManifest.unsafelyUnwrapped.version {
    case .persistedQueries:
      return PersistedQueriesOperationManifestTemplate(config: config)
    case .legacy:
      return LegacyAPQOperationManifestTemplate()
    }
  }
}
