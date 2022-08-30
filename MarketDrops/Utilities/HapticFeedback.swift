import UIKit

public enum HapticFeedback {
    case selection
    case tap
    
    public func play() {
        switch self {
        case .selection:
            let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
            selectionFeedbackGenerator.selectionChanged()
            
        case .tap:
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
        }
    }
}
