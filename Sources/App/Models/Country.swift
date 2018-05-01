import Async
import Fluent
import Foundation

public final class Country<D>: Model where D: QuerySupporting, D: IndexSupporting {
  
  public typealias Database = D
  
  public typealias ID = Int
  
  public static var idKey: IDKey { return \.id }
  
  public static var entity: String {
    return "testModel"
  }
  
  public static var database: DatabaseIdentifier<D> {
    return .init("test")
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
