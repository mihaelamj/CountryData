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
  
  static func addActions1(on connection: Database.Connection) throws -> Future<Void>  {
    
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
  
  static func addActions(on connection: Database.Connection) throws -> Future<Void>  {
    
    let tastes = try Taste<D>.getAllTastes(on: connection) //returns TasteDictionary [String : Int]
    
    // add -> Future<(TasteAction<D>, [String])> if the compiler complains
    
    //iterate tasteActions array of touples and create TasteAction entities
    let actions = tasteActions.map { (name, desc, tastes) in
      TasteAction<D>(name: name, description: desc)
        .create(on: connection)
        .map { ($0, tastes) }
    }
    
    return tastes.fold(actions) { (tasteDict, tuple) in
      
      let (action, tastes) = tuple
      
      return tastes.map { taste in
        //Taste.ID, TasteAction.ID
        let tasteID : Taste<Database>.ID = tasteDict[taste]!
        let tasteActionID = action.id
        //Cannot convert value of type 'Taste.ID' (aka 'Int')
        //to expected argument type 'Taste<_>'
        TasteActionPivot<D>(tasteID, tasteActionID)
          .create(on: connection)
        }
        .flatten(on: connection)
        .transform(to: tasteDict)
      }.transform(to: ())
  }
  
  /*When I'm doing complex futures interactions I usually write out all types transformations.
   In most cases it simplifies the task very well.
   So as for your example, if I understand right, it would be:
   
  Future<TasteDict>, [Future<TasteActionTuple>]  * ? -> TasteDict, TasteActionTuple
   
  Then choose appropriate operators for conversions. And as we know in-out types we can even lookup operators by types.
  so to solve the transformation Future<A>, [Future<B>] -> A, B we can do
  - future<A> * fold( [future<B>] ) -> A, B
  - future<A> * flatMap -> A
  [future<B>] * flatten -> [B]
  And as last resort we can always go out of future pipe with do, then return back with newPromise/futureResult,
   i.e. if we have to deal with callback types of async :smiley:(edited)*
   */
  
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
