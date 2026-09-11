import Foundation

struct CarbonMetrics: Codable, Hashable {
    let materialName: String
    let co2Per1000UnitsKg: Double // kg CO2e per 1,000 units
    let recyclabilityGrade: String // e.g. "A+", "A", "B", "C"
    let recyclabilityPercentage: Int // 0-100%
    let eprTaxExemptionPercentage: Int // 0-100%
    let eprTaxSavingsPer1000INR: Double // ₹ savings per 1000 units
    let waterUsageLiters: Double
    let energyUsageKWh: Double
    let lcaRawMaterialPercent: Int
    let lcaManufacturingPercent: Int
    let lcaTransportPercent: Int
    let lcaEndOfLifePercent: Int
}

struct MaterialComparisonOption: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let co2Kg: Double
    let recyclability: String
    let taxSavingsINR: Double
    let isRecommended: Bool
}

class CarbonEstimatorService {
    static let shared = CarbonEstimatorService()
    
    func calculateMetrics(for product: Product) -> CarbonMetrics {
        let material = product.material.lowercased()
        
        let baseCO2: Double
        let recyclabilityGrade: String
        let recyclabilityPercent: Int
        let eprTaxExemption: Int
        let eprTaxSavings: Double
        let water: Double
        let energy: Double
        
        if material.contains("rpet") || material.contains("recycled") || material.contains("kraft") {
            baseCO2 = 18.5
            recyclabilityGrade = "A+"
            recyclabilityPercent = 100
            eprTaxExemption = 95
            eprTaxSavings = 450.0
            water = 120.0
            energy = 35.0
        } else if material.contains("glass") {
            baseCO2 = 65.0
            recyclabilityGrade = "A"
            recyclabilityPercent = 90
            eprTaxExemption = 80
            eprTaxSavings = 320.0
            water = 450.0
            energy = 110.0
        } else if material.contains("pet") || material.contains("hdpe") || material.contains("pp") {
            baseCO2 = 42.0
            recyclabilityGrade = "B+"
            recyclabilityPercent = 75
            eprTaxExemption = 60
            eprTaxSavings = 180.0
            water = 280.0
            energy = 72.0
        } else { // Aluminium / Multi-layer / ABL / PBL
            baseCO2 = 54.0
            recyclabilityGrade = "B"
            recyclabilityPercent = 65
            eprTaxExemption = 50
            eprTaxSavings = 120.0
            water = 310.0
            energy = 88.0
        }
        
        return CarbonMetrics(
            materialName: product.material,
            co2Per1000UnitsKg: baseCO2,
            recyclabilityGrade: recyclabilityGrade,
            recyclabilityPercentage: recyclabilityPercent,
            eprTaxExemptionPercentage: eprTaxExemption,
            eprTaxSavingsPer1000INR: eprTaxSavings,
            waterUsageLiters: water,
            energyUsageKWh: energy,
            lcaRawMaterialPercent: 45,
            lcaManufacturingPercent: 30,
            lcaTransportPercent: 15,
            lcaEndOfLifePercent: 10
        )
    }
    
    func getComparisonOptions(for currentMaterial: String) -> [MaterialComparisonOption] {
        return [
            MaterialComparisonOption(name: "100% rPET (Post-Consumer)", co2Kg: 18.5, recyclability: "A+", taxSavingsINR: 450.0, isRecommended: true),
            MaterialComparisonOption(name: "Virgin PET / HDPE", co2Kg: 42.0, recyclability: "B+", taxSavingsINR: 180.0, isRecommended: false),
            MaterialComparisonOption(name: "Recyclable Glass", co2Kg: 65.0, recyclability: "A", taxSavingsINR: 320.0, isRecommended: false),
            MaterialComparisonOption(name: "FSC Kraft Paper", co2Kg: 14.2, recyclability: "A+", taxSavingsINR: 520.0, isRecommended: true)
        ]
    }
}
