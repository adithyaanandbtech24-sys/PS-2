import Foundation

struct Match: Codable, Identifiable {
    let id: UUID
    var requirementId: UUID
    var productId: UUID
    var visualScore: Double
    var requirementScore: Double
    var moqScore: Double
    var customizationScore: Double
    var budgetScore: Double
    var finalScore: Double
    
    /// Percentage display (0–100)
    var matchPercentage: Int {
        Int(finalScore * 100)
    }
    
    /// Human-readable match reasons
    var matchReasons: [MatchReason] {
        var reasons: [MatchReason] = []
        if visualScore > 0.6 { reasons.append(.similarDesign) }
        if moqScore > 0.6 { reasons.append(.moqFits) }
        if customizationScore > 0.6 { reasons.append(.customizationAvailable) }
        if budgetScore > 0.6 { reasons.append(.budgetCompatible) }
        if requirementScore > 0.6 { reasons.append(.colourAvailable) }
        return reasons
    }
    
    init(id: UUID = UUID(), requirementId: UUID, productId: UUID,
         visualScore: Double = 0, requirementScore: Double = 0, moqScore: Double = 0,
         customizationScore: Double = 0, budgetScore: Double = 0) {
        self.id = id
        self.requirementId = requirementId
        self.productId = productId
        self.visualScore = visualScore
        self.requirementScore = requirementScore
        self.moqScore = moqScore
        self.customizationScore = customizationScore
        self.budgetScore = budgetScore
        // Weighted calculation: Visual 40%, Requirement 20%, MOQ 20%, Customization 10%, Budget 10%
        self.finalScore = (visualScore * 0.40) + (requirementScore * 0.20) +
                          (moqScore * 0.20) + (customizationScore * 0.10) + (budgetScore * 0.10)
    }
}

enum MatchReason: String, Codable, Hashable {
    case similarDesign = "similar_design"
    case moqFits = "moq_fits"
    case colourAvailable = "colour_available"
    case customizationAvailable = "customization_available"
    case budgetCompatible = "budget_compatible"
    case verifiedSupplier = "verified_supplier"
    
    var displayText: String {
        switch self {
        case .similarDesign: return "Similar design"
        case .moqFits: return "MOQ fits"
        case .colourAvailable: return "Colour available"
        case .customizationAvailable: return "Customization available"
        case .budgetCompatible: return "Budget compatible"
        case .verifiedSupplier: return "Verified supplier"
        }
    }
    
    var iconName: String {
        return "checkmark.circle.fill"
    }
}
