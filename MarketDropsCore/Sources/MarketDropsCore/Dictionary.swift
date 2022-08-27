import Foundation

public extension Dictionary {
    mutating func merge(other dictionary: [Key: Value]) {
        merge(dictionary) { $1 }
    }
}
