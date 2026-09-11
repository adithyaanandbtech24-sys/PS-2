import Foundation

struct Requirement: Codable, Identifiable {
    let id: UUID
    var userId: UUID
    var detectedProduct: ProductAnalysis
    var category: PackagingCategory
    var quantity: Int
    var colour: String
    var customizations: [CustomizationOption]
    var budgetMin: Double
    var budgetMax: Double
    var notes: String
    var createdAt: Date
    
    /// Human-readable summary
    var friendlySummary: String {
        var parts: [String] = []
        parts.append("\(colour) \(detectedProduct.category)")
        parts.append("\(quantity) pieces")
        if !customizations.isEmpty {
            parts.append(customizations.map { $0.displayName }.joined(separator: ", "))
        }
        parts.append("₹\(Int(budgetMin))–₹\(Int(budgetMax)) / piece")
        return parts.joined(separator: "\n")
    }
    
    init(id: UUID = UUID(), userId: UUID = UUID(), detectedProduct: ProductAnalysis,
         category: PackagingCategory, quantity: Int = 20, colour: String = "White",
         customizations: [CustomizationOption] = [], budgetMin: Double = 10,
         budgetMax: Double = 30, notes: String = "", createdAt: Date = Date()) {
        self.id = id
        self.userId = userId
        self.detectedProduct = detectedProduct
        self.category = category
        self.quantity = quantity
        self.colour = colour
        self.customizations = customizations
        self.budgetMin = budgetMin
        self.budgetMax = budgetMax
        self.notes = notes
        self.createdAt = createdAt
    }
}

/// AI-generated product analysis result
struct ProductAnalysis: Codable, Hashable {
    var category: String
    var estimatedCapacity: String
    var shape: String
    var closure: String
    var material: String
    var confidence: Double
    
    /// Simple user-facing description
    var friendlyDescription: String {
        "\(estimatedCapacity) \(closure.lowercased()) \(category.lowercased())"
    }
    
    /// Technical detail pairs for optional "View Technical Details" section
    var technicalDetails: [(label: String, value: String)] {
        [
            ("Material", material),
            ("Capacity", estimatedCapacity),
            ("Shape", shape),
            ("Closure", closure)
        ]
    }
    
    static let example = ProductAnalysis(
        category: "Cosmetic Pump Bottle",
        estimatedCapacity: "100 ml",
        shape: "Cylindrical",
        closure: "Pump",
        material: "PET",
        confidence: 0.94
    )
}
