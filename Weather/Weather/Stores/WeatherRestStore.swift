
import Foundation

class WeatherRestStore: WeatherStoreProtocol {
    public init() { }
    
    private let urlSession = URLSession.shared
    private let baseURL = URL(string: "http://api.openweathermap.org/data/2.5/")!
    private let weatherEndPoint = "weather?q="
    private let forcastEndPoint = "forecast?q="
    private let apiKey = "&appid=fae7190d7e6433ec3a45285ffcf55c86"
    
    public func fetchForcastData(for city: String, completion: @escaping (Result<TodayForeCast, NetworkError>) -> Void) {
        
        let urlString = "\(baseURL)\(weatherEndPoint)\(city)\(apiKey)"
        
        // check the URL is OK, otherwise return with a failure
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            // the task has completed – push our work back to the main thread
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        // success: convert the data to a string and send it back
                        let todayForcastData = try JSONDecoder().decode(TodayForeCast.self, from: data)
                        completion(.success(todayForcastData))
                    }
                    catch {
                        completion(.failure(.requestFailed))
                    }
                } else if error != nil {
                    // any sort of network failure
                    completion(.failure(.requestFailed))
                } else {
                    // this ought not to be possible, yet here we are
                    completion(.failure(.unKnownError))
                }
            }
        }.resume()
    }
    
    public func fetchFivedaysForcastData(for city: String, completion: @escaping (Result<FiveDaysForeCast, NetworkError>) -> Void) {
        
        let urlString = "\(baseURL)\(forcastEndPoint)\(city)\(apiKey)"
        // check the URL is OK, otherwise return with a failure
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            // the task has completed – push our work back to the main thread
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        // success: convert the data to a string and send it back
                        let fivedaysForcastData = try JSONDecoder().decode(FiveDaysForeCast.self, from: data)
                        completion(.success(fivedaysForcastData))
                    }
                    catch {
                        
                    }
                } else if error != nil {
                    // any sort of network failure
                    completion(.failure(.requestFailed))
                } else {
                    // this ought not to be possible, yet here we are
                    completion(.failure(.unKnownError))
                }
            }
        }.resume()
    }
}
