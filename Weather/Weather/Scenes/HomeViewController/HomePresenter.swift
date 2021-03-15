
import UIKit

protocol HomePresenterInterface {
    func presentCurrentLocationWeatherDetails(responseData: Home.GetCurrentLocationDetails.Response)
}

class HomePresenter: HomePresenterInterface {
  weak var viewController: HomeViewControllerInterface?
  
    func presentCurrentLocationWeatherDetails(responseData: Home.GetCurrentLocationDetails.Response) {
        switch responseData.response {
        case .success(let response):
            guard let data = response as? TodayForeCast else { return }
            viewController?.displayCurrentLocationWeatherData(viewModel: Home.GetCurrentLocationDetails.ViewModel(response: data))
        case .error(let error):
            viewController?.showAlert(alertMessege: error)
        }
    }

}
