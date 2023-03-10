// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class PetSearchQuery: GraphQLQuery {
  public static let operationName: String = "PetSearch"
  public static let document: ApolloAPI.DocumentType = .notPersisted(
    definition: .init(
      #"""
      query PetSearch($filters: PetSearchFilters = {species: ["Dog", "Cat"], size: SMALL, measurements: {height: 10.5, weight: 5.0}}) {
        pets(filters: $filters) {
          __typename
          id
          humanName
        }
      }
      """#
    ))

  public var filters: GraphQLNullable<PetSearchFilters>

  public init(filters: GraphQLNullable<PetSearchFilters> = .init(
    PetSearchFilters(
      species: ["Dog", "Cat"],
      size: .init(.small),
      measurements: .init(
        MeasurementsInput(
          height: 10.5,
          weight: 5.0
        )
      )
    )
  )) {
    self.filters = filters
  }

  public var __variables: Variables? { ["filters": filters] }

  public struct Data: AnimalKingdomAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { AnimalKingdomAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("pets", [Pet].self, arguments: ["filters": .variable("filters")]),
    ] }

    public var pets: [Pet] { __data["pets"] }

    public init(
      pets: [Pet]
    ) {
      let objectType = AnimalKingdomAPI.Objects.Query
      self.init(_dataDict: DataDict(
        objectType: objectType,
        data: [
          "__typename": objectType.typename,
          "pets": pets._fieldData
      ]))
    }

    /// Pet
    ///
    /// Parent Type: `Pet`
    public struct Pet: AnimalKingdomAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { AnimalKingdomAPI.Interfaces.Pet }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("id", AnimalKingdomAPI.ID.self),
        .field("humanName", String?.self),
      ] }

      public var id: AnimalKingdomAPI.ID { __data["id"] }
      public var humanName: String? { __data["humanName"] }

      public init(
        __typename: String,
        id: AnimalKingdomAPI.ID,
        humanName: String? = nil
      ) {
        let objectType = ApolloAPI.Object(
          typename: __typename,
          implementedInterfaces: [
            AnimalKingdomAPI.Interfaces.Pet
        ])
        self.init(_dataDict: DataDict(
          objectType: objectType,
          data: [
            "__typename": objectType.typename,
            "id": id,
            "humanName": humanName
        ]))
      }
    }
  }
}
