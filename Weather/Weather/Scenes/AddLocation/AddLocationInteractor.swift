
import UIKit

protocol AddLocationInteractorInterface {
}

class AddLocationInteractor: AddLocationInteractorInterface {
  var presenter: AddLocationPresenterInterface?
  var worker: WeatherWorker?
  

}
