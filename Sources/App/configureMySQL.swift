import FluentMySQL
import Vapor

/// Called before your application initializes.
///
/// https://docs.vapor.codes/3.0/getting-started/structure/#configureswift
public func configureMySQL(
  _ config: inout Config,
  _ env: inout Environment,
  _ services: inout Services
  ) throws {
  /// Register providers first
  try services.register(FluentMySQLProvider())
  
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
  let mysqlConfig = MySQLDatabaseConfig(
    hostname: Environment.get("MYSQL_HOSTNAME") ?? "127.0.0.1",
    username: Environment.get("MYSQL_USER") ?? "mentor",
    password: Environment.get("MYSQL_PASSWORD") ?? "changeme",
    database: Environment.get("MYSQL_DATABASE") ?? "mentor"
  )

  services.register(mysqlConfig)
  
  //Adds Fluent’s commands to the CommandConfig. Currently only the RevertCommand at "revert".
  var commandConfig = CommandConfig.default()
  commandConfig.useFluentCommands()
  services.register(commandConfig)
  
  /// Configure migrations
  var migrations = MigrationConfig()
  
  migrations.add(migration: ContinentMigration<MySQLDatabase>.self, database: .mysql)
  migrations.add(migration: CountryMigration<MySQLDatabase>.self, database: .mysql)
  
  services.register(migrations)
  
}


