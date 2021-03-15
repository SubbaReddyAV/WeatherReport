
import UIKit
import CoreLocation
protocol HomeInteractorInterface: class {
    func getCurrentLocationData(request: Home.GetCurrentLocationDetails.Request)
}

class HomeInteractor: HomeInteractorInterface {
    var presenter: HomePresenterInterface?
    var worker: WeatherWorker?
    
    func getCurrentLocationData(request: Home.GetCurrentLocationDetails.Request) {
        worker?
            .getCurrentLocationDetails(request: request,
                                       completion: { response in
                                        
                                        
                                        switch response {
                                        case .success(let data):
                                            let response: TodayForeCast = data
                                            let presenterResponse = Home.GetCurrentLocationDetails.Response(response: .success(response: response))
                                            self.presenter?.presentCurrentLocationWeatherDetails(responseData: presenterResponse)
                                        case .failure(let fail):
                                            let presenterResponse = Home.GetCurrentLocationDetails.Response(response: .error(error: fail.localizedDescription))
                                            self.presenter?.presentCurrentLocationWeatherDetails(responseData: presenterResponse)
                                        }
                                       })
    }
}
