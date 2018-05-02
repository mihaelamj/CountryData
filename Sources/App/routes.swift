import Routing
import Vapor

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {

  let continetsController = ContinentsController()
  try router.register(collection: continetsController)
  
  let countriesController = CountriesController()
  try router.register(collection: countriesController)

}
