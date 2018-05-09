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






