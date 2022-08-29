import Foundation

public extension Date {
    static func days(by number : Int, currentDate: Date = .init()) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.day = number
        return Calendar.current.date(byAdding: dateComponents, to: currentDate)
    }
    
    var formatted: String {
        DateFormatter.shortHand().string(from: self)
    }
}
