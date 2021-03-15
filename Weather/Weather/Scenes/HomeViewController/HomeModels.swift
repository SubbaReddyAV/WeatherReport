
import UIKit
import CoreLocation

struct Home {
    struct GetCurrentLocationDetails {
        struct Request {
            let cityName: String
        }
        struct Response {
            let response: UserData
        }
        struct ViewModel {
            let response: TodayForeCast
        }
    }
}

enum UserData {
    case success(response: Any)
    case error(error: String)
}
