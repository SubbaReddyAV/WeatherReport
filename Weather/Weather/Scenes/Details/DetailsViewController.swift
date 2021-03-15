
import UIKit

protocol DetailsViewControllerInterface: class {
    func displayCurrentCityWeatherReport(viewModel: Details.GetCityWeatherDetails.Result)
    func displayWeatherReportForFiveDays(viewModel: Details.FiveDaysWeatherReport.Result)
    func displayAlert(errorMessage: String)
}

class DetailsViewController: UIViewController, DetailsViewControllerInterface {
    @IBOutlet weak var detailCollectionView: UICollectionView!
    var interactor: DetailsInteractorInterface?
    var router: DetailsRouterInterface?
    var cityName: String?
    var weatherDetails: [TodayForeCast] = []
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    
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
        
        let router = DetailsRouter()
        router.viewController = viewController
        
        let presenter = DetailsPresenter()
        presenter.viewController = viewController

        let interactor = DetailsInteractor()
        interactor.presenter = presenter
        
        interactor.worker = WeatherWorker(store: WeatherRestStore())
        viewController.interactor = interactor
        viewController.router = router
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.getCurrentWeatherDetails(request: Details.GetCityWeatherDetails.Request(cityName: cityName ?? ""))
        title = "City Weather Details"
        detailCollectionView.register(UINib(nibName: "DetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "detailCell")
        detailCollectionView.reloadData()
        detailCollectionView.delegate = self
        detailCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false,
                                                          animated: true)
    }
    @IBAction func viewMoreWeatherReport(_ sender: Any) {
        interactor?.getWeatherReportForFiveDays(request: Details.FiveDaysWeatherReport.Request(cityName: cityName ?? ""))
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = detailCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        if ((UIApplication.shared.windows
                .first?
                .windowScene?
                .interfaceOrientation
                .isLandscape) != nil) {
            //here you can do the logic for the cell size if phone is in landscape
        } else {
            //logic if not landscape
        }
        flowLayout.invalidateLayout()
    }
    // MARK: Do something
    func displayCurrentCityWeatherReport(viewModel: Details.GetCityWeatherDetails.Result) {
        weatherDetails.removeAll()
        let displayData = viewModel.displayData
        cityNameLabel.text = displayData.name
        let temp = displayData.main?.temp?.convertToTemperature()
        weatherLabel.text = temp
        weatherDetails.append(displayData)
        detailCollectionView.reloadData()
    }
    
    func displayWeatherReportForFiveDays(viewModel: Details.FiveDaysWeatherReport.Result) {
        weatherDetails.removeAll()
        guard let displayData = viewModel.displayData.list else { return }
        for data in displayData {
            weatherDetails.append(data)
        }
        detailCollectionView.reloadData()
    }
    
    func displayAlert(errorMessage: String) {
        let alertVC = UIAlertController.init(title: "",
                                             message: errorMessage,
                                             preferredStyle: .alert)
        let okButton = UIAlertAction.init(title: "Ok",
                                          style: .default,
                                          handler: nil)
        alertVC.addAction(okButton)
        present(alertVC,
                animated: true,
                completion: nil)
    }
    
}

extension DetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherDetails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailCell", for: indexPath) as! DetailCollectionViewCell
        let displayData = weatherDetails[indexPath.row]
        let temp = displayData.main?.temp?.convertToTemperature()
        let humidity = "\(displayData.main?.humidity ?? 0)%"
        let windSpeed = "\(displayData.wind.speed) km/h"
        let date: String = displayData.dt.convertDateFormatter()
        let cellData = WeatherDetails(headerTitle: date,
                                      rain: "NA",
                                      temprature: temp ?? "",
                                      humidity: humidity,
                                      wind: "\(windSpeed)")
        cell.displayWeatherDetails(displayData: cellData)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width, height: 145)
    }
    
}


