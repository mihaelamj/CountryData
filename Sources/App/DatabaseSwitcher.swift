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
    
    Taste<D>.defaultDatabase = database
    self.add(migration: TasteMigration<D>.self, database: database)
  }
}






