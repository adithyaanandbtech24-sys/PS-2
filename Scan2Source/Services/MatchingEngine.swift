import Foundation

class MatchingEngine {
    func findMatches(requirement: Requirement, products: [Product], suppliers: [Supplier]) -> [(match: Match, product: Product, supplier: Supplier)] {
        var results: [(match: Match, product: Product, supplier: Supplier)] = []
        
        for product in products {
            guard let supplier = suppliers.first(where: { $0.id == product.supplierId }) else { continue }
            
            // 1. Visual Score (40%)
            var visualScore: Double = 0.0
            if product.category == requirement.category {
                visualScore += 0.7
            }
            if product.shape.localizedCaseInsensitiveContains(requirement.detectedProduct.shape) || requirement.detectedProduct.shape.localizedCaseInsensitiveContains(product.shape) {
                visualScore += 0.3
            }
            
            // 2. Requirement Score (20%)
            var reqScore: Double = 0.0
            if product.colours.contains(where: { $0.localizedCaseInsensitiveContains(requirement.colour) }) {
                reqScore += 0.5
            }
            if product.capacity.localizedCaseInsensitiveContains(requirement.detectedProduct.estimatedCapacity) || requirement.detectedProduct.estimatedCapacity.localizedCaseInsensitiveContains(product.capacity) {
                reqScore += 0.5
            }
            
            // 3. MOQ Score (20%)
            let moqScore: Double = product.moq <= requirement.quantity ? 1.0 : 0.0
            
            // 4. Customization Score (10%)
            var customScore: Double = 1.0
            if !requirement.customizations.isEmpty {
                let overlap = Set(product.customizationOptions).intersection(Set(requirement.customizations)).count
                customScore = Double(overlap) / Double(requirement.customizations.count)
            }
            
            // 5. Budget Score (10%)
            var budgetScore: Double = 0.0
            let avgPrice = (product.priceMin + product.priceMax) / 2.0
            if avgPrice >= requirement.budgetMin && avgPrice <= requirement.budgetMax {
                budgetScore = 1.0
            } else if product.priceMin <= requirement.budgetMax {
                budgetScore = 0.5 // Partially in budget
            }
            
            let match = Match(
                requirementId: requirement.id,
                productId: product.id,
                visualScore: visualScore,
                requirementScore: reqScore,
                moqScore: moqScore,
                customizationScore: customScore,
                budgetScore: budgetScore
            )
            
            results.append((match, product, supplier))
        }
        
        // Sort by finalScore descending
        results.sort { $0.match.finalScore > $1.match.finalScore }
        
        // Return top 10 matches
        return Array(results.prefix(10))
    }
}
