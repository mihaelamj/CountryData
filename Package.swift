// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "CountryData",
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0-rc.2"),
        
        //Databases
        .package(url: "https://github.com/vapor/fluent-sqlite.git", from: "3.0.0-rc.2"),
        .package(url: "https://github.com/vapor/fluent-postgresql.git", from: "1.0.0-rc.2"),
        .package(url: "https://github.com/vapor/fluent-mysql.git", from: "3.0.0-rc.2.3"),
      //Pagination
       .package(url: "https://github.com/vapor-community/pagination.git", from: "1.0.0-rc")
    ],
    targets: [
        .target(name: "App", dependencies: ["FluentSQLite", "FluentMySQL", "FluentPostgreSQL", "Vapor", "Pagination"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

