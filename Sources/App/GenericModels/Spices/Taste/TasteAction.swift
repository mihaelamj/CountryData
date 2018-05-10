import Async
import Fluent
import Foundation

public final class TasteAction<D>: Model where D: QuerySupporting, D: IndexSupporting {
  public typealias Database = D
  public typealias ID = Int
  public static var idKey: IDKey { return \.id }
  public static var entity: String {
    return "taste-action"
  }
  public static var database: DatabaseIdentifier<D> {
    return .init("taste-action")
  }
  
  var id: Int?
  let name : String
  var description: String
  
  init(name: String, description: String) {
    self.name = name
    self.description = description
  }
}

//Conform to Migration
extension TasteAction: Migration where D: QuerySupporting, D: IndexSupporting { }

//MARK: - Populating data

public struct TasteActionMigration<D>: Migration where D: QuerySupporting & SchemaSupporting & IndexSupporting & ReferenceSupporting {

  var tasteDict : TasteDictionary? = nil
  
  public typealias Database = D
  
  //MARK: - Create Fields, Indexes and relations
  
  static func prepareFields(on connection: Database.Connection) -> Future<Void> {
    return Database.create(Technique<Database>.self, on: connection) { builder in
      
      //add fields
      try builder.field(for: \Technique<Database>.id)
      try builder.field(for: \Technique<Database>.name)
      try builder.field(for: \Technique<Database>.description)
      
      //indexes
      try builder.addIndex(to: \.name, isUnique: true)
    }
  }
  
  //MARK: - Helpers
  
  static func addActions(on connection: Database.Connection) throws -> Future<Void>  {
    
    return try Taste<D>.getAllTastes(on: connection).flatMap(to: Void.self) { tasteDict in
      
      let futures = tasteActions.map { touple -> EventLoopFuture<Void> in
        
        let name = touple.0
        let desc = touple.1
        let tastes : [String] = touple.2
        
        let tasteAction =  TasteAction<D>(name: name, description: desc)
          .create(on: connection)
          .map(to: Void.self) { _ in return }
        
        //so this returned
//        tastes.forEach({ taste in
//          TasteActionPivot<D>(left: taste[tasteName], right: actionID)
//        })
        
        return tasteAction
      }
      
      return Future<Void>.andAll(futures, eventLoop: connection.eventLoop)
      
    }
  }
  
  /*
   extension Staff : Migration {
   static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
    return Database.create(self, on: connection) { builder in
      try addProperties(to: builder)
      // index to a name with a UNIQUE constraint
      try builder.addIndex(to: \.siteID, \.year, isUnique: true)
      }
    }
   }
   */
  
//  static func addActions(on connection: Database.Connection, toTasteWithID id: Int, actions: TasteTouple)  -> Future<Void> {
//
//    return Taste.getAllTastes(on: connection)
//  }
  
  //MARK: - Required
  
  public static func prepare(on connection: D.Connection) -> EventLoopFuture<Void> {
    let futureCreateFields = prepareFields(on: connection)
    //    let futureInsertData = prepareAddData(on: connection)
    let allFutures : [EventLoopFuture<Void>] = [futureCreateFields]
    return Future<Void>.andAll(allFutures, eventLoop: connection.eventLoop)
    
  }
  
  public static func revert(on connection: D.Connection) -> EventLoopFuture<Void> {
    return Database.delete(TasteAction.self, on: connection)
  }

}
