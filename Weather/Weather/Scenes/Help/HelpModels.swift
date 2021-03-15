
import UIKit

enum Help
{
  // MARK: Use cases
  
  enum Something
  {
    struct Request
    {
    }
    struct Response
    {
        let helpContent = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 150%; } </style>
        </head>
        <body>
        Using this ap user  can select any city as his favourite one. So it will add to cities list in home screen. By selecting the any city user can see the current weather information. If user wants to know about the past and future related weather information he can do it by selecting the more option.
        </body>
        </html>
        """
    }
    struct ViewModel
    {
        let helpContent = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 150%; } </style>
        </head>
        <body>
        Using this ap user  can select any city as his favourite one. So it will add to cities list in home screen. By selecting the any city user can see the current weather information. If user wants to know about the past and future related weather information he can do it by selecting the more option.
        </body>
        </html>
        """
    }
  }
}
