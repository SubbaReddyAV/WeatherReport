
import UIKit

protocol HelpPresentationLogic
{
  func presentSomething(response: Help.Something.Response)
}

class HelpPresenter: HelpPresentationLogic
{
  weak var viewController: HelpDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: Help.Something.Response)
  {
    let viewModel = Help.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}
