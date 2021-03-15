
import UIKit
import Foundation

protocol HomeRouterInterface: class {
    func routeToHelpPage()
    func routeToAddLocation()
    func routeToLocationDetails(cityName: String)
    func routeToSettingsPage()
}

class HomeRouter: HomeRouterInterface {
    weak var viewController: HomeViewController?
    
    func routeToHelpPage() {
        let storyBoard = UIStoryboard(name: "Help",
                                      bundle: nil)
        guard let destinationVC = storyBoard.instantiateViewController(identifier: "HelpViewController") as? HelpViewController else { return }
        viewController?.navigationController?.pushViewController(destinationVC,
                                                                 animated: true)
    }
    
    func routeToAddLocation() {
        let storyBoard = UIStoryboard(name: "AddLocation",
                                      bundle: nil)
        guard let destinationVC = storyBoard.instantiateViewController(identifier: "AddLocationViewController") as? AddLocationViewController else { return }
        viewController?.navigationController?.pushViewController(destinationVC,
                                                                 animated: true)
    }
    
    func routeToLocationDetails(cityName: String) {
        let storyBoard = UIStoryboard(name: "Details",
                                      bundle: nil)
        guard let destinationVC = storyBoard.instantiateViewController(identifier: "DetailsViewController") as? DetailsViewController else { return }
        destinationVC.cityName = cityName
        viewController?.navigationController?.pushViewController(destinationVC,
                                                                 animated: true)
    }
    
    func routeToSettingsPage() {
        let storyBoard = UIStoryboard(name: "Settings",
                                      bundle: nil)
        guard let destinationVC = storyBoard.instantiateViewController(identifier: "SettingsViewController") as? SettingsViewController else { return }
        viewController?.navigationController?.pushViewController(destinationVC,
                                                                 animated: true)
    }
}
