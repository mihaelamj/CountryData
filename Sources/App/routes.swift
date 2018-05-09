import Routing
import Vapor

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {

  let continetsController1 = ContinentsController1()
  try router.register(collection: continetsController1)
  
  let countriesController1 = CountriesController1()
  try router.register(collection: countriesController1)
  
//  let continetsController = ContinentsController()
//  try router.register(collection: countriesController)

}
