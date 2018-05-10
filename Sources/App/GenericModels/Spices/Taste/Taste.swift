//
//  Form.swift
//  App
//
//  Created by Mihaela Mihaljevic Jakic on 09/05/2018.
//
import Async
import Fluent
import Foundation

public final class Taste<D>: Model where D: QuerySupporting, D: IndexSupporting {
  
  public typealias Database = D
  public typealias ID = Int
  public static var idKey: IDKey { return \.id }
  public static var entity: String {
    return "taste"
  }
  public static var database: DatabaseIdentifier<D> {
    return .init("taste")
  }
  
  var id: Int?
  let name : String
  var description: String
  
  init(name: String, description: String) {
    self.name = name
    self.description = description
  }
  
//MARK: - Public Helper
  
  public static func getAllTastes(on connection: Database.Connection) throws -> Future<TasteDictionary> {
    return Taste<D>.query(on: connection).all().map(to: TasteDictionary.self) { tastes in
      var dic : TasteDictionary = [:]
      tastes.forEach({ taste in
        dic[taste.name] = taste.id
      })
      debugPrint("dic: \(dic)")
      return dic
    }
  }
  
}

extension Taste: Migration where D: QuerySupporting, D: IndexSupporting { }



//MARK: - Populating data

public struct TasteMigration<D>: Migration where D: QuerySupporting & SchemaSupporting & IndexSupporting {
  public typealias Database = D
  
  static func prepareFields(on connection: Database.Connection) -> Future<Void> {
    return Database.create(Taste<Database>.self, on: connection) { builder in
      
      //add fields
      try builder.field(for: \Taste<Database>.id)
      try builder.field(for: \Taste<Database>.name)
      try builder.field(for: \Taste<Database>.description)
      
      //indexes
      try builder.addIndex(to: \.name, isUnique: true)
    }
  }
  
  static func prepareInsertData(on connection: Database.Connection) ->  Future<Void>   {
    let futures : [EventLoopFuture<Void>] = tasteItems.map { name, desc in
      return Taste<D>(name: name, description: desc).create(on: connection).map(to: Void.self) { _ in return }
    }
    return Future<Void>.andAll(futures, eventLoop: connection.eventLoop)
  }
  
  public static func prepare(on connection: Database.Connection) -> Future<Void> {
    
    let futureCreateFields = prepareFields(on: connection)
    let futureInsertData = prepareInsertData(on: connection)
    
    let allFutures : [EventLoopFuture<Void>] = [futureCreateFields, futureInsertData]
    
    return Future<Void>.andAll(allFutures, eventLoop: connection.eventLoop)
  }
  
  public static func revert(on connection: Database.Connection) -> Future<Void> {
    do {
      // Delete all names
      let futures = try tasteItems.map { touple -> EventLoopFuture<Void> in
        let name = touple.0
        return try Taste<D>.query(on: connection).filter(\Taste.name, .equals, .data(name)).delete()
      }
      return Future<Void>.andAll(futures, eventLoop: connection.eventLoop)
    }
    catch {
      return connection.eventLoop.newFailedFuture(error: error)
    }
  }
}
