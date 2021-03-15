
import UIKit

protocol SettingsBusinessLogic
{
  func doSomething(request: Settings.Something.Request)
}

protocol SettingsDataStore
{
  //var name: String { get set }
}

class SettingsInteractor: SettingsBusinessLogic, SettingsDataStore
{
  var presenter: SettingsPresentationLogic?
    let model = SettingsList()
  
  // MARK: Do something
  
  func doSomething(request: Settings.Something.Request)
  {
    let response = Settings.Something.Response(settingsList: model.settingsList)
    presenter?.presentSomething(response: response)
  }
}
