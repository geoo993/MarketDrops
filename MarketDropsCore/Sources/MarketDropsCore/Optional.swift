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
