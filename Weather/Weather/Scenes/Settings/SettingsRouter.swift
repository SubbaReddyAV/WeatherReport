
import UIKit

//@objc protocol SettingsRoutingLogic
//{
//    //func routeToSomewhere(segue: UIStoryboardSegue?)
//}

protocol SettingsListRouterInterface {
    func navigateToDetails(indexPath: IndexPath)
}

//protocol SettingsDataPassing
//{
//    var dataStore: SettingsDataStore? { get }
//}

//NSObject, SettingsRoutingLogic, SettingsDataPassing,

class SettingsRouter: SettingsListRouterInterface
{
    weak var viewController: SettingsViewController?
    var dataStore: SettingsDataStore?
    
    
    func navigateToDetails(indexPath: IndexPath) {
        
        if indexPath.row == 3 {
            let storyboard = UIStoryboard(name: "Help", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
            viewController?.navigationController?.pushViewController(destinationVC, animated: true)
        }
        
    }
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
    
    //func navigateToSomewhere(source: SettingsViewController, destination: SomewhereViewController)
    //{
    //  source.show(destination, sender: nil)
    //}
    
    // MARK: Passing data
    
    //func passDataToSomewhere(source: SettingsDataStore, destination: inout SomewhereDataStore)
    //{
    //  destination.name = source.name
    //}
}
