
import UIKit
import MapKit

protocol AddLocationViewControllerInterface: class {
}

class AddLocationViewController: UIViewController, AddLocationViewControllerInterface {
    var interactor: AddLocationInteractorInterface?
    var router: AddLocationRouterInterface?
    let locationManager = CLLocationManager()
    
    @IBOutlet weak private var mapView: MKMapView!
    var searchViewController: UISearchController!
    
    private let locationListIdentifier = "LocationsTableViewController"
    private let storyBoardName = "LocationsList"
    
    private var locationName: String?
    private var countryName: String?
    private var selectedPin: MKPlacemark?
    
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
        
        let router = AddLocationRouter()
        router.viewController = viewController
        
        let presenter = AddLocationPresenter()
        presenter.viewController = viewController
        
        let interactor = AddLocationInteractor()
        viewController.interactor = interactor
        
        viewController.router = router
        interactor.presenter = presenter
        
        interactor.worker = WeatherWorker(store: WeatherRestStore())
    }
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false,
                                                          animated: true)
        self.navigationController?.navigationBar.backItem?.title = ""
        
    }
    
    private func setupSearchViewController() {
        let storyBoard = UIStoryboard(name: storyBoardName,
                                      bundle: nil)
        guard let locationVC = storyBoard.instantiateViewController(identifier: locationListIdentifier) as? LocationsTableViewController else { return }
        locationVC.handleMapSearchDelegate = self
        locationVC.mapView = mapView

        searchViewController = UISearchController(searchResultsController: locationVC)
        searchViewController.searchResultsUpdater = locationVC
        let searchBar = searchViewController.searchBar
        searchBar.placeholder = "Select for place"
        navigationItem.titleView = searchViewController?.searchBar

        searchViewController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    @objc func getDirections(){
        guard let selectedPin = selectedPin else { return }
        let mapItem = MKMapItem(placemark: selectedPin)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    
}

extension AddLocationViewController: HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark) {
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        annotation.subtitle = locationName
        
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func setupSearchText(cityName: String, countryName: String) {
        searchViewController.searchBar.text = cityName
        self.locationName = cityName
        self.countryName = countryName
    }
}

extension AddLocationViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            print("location:: \(location)")
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
}

extension AddLocationViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        
        guard !(annotation is MKUserLocation) else { return nil }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }
        
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button.setBackgroundImage(UIImage(systemName: "markLocation"), for: .normal)
        button.addTarget(self, action: #selector(AddLocationViewController.getDirections), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        showAlert()
        return pinView
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "", message: "Do you want to Add \(locationName ?? "")", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (_) in
            self.saveLocation()
            self.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    private func saveLocation() {
        let cityName: String = locationName ?? ""
        let country: String = countryName ?? ""
        let lat: CLLocationDegrees = selectedPin?.coordinate.latitude ?? 0
        let lon: CLLocationDegrees = selectedPin?.coordinate.longitude ?? 0
        let newLocation = LocationDetails(cityName: cityName,
                                          countryName: country,
                                          lat: lat,
                                          lon: lon)
        sessions.savedLocationa.append(newLocation)
        self.router?.routeBackToPreviousController()
    }
}

