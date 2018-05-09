import FluentSQLite
import Vapor

/// Called before your application initializes.
///
/// https://docs.vapor.codes/3.0/getting-started/structure/#configureswift
public func configureSQLite(
  _ config: inout Config,
  _ env: inout Environment,
  _ services: inout Services
  ) throws {
  /// Register providers first
  try services.register(FluentSQLiteProvider())
  
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
  
  // Configure a SQLite database
  let sqlite: SQLiteDatabase
  if env.isRelease {
    /// Create file-based SQLite db using $SQLITE_PATH from process env
    sqlite = try SQLiteDatabase(storage: .file(path: Environment.get("SQLITE_PATH")!))
  } else {
    let directory = DirectoryConfig.detect()
    services.register(directory)
    let filePath = "\(directory.workDir)countries.db"
    sqlite = try SQLiteDatabase(storage: .file(path: filePath))
    debugPrint("\(filePath)")
    /// Create an in-memory SQLite database
//    sqlite = try SQLiteDatabase(storage: .memory)
  }
  
  /// Register the configured SQLite database to the database config.
  var databases = DatabasesConfig()
  databases.add(database: sqlite, as: .sqlite)
  services.register(databases)
  
  /// Configure migrations
  var migrations = MigrationConfig()
  
  //test SQLite
  Continent<SQLiteDatabase>.defaultDatabase = .sqlite
  Country<SQLiteDatabase>.defaultDatabase = .sqlite
  
  Form<SQLiteDatabase>.defaultDatabase = .sqlite
  Heat<SQLiteDatabase>.defaultDatabase = .sqlite
  
  migrations.add(migration: ContinentMigration<SQLiteDatabase>.self, database: .sqlite)
  migrations.add(migration: CountryMigration<SQLiteDatabase>.self, database: .sqlite)
  
  migrations.add(migration: FormMigration<SQLiteDatabase>.self, database: .sqlite)
  migrations.add(migration: HeatMigration<SQLiteDatabase>.self, database: .sqlite)
  
  services.register(migrations)
  
}
