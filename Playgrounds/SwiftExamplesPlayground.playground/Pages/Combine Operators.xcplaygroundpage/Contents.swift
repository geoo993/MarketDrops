import UIKit
import Combine

// https://developer.apple.com/documentation/combine
// https://www.swiftbysundell.com/basics/combine/
// https://heckj.github.io/swiftui-notes/
// https://medium.com/gett-engineering/rxswift-to-apples-combine-cheat-sheet-e9ce32b14c5b
// https://medium.com/flawless-app-stories/problem-solving-with-combine-swift-4751885fda77
// https://medium.com/better-programming/6-combining-operators-you-should-know-from-swift-combine-17ea69d9dad7
// https://www.raywenderlich.com/books/combine-asynchronous-programming-with-swift/v1.0/chapters/5-combining-operators#toc-chapter-008-anchor-003
// https://www.clariontech.com/blog/leverage-on-combine-framework-to-build-flawless-ios-apps
// https://medium.com/flawless-app-stories/combine-framework-in-swift-b730ccde131
// https://rxmarbles.com
// https://www.vadimbulavin.com/swift-combine-framework-tutorial-getting-started/
// https://theswiftdev.com/the-ultimate-combine-framework-tutorial-in-swift/

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

/****1) WHAT IS COMBINE**
 
 About Combine:
 - In Apple’s own words: “The Combine framework provides a declarative approach for how your app processes events. Rather than potentially implementing multiple delegate callbacks or completion handler closures, you can create a single processing chain for a given event source. Each part of the chain is a Combine operator that performs a distinct action on the elements received from the previous step.”
 - Combine is Apple’s asynchronous event-handling framework, which is widely known to be inspired by other third-party reactive frameworks like RxSwift.
 - It provides the programming interface for working with asynchronous data streams in a unified and declarative way using Swift.
 - These data streams are anything that happens over time from button clicks, to network responses, notification events, and many other events,
 - and we use combine to not only listen to when these data stream of events are triggered but also compose (transform, filter, combine) how they are processed within our business logic. providing a unified interface that also simplifies our code.
 - The most helpful thing  about Combine is how it handles how these events are processes, taking care of all the delegation, notifications, timers, completion blocks and callbacks for us, which would would otherwise be very challenging to fiddle with.
 - Combine lets us focus on the interdependence of these events and how they are defined in our business logic.
 - Its a must-have tool for composing pieces of asynchronous work.
 - Since Combine unifies all of these different mechanisms under a single interface, this opens the door to interesting and powerful ways of composing logic and work in a declarative and universal way.
 
 */

/**** 2) PUBLISHERS AND SUBSCRIBERS**
 
 What are Publishers and Subscribers in Combine:
 - At a broad level, there is three key moving pieces in Combine: publishers, operators and subscribers
 - Within the world of Combine, an object that emits such stream of asynchronous values and events is called a publisher and a subscriber will requests values from publishers for its own purpose.
 - This means that Publishers send sequences of values over time to one or more Subscribers.
 - This is one of most important things to understand in Combine. A publisher is a type that can deliver a sequence of values over time, and a Subscriber subscribes to the publisher to receive its elements.
 - They both have a strict contract where a publisher should return values when asked from subscribers, and can possibly terminate with an explicit completion enumeration.
 
 */

/****3) OPERATORS**
 
 Types of Combine Operators
 - What makes Combine really powerful is the ability to transform, combine or filter the elements emitted by a publisher. Combine provides lots of functionality (adopted from RxSwift) for responding to data streams of publishers.
 - These are the three types of operators available in combine: Filters, Transformers, Combiners
 - Our app will ultimately benefit the most by how effecient we use these operators to handle data streams generated by publishers.
 - The following examples are some of the most common and really useful filtering and combining operators of Combine.
 
 */

/****3A) FILTERING OPERATORS**
 Filtering Operators:
 - Filters will remove elements from a sequence of the publisher based on a specific condition.
 - Filter operators allows you to specify which elements of the publisher to pass to the consumer/subscriber.
 - Again, some of these operators have parallels with the same names in the Swift standard library.
 - The most useful filter operators are:
 * filter
 * compactMap
 * removeDuplicates
 * replaceError
 
 */
 
// Filter is behaves similar to Swift Filter. Filter removes elements that do not fit with our condition from closure function.
example(of: "filter") {
    
    // 1
    var disposeBag = Set<AnyCancellable>()
    let numbersPublisher = [2, 3, 3, 5, 5, 6, 8, 13, 16].publisher // Publisher
    
    // 2
    numbersPublisher
        .filter { $0.isMultiple(of: 2) }
        .sink(receiveValue: {
            // DO SOMETHING HERE
            print($0)
        })
        .store(in: &disposeBag)

}


