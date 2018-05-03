import Vapor
//import Pagination

//Choose you DB provider

//Typecast the generic model to appropriate DB type
import FluentSQLite
public typealias CountrySQLite = Country<SQLiteDatabase>
public typealias ContinentSQLite = Continent<SQLiteDatabase>

//import FluentMySQL
//public typealias CountrySQLite = Country<MySQLDatabase>
//public typealias ContinentSQLite = Continent<MySQLDatabase>
//
//import FluentPostgreSQL
//public typealias CountrySQLite = Country<PostgreSQLDatabase>
//public typealias ContinentSQLite = Continent<PostgreSQLDatabase>


//protocol conformances
extension Country : Parameter{}
extension Country : Content{}
extension Continent : Parameter{}
extension Continent : Content{}

//extension Country where Database == SQLiteDatabase : Paginatable {
//
//}
//public protocol Paginatable: Model where Self.Database: QuerySupporting {
//public final class Country<D>: Model where D: QuerySupporting, D: IndexSupporting {

//Constrained extension must be declared on the unspecialized generic type 'Country' with constraints specified by a 'where' clause
//extension Country where  Model: Paginatable {
//  
//  public static var defaultPageSize: Int {
//    return 20
//  }
//  
//  public static var defaultPageSorts: [QuerySort] {
//    return [
//      QuerySort(field: QueryField(entity: self.entity, name: "name"), direction: .descending)
//    ]
//  }
//  
//  public static var defaultPageGroups: [QueryGroupBy] {
//    return [
//      QueryGroupBy.field(QueryField(entity: self.entity, name: "name"))
//    ]
//  }
//  
//}
//Constrained extension must be declared on the unspecialized generic type
//'Country' with constraints specified by a 'where' clause
//extension CountrySQLite where T: Paginatable {
//  public static var defaultPageSize: Int {
//    return 20
//  }
//
//  public static var defaultPageSorts: [QuerySort] {
//    return [
//      QuerySort(field: QueryField(entity: self.entity, name: "name"), direction: .descending)
//    ]
//  }
//
//  public static var defaultPageGroups: [QueryGroupBy] {
//    return [
//      QueryGroupBy.field(QueryField(entity: self.entity, name: "name"))
//    ]
//  }
//}
//extension Continent : Paginatable {
//  public static var defaultPageSize: Int {
//    return 20
//  }
//
//  public static var defaultPageSorts: [QuerySort] {
//    return [
//      QuerySort(field: QueryField(entity: self.entity, name: "name"), direction: .descending)
//    ]
//  }
//
//  public static var defaultPageGroups: [QueryGroupBy] {
//    return [
//      QueryGroupBy.field(QueryField(entity: self.entity, name: "name"))
//    ]
//  }
//}


struct CountriesController: RouteCollection {
  
  func boot(router: Router) throws {
    let aRoute = router.grouped("api", "countries")
    
    //GET /api/countries
//    aRoute.get(use: getAllHandler)
    aRoute.get(use: getAllPaginatedHandler)
    
    //GET /api/countries/paginated
    aRoute.get("paginated", use: getAllPaginatedHandler)
    
    //GET /api/countries/:ID
    aRoute.get(CountrySQLite.parameter as PathComponentsRepresentable, use: getOneHandler)
    
    //GET /api/countries/:ID/continent
    aRoute.get(CountrySQLite.parameter as PathComponentsRepresentable, "continent", use: getContinentHandler)
  }
  
  func getAllHandler(_ req: Request) throws -> Future<[CountrySQLite]> {
    return CountrySQLite.query(on: req).all()
  }
  
  //return try team.users.query(on: req).paginate(on: req).all()
  //GET http://localhost:8080/api/countries?limit=20&page=1
  func getAllPaginatedHandler(_ req: Request) throws -> Future<[CountrySQLite]> {
    return try CountrySQLite.query(on: req).paginate(on: req).all()
  }
  
//  func getAllPaginatedHandler(_ req: Request) throws -> Future<Paginated<[CountrySQLite]>> {
////    return CountrySQLite.query(on: req).filt
//    return try CountrySQLite.query(on: req).paginate(for: req)
//  }
  
  func getOneHandler(_ req: Request) throws -> Future<CountrySQLite> {
    return try req.parameters.next(Country.self)
  }
  
  func getContinentHandler(_ req: Request) throws -> Future<ContinentSQLite> {
    return try req.parameters.next(CountrySQLite.self).flatMap(to: ContinentSQLite.self) { country in
      return try country.continent!.get(on: req)
    }
  }
  
}

struct ContinentsController: RouteCollection {
  
  func boot(router: Router) throws {
    let aRoute = router.grouped("api", "continets")
    
    //GET /api/continets
    aRoute.get(use: getAllHandler)
    
    //GET /api/continents/:continentID
    aRoute.get(ContinentSQLite.parameter, use: getOne)
    
    //GET /api/continents/:continentID/countries
    aRoute.get(ContinentSQLite.parameter, "countries", use: getCountriesHandler)
  }
  
  func getAllHandler(_ req: Request) throws -> Future<[ContinentSQLite]> {
    return Continent.query(on: req).all()
  }
  
  func getOne(_ req: Request) throws -> Future<ContinentSQLite> {
    return try req.parameters.next(Continent.self)
  }
  
  func getCountriesHandler(_ req: Request) throws -> Future<[CountrySQLite]> {
    return try req.parameters.next(ContinentSQLite.self).flatMap(to: [CountrySQLite].self) { continent in
      return try continent.countries.query(on: req).all()
    }
  }
  
}
