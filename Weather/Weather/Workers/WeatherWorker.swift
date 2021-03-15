import Foundation
import CoreLocation

protocol WeatherStoreProtocol: class {
    func fetchForcastData(for city: String, completion: @escaping (Result<TodayForeCast, NetworkError>) -> Void)
    func fetchFivedaysForcastData(for city: String, completion: @escaping (Result<FiveDaysForeCast, NetworkError>) -> Void)
}

public class WeatherWorker {
    
    var store: WeatherStoreProtocol
    private let locationManager = CLLocationManager()
    
    init(store: WeatherStoreProtocol) {
        self.store = store
    }
    
    func getCurrentLocationDetails(request: Home.GetCurrentLocationDetails.Request, completion: @escaping (Result<TodayForeCast, NetworkError>) -> Void) {
        store.fetchForcastData(for: request.cityName, completion: completion)
    }
    
    func fetchFivedaysForcastData(for city: String, completion: @escaping (Result<FiveDaysForeCast, NetworkError>) -> Void) {
        store.fetchFivedaysForcastData(for: city, completion: completion)
    }
}