// Remove Duplicates publishes only elements that don’t match the previous element. It is the equivelent of RxSwift distinctUntilChanged which filter out values that match the previous emited elemnt
example(of: "removeDuplicates") {
    
    // 1
    var disposeBag = Set<AnyCancellable>()
    let titlePublisher = PassthroughSubject<String, Never>() // Subject
    
    // 2
    titlePublisher
        .removeDuplicates()
        .sink(receiveValue: {
            // DO SOMETHING HERE
            print($0)
        })
        .store(in: &disposeBag)
    
    // 3
    titlePublisher.send("Room")
    titlePublisher.send("Venom")
    titlePublisher.send("Venom")
    titlePublisher.send("Hitch")
    titlePublisher.send("Fences")
    titlePublisher.send("Fences")
    titlePublisher.send("Inception")
}


/****3B) TRANSFORMING OPERATORS**
 Transforming Operators:
 - Transformers, will transform the values emitted from a publisher with a given function.
 - You use transforming operators to manipulate values coming from publishers into a format that is usable for your subscribers.
 - As you’ll see, there are parallels between transforming operators in Combine and regular operators in the Swift standard library, such as:
 * map
 * flatMap.
 
 */

// Mapping operators allows you to transform values emitted by the publisher.
example(of: "map") {
    
    // 1
    var disposeBag = Set<AnyCancellable>()
    let agePublisher = [22, 33, 23, 5, 65, 16, 8, 13, 26].publisher // Publisher
    
    // 2
    agePublisher
        .map { "I am \($0) years old" }
        .sink(receiveValue: {
            // DO SOMETHING HERE
            print($0)
        })
        .store(in: &disposeBag)

}


/****3C) COMBINING OPERATORS**
 Combining Operators:
 - Combining operators lets you combine events emitted by different publishers and create meaningful combinations of data at your convenience.
 - Some of these operators are very similar to Swift operators when working with the collections.
 * prepend
 * merge
 * zip
 * switchToLatest
 * combineLatest
 * withLatestfrom
 
 */

// Prepend is used to add values emitted by a second publisher before the original publisher’s values.
example(of: "Prepend") {
    
    // 1
    var disposeBag = Set<AnyCancellable>()
    let subject = PassthroughSubject<String, Never>()   // Subject
    let stringPublisher = ["Break things!"].publisher // Publisher
    
    // 2
    stringPublisher
       .prepend(subject)
       .sink(receiveValue: {
            // DO SOMETHING HERE
            print($0)
       })
       .store(in: &disposeBag)
       
   // 3
    subject.send("Move slow")
    subject.send("Move fast")
    subject.send(completion: .finished)
}

// Merge will do as it says, it combines elements from two different publishers of the same type, delivering a sequence of elements over time, as if we are receiving values from just one publisher. It basically takes two upstream publishers and mixes the elements published into a single stream of elements.
example(of: "merge") {

    // PART 1
    var disposeBag = Set<AnyCancellable>()
    let publisher1 = [1, 2, 3].publisher // Publisher
    let publisher2 = Publishers.Sequence<[Int], Never>(sequence: [4,5,6]) // Publisher
    
    // 2
    publisher1
        .merge(with: publisher2)
       .sink(receiveValue: { print($0) })
       .store(in: &disposeBag)
    
    // PART 2
    // 1
    let filmTrilogiesSubject = PassthroughSubject<String, Never>()     // Subject
    let standaloneFilmsSubject = PassthroughSubject<String, Never>()   // Subject
    
    // 2
    filmTrilogiesSubject
        .merge(with: standaloneFilmsSubject)
        .sink(receiveValue: {
            // DO SOMETHING HERE
            print($0)
        })
        .store(in: &disposeBag)
       
    // 3
    filmTrilogiesSubject.send("The Phantom Menace")
    filmTrilogiesSubject.send("Attack of the Clones")
    standaloneFilmsSubject.send("The Clone Wars")
    filmTrilogiesSubject.send("Revenge of the Sith")
    standaloneFilmsSubject.send("Solo")
    standaloneFilmsSubject.send("Rogue One")
    filmTrilogiesSubject.send("A New Hope")
}


