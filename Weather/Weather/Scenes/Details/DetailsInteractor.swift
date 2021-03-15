
import UIKit

protocol DetailsInteractorInterface: class {
    func getCurrentWeatherDetails(request: Details.GetCityWeatherDetails.Request)
    func getWeatherReportForFiveDays(request: Details.FiveDaysWeatherReport.Request)
}

class DetailsInteractor: DetailsInteractorInterface {
    var presenter: DetailsPresenterInterface?
    var worker: WeatherWorker?
    
    func getCurrentWeatherDetails(request: Details.GetCityWeatherDetails.Request) {
        let request = Home.GetCurrentLocationDetails.Request(cityName: request.cityName)
        worker?
            .getCurrentLocationDetails(request: request,
                                       completion: { response in
                                        switch response {
                                        case .success(let data):
                                            let response: TodayForeCast = data
                                            let presenterResponse = Details.GetCityWeatherDetails.Response(response: .success(response: response))
                                            self.presenter?.presentCurrentCityWeather(response: presenterResponse)
                                        case .failure(let fail):
                                            let presenterResponse = Details.GetCityWeatherDetails.Response(response: .error(error: fail.localizedDescription))
                                            self.presenter?.presentCurrentCityWeather(response: presenterResponse)
                                        }
                                       })
    }
    
    func getWeatherReportForFiveDays(request: Details.FiveDaysWeatherReport.Request) {
        let request: Home.GetCurrentLocationDetails.Request = .init(cityName: request.cityName)
        worker?
            .fetchFivedaysForcastData(for: request.cityName,
                                      completion: { [weak self] response in
                                        switch response {
                                        case .success(let data):
                                            let responseData: FiveDaysForeCast = data
                                            self?.presenter?.presentWeatherReportForFiveDays(response: Details.FiveDaysWeatherReport.Response(response: .success(response: responseData)))
                                        case .failure(let error):
                                            self?.presenter?.presentWeatherReportForFiveDays(response: Details.FiveDaysWeatherReport.Response(response: .error(error: error.localizedDescription)))
                                        }
                                      })
    }
}
