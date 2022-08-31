import UIKit

public enum HapticFeedback {
    case selection
    case failure
    case tap
    
    public func play() {
        switch self {
        case .selection:
            let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
            selectionFeedbackGenerator.selectionChanged()
            
        case .failure:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            
        case .tap:
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
        }
    }
}
