import Async
import Fluent
import Foundation

public final class Country<D>: Model where D: QuerySupporting, D: IndexSupporting {
  
  public typealias Database = D
  
  public typealias ID = Int
  
  public static var idKey: IDKey { return \.id }
  
  public static var entity: String {
    return "country"
  }
  
  public static var database: DatabaseIdentifier<D> {
    return .init("countries")
  }
  
  var id: Int?
  var name: String
  var numeric: String
  var alpha2: String
  var alpha3: String
  var calling: String
  var currency: String
  var continentID: Continent<Database>.ID
  
  init(name : String, numeric: String, alpha2: String, alpha3: String, calling: String, currency: String, continentID: Continent<Database>.ID) {
    self.name = name
    self.numeric = numeric
    self.alpha2 = alpha2
    self.alpha3 = alpha3
    self.calling = calling
    self.currency = currency
    self.continentID = continentID
  }
}

extension Country: Migration where D: QuerySupporting, D: IndexSupporting { }

//MARK: - Populating data

internal struct CountryMigration<D>: Migration where D: QuerySupporting & SchemaSupporting & IndexSupporting {
  
  typealias Database = D
  
  static func prepareFields(on connection: Database.Connection) -> Future<Void> {
    return Database.create(Country<Database>.self, on: connection) { builder in
      
      //add fields
      try builder.field(for: \Country<Database>.id)
      try builder.field(for: \Country<Database>.name)
      try builder.field(for: \Country<Database>.numeric)
      try builder.field(for: \Country<Database>.alpha2)
      try builder.field(for: \Country<Database>.alpha3)
      try builder.field(for: \Country<Database>.calling)
      try builder.field(for: \Country<Database>.currency)
      try builder.field(for: \Country<Database>.continentID)
      
      //indexes
      try builder.addIndex(to: \.name, isUnique: true)
      try builder.addIndex(to: \.alpha2, isUnique: true)
      try builder.addIndex(to: \.alpha3, isUnique: true)
    }
  }
  
  static func prepare(on connection: Database.Connection) -> Future<Void> {
    
    let futureCreateFields = prepareFields(on: connection)
    
    let allFutures : [EventLoopFuture<Void>] = [futureCreateFields]
    
    return Future<Void>.andAll(allFutures, eventLoop: connection.eventLoop)
  }
  
  //MARK: - Helpers
  
  static func getContinentID(on connection: Database.Connection, continentAlpha2: String) -> Future<Continent<Database>.ID> {
    do {

      return try Continent.query(on: connection)
        .filter(\Continent.alpha2 == continentAlpha2)
        .first()
        .map(to: Continent.ID.self) { continent in
          guard let continent = continent else {
            throw FluentError(
              identifier: "PopulateCountries_noSuchContinent",
              reason: "No continent named \(continentAlpha2) exists!",
              source: .capture()
            )
          }
          return continent.id!
      }
    }
    catch {
      return connection.eventLoop.newFailedFuture(error: error)
    }
  }
  
  static func revert(on connection: D.Connection) -> EventLoopFuture<Void> {
    return connection.eventLoop.newFailedFuture(error: error)
  }

}

