
import UIKit

protocol HelpBusinessLogic
{
  func doSomething(request: Help.Something.Request)
}

protocol HelpDataStore
{
  //var name: String { get set }
}

class HelpInteractor: HelpBusinessLogic, HelpDataStore
{
  var presenter: HelpPresentationLogic?
  var worker: HelpWorker?
  //var name: String = ""
  
  // MARK: Do something
  
  func doSomething(request: Help.Something.Request)
  {
    worker = HelpWorker()
    worker?.doSomeWork()
    
    let response = Help.Something.Response()
    presenter?.presentSomething(response: response)
  }
}
