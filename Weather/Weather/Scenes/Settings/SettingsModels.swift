
import UIKit

public struct SettingsList {
  public let settingsList = ["Home", "Add Location", "Reset Favourites", "Help"]
}
enum Settings
{
  // MARK: Use cases
  
  enum Something
  {
    struct Request
    {
    }
    struct Response
    {
        let settingsList: [String]
    }
    struct ViewModel
    {
        let settingsList: [String]
    }
  }
}
