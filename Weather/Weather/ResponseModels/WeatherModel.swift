
import Foundation

enum NetworkError: Error {
    case badURL, requestFailed, unKnownError
}

enum RequestType {
    case weather
    case forcast
}

public struct City: Codable{
    public let id: Int
    public let name: String
    public let country: String?
    public let population: Int?
    public let timezone: Int?
    public let sunrise: Int?
    public let sunset: Int?
}

public struct Coord: Codable {
    public let lon: Int
    public let lat: Int
}

public struct Weather: Codable {
    public let id: Int
    public let main: String
    public let description: String
    public let icon: String
}

public struct Main: Codable
{
    public let temp: Double?
    public let feels_like: Double?
    public let temp_min: Double?
    public let temp_max: Double?
    public let humidity: Int?
    public let sea_level: Int?
    public let grnd_level: Int?
}

public struct Wind: Codable {
    public let speed: Double
    public let deg: Double
}

public struct Clouds: Codable {
    public let all: Int
}

public struct Sys: Codable {
    public let type: Int?
    public let id: Int?
    public let message: Int?
    public let sunrise: Int?
    public let sunset: Int?
}

public struct Rain: Codable {
    public let h: String?
    
    public enum CodingKeys : String, CodingKey {
            case h = "3h"
        }
}

public struct TodayForeCast: Codable {
    public let weather: [Weather]
    public let base: String?
    public let main: Main?
    public let visibility: Int
    public let wind: Wind
    public let clouds: Clouds
    public let dt: Int
    public let id: Int?
    public let name: String?
    public let cod: Int?
}

public struct FiveDaysForeCast: Codable {
    public let cod: String
    public let message: Double
    public let cnt: Int
    public let city: City?
    public let list: [TodayForeCast]?
}
public struct Snow:Codable {
    
}

