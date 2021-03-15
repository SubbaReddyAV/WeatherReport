
import UIKit

protocol SettingsDisplayLogic: class
{
    func displaySomething(viewModel: Settings.Something.ViewModel)
}

class SettingsViewController: UIViewController, SettingsDisplayLogic
{
    @IBOutlet weak var settingsTableView: UITableView!
    var settingsList: [String] = []
    var interactor: SettingsBusinessLogic?
//    var router: (NSObjectProtocol & SettingsRoutingLogic & SettingsDataPassing )?
    
    var router: SettingsListRouterInterface!
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
        let interactor = SettingsInteractor()
        let presenter = SettingsPresenter()
        let router = SettingsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
//    {
//        if let scene = segue.identifier {
//            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
//            if let router = router, router.responds(to: selector) {
//                router.perform(selector, with: segue)
//            }
//        }
//    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableViewSetUp()
        doSomething()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false,
                                                          animated: true)
        self.navigationController?.navigationBar.backItem?.title = "Settings"
        title = "Settings"
    }
    
    private func tableViewSetUp() {
        settingsTableView.rowHeight = UITableView.automaticDimension
        settingsTableView.estimatedRowHeight = 40
        settingsTableView.separatorInset = UIEdgeInsets.zero
        settingsTableView.tableFooterView = UIView()
    }
    
    // MARK: Do something
    
    func doSomething()
    {
        let request = Settings.Something.Request()
        interactor?.doSomething(request: request)
    }
    
    func displaySomething(viewModel: Settings.Something.ViewModel)
    {
        settingsList = viewModel.settingsList
        settingsTableView.reloadData()
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = settingsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // set the text from the data model
        cell.textLabel?.text = settingsList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router.navigateToDetails(indexPath: indexPath)
    }
}