// You might recognize Zip from the Swift standard library method with the same name on Sequence types.
// Zip is a little different from Merge where it allows you to combine two upstream publishers (of any type) and mixes the elements published into a single pipeline.
// The main benefit of Zip is that it will wait until all source publishers have produced an element before emitting the combined elements to the subscriber.
// there are also other variance of zip that will let you combine up-to 3, or 4 source publishers (i.e. zip3, zip4).
example(of: "Zip") {

    // PART 1
    // 1
    var disposeBag = Set<AnyCancellable>()
    let names = PassthroughSubject<String, Never>()     // Subject
    let ages = PassthroughSubject<Int, Never>()          // Subject
    
    // 2
    names
        .zip(ages) { ($0, $1) }
        .sink(receiveValue: {
            // DO SOMETHING HERE
            print("My name is \($0) and I am \($1) years old")
       })
       .store(in: &disposeBag)
    
    // 3
    names.send("Leonardo")
    ages.send(7)
    
    names.send("Simone")
    ages.send(21)

    // PART 2
    // 1
    let characters = PassthroughSubject<String, Never>()        // Subject
    let primaryWeapons = PassthroughSubject<String, Never>()    // Subject
      
      // 2
     characters
        .zip(primaryWeapons) { ($0, $1) }
        .sink(receiveValue: {
            // DO SOMETHING HERE
            print("Character \($0) uses \($1)")
        })
        .store(in: &disposeBag)
    
    // 3
    characters.send("Thor")
    primaryWeapons.send("Hammer")
    
    characters.send("Spiderman")
    primaryWeapons.send("Spider Web")
}


// combineLatest is very similar to Zip where it will also wait until all combined publishers emit an initial value.
// the main benefit of combinedLatest is that it will take two publishers (of any type) and pass their latest elements to a closure for you to specify how to combine them. It will basically create a publisher that receives and combines the latest elements from two publishers.
example(of: "combineLatest") {

    // PART 1
    // 1
    var disposeBag = Set<AnyCancellable>()

    let characters = ["Thor", "Captain America", "Thanos"].publisher      // Publisher
    let primaryWeapons = ["Hammer", "Shield", "Gauntlet"].publisher     // Publisher

    // 2
    Publishers.CombineLatest(characters, primaryWeapons)
        .map { "Character \($0) uses \($1)" }
        .sink(receiveValue: {
          // DO SOMETHING HERE
            print($0)
        })
        .store(in: &disposeBag)
    
    // PART 2
    // To illustrate a great use case of combineLatest, consider the following real-case example:
    // We have username and password UITextFields and a button allowing us to proceed.
    // We want to keep the button disabled until the username is at least five characters long and the password is at least eight characters long.
    // We can easily achieve that by using the .combineLatest operator:
    
    // 1
    let usernameTextField = CurrentValueSubject<String, Never>("")  // Subject
    let passwordTextField = CurrentValueSubject<String, Never>("")  // Subject
    let isButtonEnabled = CurrentValueSubject<Bool, Never>(false)   // Subject
    
    // 2
    usernameTextField
        .combineLatest(passwordTextField)
        .handleEvents(receiveOutput: { (username, password) in
            // DO SOMETHING HERE
            print("\nUsername: \(username), password: \(password)")
            let isSatisfied = username.count >= 5 && password.count >= 8
            isButtonEnabled.send(isSatisfied)
        })
        .sink(receiveValue: { _ in })
        .store(in: &disposeBag)
        
    isButtonEnabled
        .sink {
            // DO SOMETHING HERE
            print("isButtonEnabled: \($0)")
        }
        .store(in: &disposeBag)
    
    // 3
    usernameTextField.send("SamWWDC")
    passwordTextField.send("sam12")
    
    usernameTextField.send("geos@space.com")
    passwordTextField.send("ABC12356")
    
}

// switchToLatest is one of the most complex operators in Combine and it behaves the same way as Swift flatMap, where it allows us to flatten a series of publishers into one stream of events.
// switchToLatest produces values only from the most recent published sequence.
// each time a new inner publisher sequence emits a value, it will unsubscribe from the other publishers.
// switchToLatest is the equivalent of RxSwift flatMapLatest which is actually a combination of map and switchLatest of RxSwift.
example(of: "switchToLatest") {
    
    // 1
    var disposeBag = Set<AnyCancellable>()
    let publisher1 = PassthroughSubject<Int, Never>()   // Subject
    let publisher2 = PassthroughSubject<Int, Never>()   // Subject
    let publisher3 = PassthroughSubject<Int, Never>()   // Subject
    
    // 2
    let publishers = PassthroughSubject<PassthroughSubject<Int, Never>, Never>()    // Subject

    // 3
    publishers
        .switchToLatest()
        .sink(receiveCompletion: { _ in print("Completed!") },
              receiveValue: {
                // DO SOMETHING HERE
                print($0)
              })
            .store(in: &disposeBag)
    // 4
    publishers.send(publisher1)
    publisher1.send(1)
    publisher1.send(2)

    // 5
    publishers.send(publisher2)
    publisher1.send(3)
    publisher2.send(4)
    publisher2.send(5)

    // 6
    publishers.send(publisher3)
    publisher2.send(6)
    publisher3.send(7)
    publisher3.send(8)
    publisher3.send(9)

    // 7
    publisher3.send(completion: .finished)
    publishers.send(completion: .finished)
}



