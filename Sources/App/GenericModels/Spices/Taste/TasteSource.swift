import Async
import Fluent
import Foundation

public final class TasteSource<D>: Model where D: QuerySupporting, D: IndexSupporting {
  public typealias Database = D
  public typealias ID = Int
  public static var idKey: IDKey { return \.id }
  public static var entity: String {
    return "taste-source"
  }
  public static var database: DatabaseIdentifier<D> {
    return .init("taste-source")
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
extension TasteSource: Migration where D: QuerySupporting, D: IndexSupporting { }

//MARK: - Populating data


