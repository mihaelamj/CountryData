import Async
import Fluent
import Foundation

public final class Country<D>: Model where D: QuerySupporting {
  
  public typealias Database = D
  
  //  public typealias ID = UUID
  public typealias ID = Int
  
  public static var idKey: IDKey { return \.id }
  
  public static var entity: String {
    return "testModel"
  }
  
  public static var database: DatabaseIdentifier<D> {
    return .init("test")
  }
  
  //  var id: UUID? //How can I make id an Int?
  var id: Int?
  
  var name: String
  
  var num : Int
  
  init(name: String, num: Int) {
    self.name = name
    self.num = num
  }
}
