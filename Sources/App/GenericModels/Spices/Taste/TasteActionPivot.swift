import Async
import Fluent
import Foundation

/// A pivot between taste and action.
public final class TasteActionPivot<D>: ModifiablePivot where D: QuerySupporting & IndexSupporting  {
 
  public typealias Database = D
  public typealias ID = Int
  
  /// See Pivot.Left
  public typealias Left = Taste<Database>
  
  /// See Pivot.Right
  public typealias Right = TasteAction<Database>
  
  /// See Model.idKey
  public static var idKey: IDKey { return \.id }
  
  /// See Pivot.leftIDKey
  public static var leftIDKey: LeftIDKey { return \.tasteID }
  
  /// See Pivot.rightIDKey
  public static var rightIDKey: RightIDKey { return \.actionID }
  
  /// See Model.database
  public static var database: DatabaseIdentifier<D> {
    return .init("taste-action-pivot")
  }
  
  /// TasteAction's identifier
  var id: Int?
  
  /// The taste's id
  var tasteID: Int
  
  /// The action's id
  var actionID: Int
  
  //FIXME: This is a dirty hack to make Pivot fields unique, because (as far as I know) there is no way to make an idex on 2 fields.
  var pivotIDString : String
  
  public init(_ left: TasteActionPivot<D>.Left, _ right: TasteActionPivot<D>.Right) throws {
    tasteID = try left.requireID()
    actionID = try right.requireID()
    //FIXME: remove this when I figure out how to make a composite index
    pivotIDString = makeUnitedID(int1: tasteID, int2: actionID)
  }

}

extension TasteActionPivot: Migration where D: QuerySupporting, D: IndexSupporting, D: ReferenceSupporting { }

public struct TasteActionPivotMigration<D>: Migration where D: QuerySupporting & SchemaSupporting & IndexSupporting & ReferenceSupporting {
  
  public typealias Database = D
  
  //MARK: - Create Fields, Indexes and relations
  
  static func prepareFields(on connection: Database.Connection) -> Future<Void> {
    return Database.create(TasteActionPivot<Database>.self, on: connection) { builder in
      
      //add fields
      try builder.field(for: \TasteActionPivot<Database>.id)
      try builder.field(for: \TasteActionPivot<Database>.tasteID)
      try builder.field(for: \TasteActionPivot<Database>.actionID)
      //FIXME: remove this when I figure out how to make a composite index
      try builder.field(for: \TasteActionPivot<Database>.pivotIDString)
      
      //indexes
      try builder.addIndex(to: \.tasteID, \.actionID, isUnique: true)
      
      //FIXME: remove this when I figure out how to make a composite index
      try builder.addIndex(to: \.pivotIDString, isUnique: true)
      
      //referential integrity - foreign key to Taste
      try builder.addReference(from: \TasteActionPivot<D>.tasteID, to: \Taste<D>.id, actions: .init(update: .update, delete: .nullify))
      //referential integrity - foreign key to TasteAction
      try builder.addReference(from: \TasteActionPivot<D>.actionID, to: \TasteAction<D>.id, actions: .init(update: .update, delete: .nullify))
    }
  }

//MARK: - Required
  
  public static func prepare(on connection: D.Connection) -> EventLoopFuture<Void> {
    let futureCreateFields = prepareFields(on: connection)
//    let futureInsertData = prepareAddData(on: connection)
    let allFutures : [EventLoopFuture<Void>] = [futureCreateFields]
    return Future<Void>.andAll(allFutures, eventLoop: connection.eventLoop)
  }
  
  public static func revert(on connection: D.Connection) -> EventLoopFuture<Void> {
    return Database.delete(TasteActionPivot.self, on: connection)
  }

}
