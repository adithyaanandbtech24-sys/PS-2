import Foundation

protocol AIServiceProtocol {
    func analyzeImage(imageData: Data?) async -> ProductAnalysis
}

class MockAIService: AIServiceProtocol {
    let mockResults: [ProductAnalysis] = [
        ProductAnalysis(category: "Cosmetic Bottle", estimatedCapacity: "100 ml", shape: "Cylindrical", closure: "Pump", material: "PET", confidence: 0.95),
        ProductAnalysis(category: "Jar", estimatedCapacity: "50 g", shape: "Round", closure: "Screw cap", material: "Glass", confidence: 0.89),
        ProductAnalysis(category: "Spray Bottle", estimatedCapacity: "200 ml", shape: "Oval", closure: "Spray", material: "HDPE", confidence: 0.92),
        ProductAnalysis(category: "Tube", estimatedCapacity: "30 ml", shape: "Cylindrical", closure: "Flip-top", material: "PBL", confidence: 0.85),
        ProductAnalysis(category: "Dropper", estimatedCapacity: "15 ml", shape: "Round", closure: "Dropper", material: "Glass", confidence: 0.97),
        ProductAnalysis(category: "Box", estimatedCapacity: "N/A", shape: "Rectangular", closure: "N/A", material: "Kraft", confidence: 0.88),
        ProductAnalysis(category: "Pouch", estimatedCapacity: "500 g", shape: "Rectangular", closure: "Zip-lock", material: "PE", confidence: 0.91),
        ProductAnalysis(category: "Container", estimatedCapacity: "1 L", shape: "Square", closure: "Snap-on", material: "PP", confidence: 0.94)
    ]
    
    func analyzeImage(imageData: Data?) async -> ProductAnalysis {
        // Simulating network delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return mockResults.randomElement() ?? mockResults[0]
    }
}
