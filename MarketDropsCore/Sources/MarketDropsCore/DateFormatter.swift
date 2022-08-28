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
}
