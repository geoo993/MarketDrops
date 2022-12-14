import Foundation
import MarketDropsCore

public extension JSONDecoder {
    static func withFormating() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom({ decoder -> Date in
            let container = try decoder.singleValueContainer()
            let string = try container.decode(String.self)
            let iso8601Formatter = ISO8601DateFormatter()
            if let date = iso8601Formatter.date(from: string) {
                return date
            } else if let date = DateFormatter.date().date(from: string) {
                return date
            } else if let date = DateFormatter.dateAndTime().date(from: string) {
                return date
            } else if let date = ISO8601DateFormatter.iso8601Full().date(from: string) {
                return date
            } else {
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Cannot decode date string \(string)"
                )
            }
        })
        return decoder
    }
}
