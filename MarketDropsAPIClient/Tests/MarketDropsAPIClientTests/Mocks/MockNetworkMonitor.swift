@testable import MarketDropsAPIClient

public struct MockNetworkMonitor: NetworkMonitoring {
    public var isConnected: Bool

    public init(isConnected: Bool) {
        self.isConnected = isConnected
    }
}
