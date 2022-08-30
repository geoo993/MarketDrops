# MarketDrops
A small project to display the upcoming initial public offerings in USA Stock Exchanges.
It has 2 Tabs, one for the list of IPO's and the second for the user Favourites IPO stocks.

Overal this project aims to demostrate many iOS app development techniques and features.


## What is Featured

### Provider
The providers of the financial data are:
- [Finnhub](https://finnhub.io/) provides the ipo lists and filings infomation
- [Marketaux](https://www.marketaux.com/) provides the financial news of stocks in the stocks market. 

### SwiftUI 
- Using `SwiftUI` Views, Modifiers and ViewBuilders.
- Using States, Observables and Bindings

#### Modules
The project is seperated into different module to represent clean architecture and SOLID principles
- `MarketDropsCore` contains app wide common functionalities 
- `MarketDropsRouting` layer handles navigation and deeplinking, where previously in UIKit it would be referred as the Coordinator.
- `MarketDropsAPIClient` has the API client requests (i.e Finnhub and Marketaux) and their Entities
- `MarketDropsDomain` layer represents the Domain use cases of each entity
- `MarketDrops` is the main application target which contains the Presentation and Data Layer 

### Tests
- All modules are tested with unit tests and the project had code coverage enabled.

### Error Handling
Should errors occur when using the financial API's, users will be notified with an `Alert`.

### Deeplinking
The supported deeplinks are as follows:
- `applink:///ipo`
- `applink:///ipo?symbol=BIAF&date=2022-08-30&status=expected`
- `applink:///favourites`

### Combine
- Most API's and developed using `Combine`

### Image caching
Images loaded for financial news are cached and reused

### Persistence
The persistence mechanism used is `UserDefaults`, other options could have been `Core Data` or `File Manager` but since we only needed to store symbols. UserDefaults was simple enough.

### Localisation
The project uses Localizable strings, but currently only for English language.

### Light and Dark mode
`Colors` support `Light` and `Dark` mode.

### Haptic Feedback
`Haptics` feedbacks are embeded in NavigationBar items and List items.

### Empty state
When a user still hasn't selected a favourite stock, they are presented with an `Empty state` prompting them to select their favourite stock.

### Design Pattern
The app design pattern and infrastructure is inspired by [Pointfree](https://www.pointfree.co/), it follows [The Composible Architecture](https://github.com/pointfreeco/swift-composable-architecture) Design where screens are driven by a reducer that uses `State`, `Action` and `Environment`


## Resource
- [Clean Architecture for SwiftUI](https://nalexn.github.io/clean-architecture-swiftui/)
- [Pointfree Navigation](https://www.pointfree.co/collections/swiftui/navigation)
- [Pointfree Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture)
- [Creating generic networking APIs in Swift](https://www.swiftbysundell.com/articles/creating-generic-networking-apis-in-swift/#conclusion)
- [How to mock DataTaskPublisher](https://stackoverflow.com/questions/60089803/how-to-mock-datataskpublisher)
