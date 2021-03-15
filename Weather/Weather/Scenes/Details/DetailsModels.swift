
import UIKit

struct Details {
    struct GetCityWeatherDetails {
        struct Request {
            let cityName: String
        }
        
        struct Response {
            let response: UserData
        }
        
        struct Result {
            let displayData: TodayForeCast
        }
    }
    
    struct FiveDaysWeatherReport {
        struct Request {
            let cityName: String
        }
        
        struct Response {
            let response: UserData
        }
        
        struct Result {
            let displayData: FiveDaysForeCast
        }
    }
    
}
