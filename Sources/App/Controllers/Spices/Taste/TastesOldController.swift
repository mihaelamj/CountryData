import Vapor
import Fluent

extension TasteOld : Parameter{}
extension TasteOld : Content{}

public final class TastesOldController<D>: RouteCollection where D: QuerySupporting, D: IndexSupporting  {
  
  public typealias Database = D
  
  public func boot(router: Router) throws {
    let aRoute = router.grouped("api", "tastes")
    
    //GET /api/tastes
    aRoute.get(use: getAllHandler)
    
    //GET /api/tastes/:ID
    aRoute.get(Taste<D>.parameter as PathComponentsRepresentable, use: getOneHandler)
    
    //GET /api/tastes/test
//    aRoute.get("test", use: getAllTastes)
  }
  
  //MARK: Handlers -
  
  func getAllHandler(_ req: Request) throws -> Future<[Taste<D>]> {
    return Taste<D>.query(on: req).all()
  }
  
  func getOneHandler(_ req: Request) throws -> Future<Taste<D>> {
    return try req.parameters.next(Taste<D>.self)
  }
  
//  func testHandler(_ req: Request) throws -> Future<[Taste<D>]> {
//    return try Taste<D>.query(on: req).all()
//  }
  
  public typealias TasteDictionary = [String: Int]
  
  
//  func getAllTastes1(_ req: Request) throws -> Future<TasteDictionary> {
//    do {
//      return try TasteOld<D>.query(on: req).all().map(to: TasteDictionary.self) { tastes in
//        var dic : TasteDictionary = [:]
//        tastes.forEach({ taste in
//          dic[taste.name] = taste.id
//        })
//        debugPrint("dic: \(dic)")
//        return dic
//      }
//    } catch {
//      return req.eventLoop.newFailedFuture(error: error)
//    }
//  }
  
  func getAllTastes(_ req: Request) throws -> Future<TasteDictionary> {
    return Taste<D>.query(on: req).all().map(to: TasteDictionary.self) { tastes in
      var dic : TasteDictionary = [:]
      tastes.forEach({ taste in
        dic[taste.name] = taste.id
      })
      debugPrint("dic: \(dic)")
      return dic
    }
  }
  
}
