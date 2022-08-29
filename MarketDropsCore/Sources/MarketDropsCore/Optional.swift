import Foundation

extension Optional where Wrapped: Collection {
    public var isNil: Bool {
        self == nil
    }
    
    public var isNotNil: Bool {
        !isNil
    }
    
    public var isNilOrEmpty: Bool {
        self?.isEmpty ?? true
    }
}

extension Optional where Wrapped: StringProtocol {
    public var toUrl: URL? {
        guard let urlString = self as? String else { return nil }
        return URL(string: urlString)
    }
}
