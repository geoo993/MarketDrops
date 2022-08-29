import Foundation

public extension DateFormatter {
    /// A date formatter used for date objects - `yyyy-MM-dd`.
    /// - Returns: A `DateFormatter` instance.
    static func date() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    /// A date formatter used to make a date in the format of `MMM d, yyyy`, example result `Jan 6, 2022`
    /// - Returns: A `DateFormatter` instance.
    static func shortHand() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }
    
    /// A date formatter used to make a date with day and time in the format of `yyyy-MM-dd HH:mm:ss`, example result `2022-03-31 20:00:00`
    /// - Returns: A `DateFormatter` instance.
    static func dateAndTime() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        return formatter
    }
}
