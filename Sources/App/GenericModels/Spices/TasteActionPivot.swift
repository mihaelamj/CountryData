import Async
import Fluent
import Foundation

/// A pivot between taste and action.
public final class TasteActionPivot<D>: ModifiablePivot where D: QuerySupporting {
 
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
  
  public init(_ taste: Taste<Database>, _ action: TasteAction<Database>) throws {
    tasteID = try taste.requireID()
    actionID = try action.requireID()
  }

}
