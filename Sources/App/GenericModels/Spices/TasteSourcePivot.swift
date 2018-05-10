import Async
import Fluent
import Foundation

/// A pivot between taste and action.
public final class TasteSourcePivot<D>: ModifiablePivot where D: QuerySupporting {
  
  public typealias Database = D
  public typealias ID = Int
  
  /// See Pivot.Left
  public typealias Left = Taste<Database>
  
  /// See Pivot.Right
  public typealias Right = TasteSource<Database>
  
  /// See Model.idKey
  public static var idKey: IDKey { return \.id }
  
  /// See Pivot.leftIDKey
  public static var leftIDKey: LeftIDKey { return \.tasteID }
  
  /// See Pivot.rightIDKey
  public static var rightIDKey: RightIDKey { return \.sourceID }
  
  /// See Model.database
  public static var database: DatabaseIdentifier<D> {
    return .init("taste-source-pivot")
  }
  
  /// TasteAction's identifier
  var id: Int?
  
  /// The taste's id
  var tasteID: Int
  
  /// The source'es id
  var sourceID: Int
  
  public init(_ taste: Taste<Database>, _ source: TasteAction<Database>) throws {
    tasteID = try taste.requireID()
    sourceID = try source.requireID()
  }
  
}