// withLatestFrom is another great operator which is not yet in Combine and works very similar to the RxSwift version.
// It basically alows you to combine values of publisher1 with the latest values of publisher2 but only when publisher1 emits a value.
// This operator merges two publishers into one publisher sequence by combining each element from self with the latest element from the second publisher.
example(of: "withLatestFrom") {
    
    // PART 1
    // 1
    var disposeBag = Set<AnyCancellable>()
    let subject1 = PassthroughSubject<String, Never>()  // Subject
    let subject2 = PassthroughSubject<String, Never>()  // Subject
    
    // 2
    subject1
        .withLatestFrom(subject2) { ($0, $1) }
        .sink(receiveValue: {
            // DO SOMETHING HERE
            print($0, $1)
        })
        .store(in: &disposeBag)
    
    // 3
    subject2.send("💥")
    subject1.send("Run code: ")
    subject1.send("Run code again: ")
    
    subject2.send("Tadda, It works!")
    subject1.send("Run code again and again: ")
    subject1.send(completion: .finished)
    
    
    // PART 2
    // 1
    let prizeDraw = PassthroughSubject<Bool, Never>()             // Subject
    let names = PassthroughSubject<[String], Never>()      // Subject
    
    // 2
    prizeDraw
        .filter({ $0 })
        .withLatestFrom(names)
        .sink(receiveValue: {
            // DO SOMETHING HERE
            print()
            if let winner = $0.shuffled().first {
                print("Congratulations \(winner), you just WON £5000 prize")
            }
        })
        .store(in: &disposeBag)
    
    //3
    prizeDraw.send(false)
    prizeDraw.send(true)
    names.send(["Heather", "Daniel", "Alex", "Sandra", "Normand", "Jannet"])
    prizeDraw.send(false)
    prizeDraw.send(true)
    
    
}


/****4) WHY USE COMBINE AND ITS OPERATORS**
As you can see from these examples, Combine was designed as the Apple version of RxSwift which:
- It helps us handle asynchronous code
- It features and simplifies multithreading
- It provides an elagant way to compose components, favouring composition over inheritance & reusability
- It has cancellation support and memory management built in
- Overall, it provides a declarative syntax that makes our codebase easier to read and maintain
 
 
*/

/****5) WHERE TO USE COMBINE OPERATORS**
 
 Best areas to use these operators are:
 - Publisher subjects
 - UIControl publishers
 - Realm Objects publisher
 - Notification Center
 - Network request
 - Reducers, State Machine, Router and soon SwiftUI
 
 */

/****5A) SUBJECTS**
Publisher subjects
 - PassthroughSubject
 - CurrentSubject
 
 */
 
example(of: "Subjects") {
    var disposeBag = Set<AnyCancellable>()
    let regularity = PassthroughSubject<String, Never>()
    let nextPayDate: CurrentValueSubject<Date, Never> = .init(Date(timeIntervalSince1970: 300))

    /// codebase example
    Publishers.CombineLatest(regularity, nextPayDate)
        .sink(receiveValue: { (regularity, payDate) in
            print("\nPayDay")
            print("Regularity: \(regularity)")
            print("Date: \(payDate)")
        })
        .store(in: &disposeBag)
    
    regularity.send("Daily")
    nextPayDate.send(Date(timeIntervalSince1970: 330))
    
    regularity.send("Monthly")
    nextPayDate.send(Date(timeIntervalSince1970: 530))
}



/****5D) NOTIFICATION CENTER**
Notification Center Publisher
- NotificationCenter: Executes a piece of code any time an event of interest happens, such as when the user changes the orientation of the device or when the software keyboard shows or hides on the screen.
- When a notifaction observer listens to when a new notification name is posted
*/

final class MyButton {
    static let tapped = Notification.Name("tapped")
    init() {}
    
    func tapped() {
        NotificationCenter.default.post(name: MyButton.tapped, object: self)
    }
}

example(of: "NotificationCenter Publisher") {
    var disposeBag = Set<AnyCancellable>()
    let myButton = MyButton()
    
    NotificationCenter.default
        .publisher(for: MyButton.tapped)
//        .subscribe(on: DispatchQueue.global())
//        .receive(on: DispatchQueue.main)
        .sink { _ in
            print("my button was tapped something here")
        }
        .store(in: &disposeBag)
    
    myButton.tapped()
}

/****5E) URL SESSIONS**
URLSessions publisher
- URLSessions dataTaskPublisher

*/

example(of: "URLSession Publisher") {
    print("we're are fetching the date")
    
    var disposeBag = Set<AnyCancellable>()
    let url = URL(string: "https://www.google.com")!
    URLSession.shared.dataTaskPublisher(for: url)
        .map { $0.data }
        .decode(type: String.self, decoder: JSONDecoder())
        .replaceError(with: "Hello world")
        .eraseToAnyPublisher()
        .sink(receiveValue: { results in
            print(results.count)
        })
        .store(in: &disposeBag)
}
