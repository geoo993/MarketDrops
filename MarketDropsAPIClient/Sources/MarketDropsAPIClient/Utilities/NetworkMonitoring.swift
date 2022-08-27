import Foundation
import Network

public protocol NetworkMonitoring {
    var isConnected: Bool { get }
}

public final class NetworkMonitor: NetworkMonitoring {
    public var isConnected: Bool {
        monitor.currentPath.status == .satisfied
    }
    
    private let monitor = NWPathMonitor()

    public init() {
        monitor.start(queue: DispatchQueue(label: "com.MarketDrops.NetworkMonitor"))
    }

    deinit {
        self.monitor.cancel()
    }
}
