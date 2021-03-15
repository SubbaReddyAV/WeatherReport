
import UIKit

protocol DetailsPresenterInterface: class {
    func presentCurrentCityWeather(response: Details.GetCityWeatherDetails.Response)
    func presentWeatherReportForFiveDays(response: Details.FiveDaysWeatherReport.Response)
}

class DetailsPresenter: DetailsPresenterInterface {
  weak var viewController: DetailsViewControllerInterface?
  
    func presentCurrentCityWeather(response: Details.GetCityWeatherDetails.Response) {
        switch response.response {
        case .success(let response):
            guard let data = response as? TodayForeCast else { return }
            viewController?.displayCurrentCityWeatherReport(viewModel: Details.GetCityWeatherDetails.Result(displayData: data))
        case .error(let error):
            viewController?.displayAlert(errorMessage: error.debugDescription)
        }
    }
    func presentWeatherReportForFiveDays(response: Details.FiveDaysWeatherReport.Response) {
        switch response.response {
        case .success(let response):
            guard let data = response as? FiveDaysForeCast else { return }
            viewController?.displayWeatherReportForFiveDays(viewModel: Details.FiveDaysWeatherReport.Result(displayData: data))
        case .error(let error):
            viewController?.displayAlert(errorMessage: error.debugDescription)
        }
    }
}
