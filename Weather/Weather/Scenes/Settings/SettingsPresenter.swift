
import UIKit

protocol SettingsPresentationLogic
{
  func presentSomething(response: Settings.Something.Response)
}

class SettingsPresenter: SettingsPresentationLogic
{
  weak var viewController: SettingsDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: Settings.Something.Response)
  {
    let viewModel = Settings.Something.ViewModel(settingsList: response.settingsList)
    viewController?.displaySomething(viewModel: viewModel)
  }
}
