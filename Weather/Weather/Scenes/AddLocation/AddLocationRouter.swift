
import UIKit

protocol AddLocationRouterInterface: class {
    func routeBackToPreviousController()
}

class AddLocationRouter: AddLocationRouterInterface {
  weak var viewController: AddLocationViewController?
  
    func routeBackToPreviousController() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
