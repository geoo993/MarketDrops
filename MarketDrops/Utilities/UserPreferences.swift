import Foundation

final class UserPreferences {
    private enum KeyName: String {
        case companySymbolKey
    }

    func add(symbol: String, isFavoured: Bool) {
        var current = favouriteSymbol
        current[symbol] = isFavoured
        favouriteSymbol = current
    }

    func isFavourite(for symbol: String) -> Bool {
        favouriteSymbol[symbol] ?? false
    }
    
    func allFavourites() -> [String] {
        let dict = favouriteSymbol.filter({ $0.value })
        return Array(dict.keys)
    }

    private var favouriteSymbol: [String: Bool] {
        set(newValue) {
            let key = self.key(for: KeyName.companySymbolKey.rawValue)
            userDefaults.set(newValue, forKey: key)
        }

        get {
            let key = self.key(for: KeyName.companySymbolKey.rawValue)
            return userDefaults.dictionary(forKey: key) as? [String: Bool] ?? [:]
        }
    }

    static let shared = UserPreferences()
    private let userDefaults = UserDefaults.standard

    private init() {}
    
    private func key(for id: String) -> String {
        "\(String(describing: self))-\(id)"
    }
}
