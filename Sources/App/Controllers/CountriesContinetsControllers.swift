import Vapor
import Pagination

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

extension Country : Paginatable {
  public static var defaultPageSize: Int {
    return 20
  }
  
  public static var defaultPageSorts: [QuerySort] {
    return [
      QuerySort(field: QueryField(entity: self.entity, name: "name"), direction: .descending)
    ]
  }
  
  public static var defaultPageGroups: [QueryGroupBy] {
    return [
      QueryGroupBy.field(QueryField(entity: self.entity, name: "name"))
    ]
  }
}
extension Continent : Paginatable{
  public static var defaultPageSize: Int {
    return 20
  }
  
  public static var defaultPageSorts: [QuerySort] {
    return [
      QuerySort(field: QueryField(entity: self.entity, name: "name"), direction: .descending)
    ]
  }
  
  public static var defaultPageGroups: [QueryGroupBy] {
    return [
      QueryGroupBy.field(QueryField(entity: self.entity, name: "name"))
    ]
  }
}


struct CountriesController: RouteCollection {
  
  func boot(router: Router) throws {
    let aRoute = router.grouped("api", "countries")
    
    //GET /api/countries
    aRoute.get(use: getAllHandler)
    
    //GET /api/countries/:ID
    aRoute.get(CountrySQLite.parameter as PathComponentsRepresentable, use: getOneHandler)
    
    //GET /api/countries/:ID/continent
    aRoute.get(CountrySQLite.parameter as PathComponentsRepresentable, "continent", use: getContinentHandler)
  }
  
  func getAllHandler(_ req: Request) throws -> Future<[Country<SQLiteDatabase>]> {
    return CountrySQLite.query(on: req).all()
  }
  
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
