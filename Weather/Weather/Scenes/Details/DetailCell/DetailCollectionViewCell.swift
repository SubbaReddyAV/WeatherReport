
import UIKit

struct WeatherDetails {
    let headerTitle: String
    let rain: String
    let temprature: String
    let humidity: String
    let wind: String
}
class DetailCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var rainLbl: UILabel!
    @IBOutlet weak var temperatureLbl: UILabel!
    @IBOutlet weak var humidityLbl: UILabel!
    @IBOutlet weak var windLbl: UILabel!

    func displayWeatherDetails(displayData: WeatherDetails) {
        headerLbl.text = displayData.headerTitle
        rainLbl.text = displayData.rain
        temperatureLbl.text = displayData.temprature
        humidityLbl.text = displayData.humidity
        windLbl.text = displayData.wind
    }
}
