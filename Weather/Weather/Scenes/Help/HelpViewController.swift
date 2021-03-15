
import UIKit
import WebKit

protocol HelpDisplayLogic: class
{
  func displaySomething(viewModel: Help.Something.ViewModel)
}

class HelpViewController: UIViewController, HelpDisplayLogic
{
    @IBOutlet weak var helpWebView: WKWebView!
    var interactor: HelpBusinessLogic?
  var router: (NSObjectProtocol & HelpRoutingLogic & HelpDataPassing)?

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = HelpInteractor()
    let presenter = HelpPresenter()
    let router = HelpRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    title = "About App"
    doSomething()
  }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false,
                                                          animated: true)
    }
  // MARK: Do something
  
  //@IBOutlet weak var nameTextField: UITextField!
  
  func doSomething()
  {
    let request = Help.Something.Request()
    interactor?.doSomething(request: request)
  }
  
  func displaySomething(viewModel: Help.Something.ViewModel)
  {
    helpWebView.loadHTMLString(viewModel.helpContent, baseURL: nil)
  }
}
