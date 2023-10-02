@testable import ApolloCodegenLib
@testable import GraphQLCompiler
import OrderedCollections
import AppKit

public extension GraphQLCompositeType {
  class func mock(
    _ name: String = ""
  ) -> GraphQLCompositeType {
    GraphQLCompositeType(
      name: name,
      documentation: nil
    )
  }
}

public extension GraphQLObjectType {
  class func mock(
    _ name: String = "",
    interfaces: [GraphQLInterfaceType] = [],
    fields: [String: GraphQLField] = [:],
    documentation: String? = nil
  ) -> GraphQLObjectType {
    GraphQLObjectType(
      name: name,
      documentation: documentation,
      fields: fields,
      interfaces: interfaces
    )
  }
}

public extension GraphQLInterfaceType {
  class func mock(
    _ name: String = "",
    fields: [String: GraphQLField] = [:],
    interfaces: [GraphQLInterfaceType] = [],
    documentation: String? = nil
  ) -> GraphQLInterfaceType {
    GraphQLInterfaceType(
      name: name,
      documentation: documentation,
      fields: fields,
      interfaces: interfaces
    )
  }
}

public extension GraphQLUnionType {
  class func mock(
    _ name: String = "",
    types: [GraphQLObjectType] = [],
    documentation: String? = nil
  ) -> GraphQLUnionType {
    GraphQLUnionType(
      name: name,
      documentation: documentation,
      types: types
    )
  }
}

public extension GraphQLScalarType {
  class func string() -> GraphQLScalarType { mock(name: "String") }
  class func integer() -> GraphQLScalarType { mock(name: "Int") }
  class func boolean() -> GraphQLScalarType { mock(name: "Boolean") }
  class func float() -> GraphQLScalarType { mock(name: "Float") }

  class func mock(
    name: String,
    specifiedByURL: String? = nil,
    documentation: String? = nil
  ) -> GraphQLScalarType {
    GraphQLScalarType(
      name: name,
      documentation: documentation,
      specifiedByURL: specifiedByURL
    )
  }
}

public extension GraphQLType {
  static func string() -> Self { .scalar(.string()) }
  static func integer() -> Self { .scalar(.integer()) }
  static func boolean() -> Self { .scalar(.boolean()) }
  static func float() -> Self { .scalar(.float()) }
}

public extension GraphQLEnumType {
  class func skinCovering() -> GraphQLEnumType {
    mock(name: "SkinCovering", values: ["FUR", "HAIR", "FEATHERS", "SCALES"])
  }

  class func relativeSize() -> GraphQLEnumType {
    mock(name: "RelativeSize", values: ["LARGE", "AVERAGE", "SMALL"])
  }

  class func mock(
    name: String,
    values: [String] = []
  ) -> GraphQLEnumType {
    return self.mock(
      name: name,
      values: values.map { GraphQLEnumValue.mock(name: $0) }
    )
  }

  class func mock(
    name: String,
    values: [GraphQLEnumValue],
    documentation: String? = nil
  ) -> GraphQLEnumType {
    GraphQLEnumType(
      name: name,
      documentation: documentation,
      values: values
    )
  }
}

public extension GraphQLEnumValue {
  static func mock(
    name: String,
    deprecationReason: String? = nil,
    documentation: String? = nil
  ) -> GraphQLEnumValue {
    GraphQLEnumValue(
      name: Name(value: name),
      documentation: documentation,
      deprecationReason: deprecationReason
    )
  }
}

public extension GraphQLInputObjectType {
  class func mock(
    _ name: String,
    fields: [GraphQLInputField] = [],
    documentation: String? = nil
  ) -> GraphQLInputObjectType {
    GraphQLInputObjectType(
      name: name,
      documentation: documentation,
      fields: OrderedDictionary.init(uniqueKeysWithValues: fields.map({ ($0.name, $0) }))
    )
  }
}

public extension GraphQLInputField {
  static func mock(
    _ name: String,
    type: GraphQLType,
    defaultValue: GraphQLValue?,
    documentation: String? = nil,
    deprecationReason: String? = nil
  ) -> GraphQLInputField {
    GraphQLInputField(
      name: name,
      type: type,
      documentation: documentation,
      deprecationReason: deprecationReason,
      defaultValue: defaultValue
    )
  }
}

public extension GraphQLField {
  class func mock(
    _ name: String,
    type: GraphQLType,
    deprecationReason: String? = nil
  ) -> GraphQLField {
    GraphQLField(
      name: name,
      type: type,
      arguments: [],
      documentation: nil,
      deprecationReason: deprecationReason
    )
  }
}
