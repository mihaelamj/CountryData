import Foundation
import Fluent

//import FluentSQLite
//public typealias CountrySQLite = Country<SQLiteDatabase>
//public typealias ContinentSQLite = Continent<SQLiteDatabase>

//import FluentMySQL
//public typealias CountrySQLite = Country<MySQLDatabase>
//public typealias ContinentSQLite = Continent<MySQLDatabase>

//import FluentPostgreSQL
//public typealias CountrySQLite = Country<PostgreSQLDatabase>
//public typealias ContinentSQLite = Continent<PostgreSQLDatabase>

extension MigrationConfig {
  public mutating func addVaporCountries<D>(for database: DatabaseIdentifier<D>) where D: QuerySupporting & SchemaSupporting & IndexSupporting & ReferenceSupporting {
    Continent<D>.defaultDatabase = database
    self.add(migration: ContinentMigration<D>.self, database: database)
    Country<D>.defaultDatabase = database
    self.add(migration: CountryMigration<D>.self, database: database)
  }
}

extension MigrationConfig {
  public mutating func addVaporSpices<D>(for database: DatabaseIdentifier<D>) where D: QuerySupporting & SchemaSupporting & IndexSupporting & ReferenceSupporting {
    
    Form<D>.defaultDatabase = database
    self.add(migration: FormMigration<D>.self, database: database)
    
    Heat<D>.defaultDatabase = database
    self.add(migration: HeatMigration<D>.self, database: database)
    
    Technique<D>.defaultDatabase = database
    self.add(migration: TechniqueMigration<D>.self, database: database)
    
    Season<D>.defaultDatabase = database
    self.add(migration: SeasonMigration<D>.self, database: database)
    
    Volume<D>.defaultDatabase = database
    self.add(migration: VolumeMigration<D>.self, database: database)
    
    Weight<D>.defaultDatabase = database
    self.add(migration: WeightMigration<D>.self, database: database)
    
    Type<D>.defaultDatabase = database
    self.add(migration: TypeMigration<D>.self, database: database)
    
    Function<D>.defaultDatabase = database
    self.add(migration: FunctionMigration<D>.self, database: database)
    
    Heat<D>.defaultDatabase = database
    self.add(migration: HeatMigration<D>.self, database: database)
    
//    Taste<D>.defaultDatabase = database
//    self.add(migration: TasteMigration<D>.self, database: database)
  }
}

import Vapor
import Routing

public func addVaporCountriesRoutes<D>(for database: DatabaseIdentifier<D>, router: Router) throws where D: QuerySupporting & IndexSupporting & ReferenceSupporting {
  let continetsController = ContinentsController<D>()
  try router.register(collection: continetsController)
  
  let countriesController = CountriesController<D>()
  try router.register(collection: countriesController)
}

public func addVaporSpicesRoutes<D>(for database: DatabaseIdentifier<D>, router: Router) throws where D: QuerySupporting & IndexSupporting & ReferenceSupporting {
  let tastesController = TastesController<D>()
  try router.register(collection: tastesController)
}

//public extension Router {
//
//  public func addVaporCountriesRoutesDoesNotWork<D>(for database: DatabaseIdentifier<D>) throws where D: QuerySupporting & IndexSupporting & ReferenceSupporting {
//    let continetsController = ContinentsController<D>()
//    try self.register(collection: continetsController)
//
//    let countriesController = CountriesController<D>()
//    try self.register(collection: countriesController)
//  }
//}

//let continetsController = ContinentsController()
//try router.register(collection: countriesController)







