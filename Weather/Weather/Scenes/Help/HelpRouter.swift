
import UIKit

@objc protocol HelpRoutingLogic
{
  //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol HelpDataPassing
{
  var dataStore: HelpDataStore? { get }
}

class HelpRouter: NSObject, HelpRoutingLogic, HelpDataPassing
{
  weak var viewController: HelpViewController?
  var dataStore: HelpDataStore?
  
  // MARK: Routing
  
  //func routeToSomewhere(segue: UIStoryboardSegue?)
  //{
  //  if let segue = segue {
  //    let destinationVC = segue.destination as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //  } else {
  //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
  //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //    navigateToSomewhere(source: viewController!, destination: destinationVC)
  //  }
  //}

  // MARK: Navigation
  
  //func navigateToSomewhere(source: HelpViewController, destination: SomewhereViewController)
  //{
  //  source.show(destination, sender: nil)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: HelpDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}
