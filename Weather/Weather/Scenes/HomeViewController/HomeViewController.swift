
import UIKit
import CoreLocation

protocol HomeViewControllerInterface: class {
    func displayCurrentLocationWeatherData(viewModel: Home.GetCurrentLocationDetails.ViewModel)
    func showAlert(alertMessege: String)
}

class HomeViewController: UIViewController, HomeViewControllerInterface {
    
    // IBOutlets
    @IBOutlet weak private var backGroundImage: UIImageView!
    @IBOutlet weak private var headerView: UIView!
    @IBOutlet weak private var addButton: UIButton!
    @IBOutlet weak private var settingsButton: UIButton!
    
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var weatherLabel1: UILabel!
    @IBOutlet weak private var weatherLabel2: UILabel!
    @IBOutlet weak private var weatherLabel3: UILabel!
    @IBOutlet weak private var weatherLabel4: UILabel!
    
    @IBOutlet weak private var bookMarksContentView: UIView!
    @IBOutlet weak private var bookMarksTitleLabel: UILabel!
    @IBOutlet weak private var locationsTableView: UITableView!
    
    var interactor: HomeInteractorInterface?
    var router: HomeRouterInterface?
    
    private let cellIdentifier: String = "LocationTableViewCell"
    private let locationManager = CLLocationManager()
    
    private var sessions = SessionsDataManager.shared
    
    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    private func setup() {
        let viewController = self
        let router = HomeRouter()
        router.viewController = viewController
        
        let presenter = HomePresenter()
        presenter.viewController = viewController
        
        let interactor = HomeInteractor()
        interactor.presenter = presenter
        interactor.worker = WeatherWorker(store: WeatherRestStore())
        viewController.interactor = interactor
        viewController.router = router
    }
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getCurrentLocation()
        resetData()
    }
    
    private func setupUI() {
        bookMarksContentView.roundCorners(corners: [.topRight, .topLeft],
                                          radius: 8)
        locationsTableView.delegate = self
        locationsTableView.dataSource = self
        locationsTableView.register(UINib(nibName: cellIdentifier,
                                          bundle: nil),
                                    forCellReuseIdentifier: cellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true,
                                                          animated: true)
        
        if !sessions.savedLocationa.isEmpty {
            locationsTableView.reloadData()
        }
    }
    // MARK: Do something
    
    @IBAction func addLocationTapped(_ sender: Any) {
        router?.routeToAddLocation()
    }
    @IBAction func settingsTapped(_ sender: Any) {
        router?.routeToSettingsPage()
    }
    
    private func getCurrentLocation() {
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK:- Display logics
    func displayCurrentLocationWeatherData(viewModel: Home.GetCurrentLocationDetails.ViewModel) {
        let response = viewModel.response
        let temp = response.main?.temp?.convertToTemperature()
        weatherLabel1.text = response.name ?? "__"
        weatherLabel2.text = response.weather[0].main
        weatherLabel3.text = temp
        weatherLabel4.text = response.weather[0].description
    }
    
    func showAlert(alertMessege: String) {
        let alertVC = UIAlertController.init(title: "",
                                             message: alertMessege,
                                             preferredStyle: .alert)
        let okButton = UIAlertAction.init(title: "Ok",
                                          style: .default,
                                          handler: nil)
        alertVC.addAction(okButton)
        resetData()
        present(alertVC,
                animated: true,
                completion: nil)
    }
    
    private func resetData() {
        weatherLabel1.text = "__"
        weatherLabel2.text = "__"
        weatherLabel3.text = "__"
        weatherLabel4.text = "__"
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bookMarksContentView.isHidden = sessions.savedLocationa.isEmpty
        return sessions.savedLocationa.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? LocationTableViewCell else {
            return UITableViewCell()
        }
        cell.updateCell(location1: sessions.savedLocationa[indexPath.row].cityName,
                        location2: sessions.savedLocationa[indexPath.row].countryName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.routeToLocationDetails(cityName: sessions.savedLocationa[indexPath.row].cityName)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            sessions.savedLocationa.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("error:: \(error.localizedDescription)")
       }

       func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
           if status == .authorizedWhenInUse {
               locationManager.requestLocation()
           }
       }

       func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

           if locations.first != nil {
               print("location:: (location)")
           }
        
        guard let coordinates: CLLocationCoordinate2D = manager.location?.coordinate else { return }
              getCityName(coordinates: coordinates)

       }

    private func getCityName(coordinates: CLLocationCoordinate2D) {
        guard Reachability().connectedToNetwork() else {
            print("No internet")
            return
        }
        ActivityIndicator.start(style: .large, backColor: .white, baseColor: .white)
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: coordinates.latitude,
                                  longitude: coordinates.longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { [self] (placemarks, _) -> Void in
            placemarks?.forEach { (placemark) in
                if let city = placemark.locality {
                    let reequest = Home.GetCurrentLocationDetails.Request(cityName: city)
                    interactor?.getCurrentLocationData(request: reequest)
                }
            }
        })
        locationManager.stopUpdatingLocation()
        ActivityIndicator.stop()
    }
}
