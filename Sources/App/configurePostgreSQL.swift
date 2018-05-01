import FluentPostgreSQL
import Vapor

/// Called before your application initializes.
///
/// https://docs.vapor.codes/3.0/getting-started/structure/#configureswift
public func configurePostgreSQL(
  _ config: inout Config,
  _ env: inout Environment,
  _ services: inout Services
  ) throws {
  /// Register providers first
  try services.register(FluentPostgreSQLProvider())
  
  /// Register routes to the router
  let router = EngineRouter.default()
  try routes(router)
  services.register(router, as: Router.self)
  
  /// Register middleware
  var middlewares = MiddlewareConfig() // Create _empty_ middleware config
  /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
  middlewares.use(DateMiddleware.self) // Adds `Date` header to responses
  middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
  services.register(middlewares)
  
  // Configure a database
  let psqlConfig = PostgreSQLDatabaseConfig(hostname: "localhost", port: 5432, username: "vapor", password: "password")
  var dbConfig = DatabaseConfig()
  
  let database = PostgreSQLDatabase(config: psqlConfig)
  dbConfig.add(database: database, as: .psql)
  services.register(dbConfig)
  
  //Adds Fluent’s commands to the CommandConfig. Currently only the RevertCommand at "revert".
  var commandConfig = CommandConfig.default()
  commandConfig.useFluentCommands()
  services.register(commandConfig)
  
  /// Configure migrations
  var migrations = MigrationConfig()
  
  //Generic Test Migration
  
  migrations.add(migration: ContinentMigration<PostgreSQLDatabase>.self, database: .psql)
  migrations.add(migration: CountryMigration<PostgreSQLDatabase>.self, database: .psql)
  
  services.register(migrations)
  
}

