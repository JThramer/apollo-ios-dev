import OrderedCollections
import GraphQLCompiler

public class IRBuilder {

  public let compilationResult: CompilationResult

  public let schema: Schema

  public let fieldCollector = FieldCollector()

  var builtFragments: [String: NamedFragment] = [:]

  public init(compilationResult: CompilationResult) {
    self.compilationResult = compilationResult
    self.schema = Schema(
      referencedTypes: .init(
        compilationResult.referencedTypes,
        schemaRootTypes: compilationResult.schemaRootTypes
      ),
      documentation: compilationResult.schemaDocumentation
    )    
  }

  public func build(operation operationDefinition: CompilationResult.OperationDefinition) -> Operation {
    let rootField = CompilationResult.Field(
      name: operationDefinition.operationType.rawValue,
      type: .nonNull(.entity(operationDefinition.rootType)),
      selectionSet: operationDefinition.selectionSet
    )

    let rootEntity = Entity(
      source: .operation(operationDefinition)
    )

    let result = RootFieldBuilder.buildRootEntityField(
      forRootField: rootField,
      onRootEntity: rootEntity,
      inIR: self
    )

    return Operation(
      definition: operationDefinition,
      rootField: result.rootField,
      referencedFragments: result.referencedFragments
    )
  }

  public func build(fragment fragmentDefinition: CompilationResult.FragmentDefinition) -> NamedFragment {
    if let fragment = builtFragments[fragmentDefinition.name] {
      return fragment
    }

    let rootField = CompilationResult.Field(
      name: fragmentDefinition.name,
      type: .nonNull(.entity(fragmentDefinition.type)),
      selectionSet: fragmentDefinition.selectionSet
    )

    let rootEntity = Entity(
      source: .namedFragment(fragmentDefinition)
    )

    let result = RootFieldBuilder.buildRootEntityField(
      forRootField: rootField,
      onRootEntity: rootEntity,
      inIR: self
    )

    let irFragment = NamedFragment(
      definition: fragmentDefinition,
      rootField: result.rootField,
      referencedFragments: result.referencedFragments,
      entities: result.entities
    )

    builtFragments[irFragment.name] = irFragment
    return irFragment
  }

  
}
