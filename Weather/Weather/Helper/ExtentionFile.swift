import Foundation
import UIKit

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius,
                                                    height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func setupRoundShape() {
        self.layer.cornerRadius = self.frame.width / 2;
        self.layer.masksToBounds = true;
    }
}

extension Int {
    func convertDateFormatter() -> String {
        let timeInterval = TimeInterval(self)
        let myNSDate = Date(timeIntervalSince1970: timeInterval)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: myNSDate)
        return "\(date)"
    }
}
extension Double {
    func convertToTemperature() -> String {
        let tempratureType = SessionsDataManager.shared.tempratureType
        switch tempratureType {
        case .celsius:
            let celsius = convertTemp(temp: self,
                                      from: .kelvin,
                                      to: .celsius)
            return celsius
        case .fahrenheit:
            let fahrenheit = convertTemp(temp: self,
                                         from: .kelvin,
                                         to: .fahrenheit)
            return fahrenheit
        }
    }
    
    private func convertTemp(temp: Double, from inputTempType: UnitTemperature, to outputTempType: UnitTemperature) -> String {
        let measurementFormate = MeasurementFormatter()
        measurementFormate.numberFormatter.maximumFractionDigits = 0
        measurementFormate.unitOptions = .providedUnit
       let input = Measurement(value: temp, unit: inputTempType)
       let output = input.converted(to: outputTempType)
       return measurementFormate.string(from: output)
     }
}
