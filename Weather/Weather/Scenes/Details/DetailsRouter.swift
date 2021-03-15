
import UIKit


protocol DetailsRouterInterface: class {
    func routeBackPreviousScreen()
}

class DetailsRouter: DetailsRouterInterface {
    weak var viewController: DetailsViewController?
    
    func routeBackPreviousScreen() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
