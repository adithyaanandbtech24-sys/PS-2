import SwiftUI

struct CarbonFootprintView: View {
    @Environment(AppRouter.self) private var router
    @Environment(DataManager.self) private var dataManager
    
    let productId: UUID
    
    @State private var orderVolume: Double = 5000
    @State private var selectedMaterialIndex: Int = 0
    @State private var showCertificateAlert = false
    
    var product: Product {
        dataManager.getProduct(id: productId) ?? DemoData.products[0]
    }
    
    var metrics: CarbonMetrics {
        CarbonEstimatorService.shared.calculateMetrics(for: product)
    }
    
    var options: [MaterialComparisonOption] {
        CarbonEstimatorService.shared.getComparisonOptions(for: product.material)
    }
    
    var calculatedTotalCO2Kg: Double {
        let selectedOption = options[selectedMaterialIndex]
        return (selectedOption.co2Kg * (orderVolume / 1000.0))
    }
    
    var co2SavingsTotalKg: Double {
        let baselineCO2Per1k = options[1].co2Kg
        let selectedCO2Per1k = options[selectedMaterialIndex].co2Kg
        let diff = (baselineCO2Per1k - selectedCO2Per1k) * (orderVolume / 1000.0)
        return max(0, diff)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.lg) {
                headerBanner
                kpiBadgesGrid
                materialSimulatorCard
                lcaBreakdownCard
                exportButton
            }
            .padding(AppTheme.Spacing.md)
        }
        .navigationTitle("Carbon & ESG Audit")
        .navigationBarTitleDisplayMode(.inline)
        .alert("ESG Certificate Generated", isPresented: $showCertificateAlert) {
            Button("Done", role: .cancel) { }
        } message: {
            Text("Official Sustainability & EPR Tax Exemption Certificate for \(product.name) (\(Int(orderVolume)) units) has been exported to your downloads.")
        }
    }
    
    // MARK: - Subviews
    
    private var headerBanner: some View {
        HStack {
            Image(systemName: "leaf.circle.fill")
                .font(.system(size: 36))
                .foregroundColor(AppTheme.Colors.primary)
            VStack(alignment: .leading) {
                Text("Eco-Audit & Carbon Footprint")
                    .font(AppTheme.Typography.title1)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                Text("Life-Cycle Assessment for \(product.name)")
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
            Spacer()
        }
        .cardStyle()
    }
    
    private var kpiBadgesGrid: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            VStack(spacing: 4) {
                Text("RECYCLABILITY")
                    .font(.caption2.bold())
                    .foregroundColor(AppTheme.Colors.textTertiary)
                Text(metrics.recyclabilityGrade)
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundColor(AppTheme.Colors.primary)
                Text("\(metrics.recyclabilityPercentage)% Circular")
                    .font(.caption2.bold())
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(AppTheme.Spacing.md)
            .cardStyle()
            
            VStack(spacing: 4) {
                Text("EPR SAVINGS")
                    .font(.caption2.bold())
                    .foregroundColor(AppTheme.Colors.textTertiary)
                Text("₹\(Int(metrics.eprTaxSavingsPer1000INR * (orderVolume / 1000.0)))")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(AppTheme.Colors.success)
                Text("\(metrics.eprTaxExemptionPercentage)% Tax Exempt")
                    .font(.caption2.bold())
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(AppTheme.Spacing.md)
            .cardStyle()
        }
    }
    
    private var materialSimulatorCard: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            HStack {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(AppTheme.Colors.primary)
                Text("Material Simulator & Impact Calculator")
                    .font(AppTheme.Typography.title2)
                    .foregroundColor(AppTheme.Colors.textPrimary)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Order Quantity:")
                        .font(AppTheme.Typography.bodyMedium)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                    Spacer()
                    Text("\(Int(orderVolume)) Units")
                        .font(AppTheme.Typography.title2)
                        .foregroundColor(AppTheme.Colors.primary)
                }
                
                Slider(value: $orderVolume, in: 1000...50000, step: 1000)
                    .tint(AppTheme.Colors.primary)
            }
            
            Divider()
            
            Text("Select Packaging Material Option:")
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.Colors.textTertiary)
            
            VStack(spacing: AppTheme.Spacing.sm) {
                ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                    materialOptionRow(index: index, option: option)
                }
            }
            
            summaryBanner
        }
        .cardStyle()
    }
    
    private func materialOptionRow(index: Int, option: MaterialComparisonOption) -> some View {
        Button(action: {
            withAnimation {
                selectedMaterialIndex = index
            }
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(option.name)
                            .font(AppTheme.Typography.bodyMedium.bold())
                            .foregroundColor(AppTheme.Colors.textPrimary)
                        
                        if option.isRecommended {
                            Text("ECO CHOICE")
                                .font(.system(size: 9, weight: .bold))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(AppTheme.Colors.primary.opacity(0.15))
                                .foregroundColor(AppTheme.Colors.primary)
                                .cornerRadius(6)
                        }
                    }
                    Text("\(String(format: "%.1f", option.co2Kg)) kg CO₂e / 1k units • Grade \(option.recyclability)")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: selectedMaterialIndex == index ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(selectedMaterialIndex == index ? AppTheme.Colors.primary : AppTheme.Colors.surfaceBorder)
            }
            .padding(AppTheme.Spacing.sm)
            .background(selectedMaterialIndex == index ? AppTheme.Colors.primary.opacity(0.08) : Color.clear)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(selectedMaterialIndex == index ? AppTheme.Colors.primary : AppTheme.Colors.surfaceBorder, lineWidth: 1)
            )
        }
    }
    
    private var summaryBanner: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("ESTIMATED CARBON FOOTPRINT")
                    .font(.caption2.bold())
                    .foregroundColor(AppTheme.Colors.textTertiary)
                Text("\(String(format: "%.1f", calculatedTotalCO2Kg)) kg CO₂e")
                    .font(AppTheme.Typography.title1)
                    .foregroundColor(AppTheme.Colors.textPrimary)
            }
            Spacer()
            if co2SavingsTotalKg > 0 {
                VStack(alignment: .trailing, spacing: 2) {
                    Text("CO₂ PREVENTED")
                        .font(.caption2.bold())
                        .foregroundColor(AppTheme.Colors.success)
                    Text("-\(String(format: "%.1f", co2SavingsTotalKg)) kg")
                        .font(AppTheme.Typography.title2)
                        .foregroundColor(AppTheme.Colors.success)
                }
            }
        }
        .padding(AppTheme.Spacing.md)
        .background(AppTheme.Colors.backgroundSecondary)
        .cornerRadius(12)
    }
    
    private var lcaBreakdownCard: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Life-Cycle Emission Breakdown")
                .font(AppTheme.Typography.title2)
                .foregroundColor(AppTheme.Colors.textPrimary)
            
            VStack(spacing: AppTheme.Spacing.sm) {
                LCAProgessRow(label: "Raw Material Extraction", percentage: metrics.lcaRawMaterialPercent, color: .orange)
                LCAProgessRow(label: "Manufacturing & Moulding", percentage: metrics.lcaManufacturingPercent, color: .blue)
                LCAProgessRow(label: "Logistics & Transport", percentage: metrics.lcaTransportPercent, color: .purple)
                LCAProgessRow(label: "End-of-life Recycling", percentage: metrics.lcaEndOfLifePercent, color: AppTheme.Colors.primary)
            }
        }
        .cardStyle()
    }
    
    private var exportButton: some View {
        Button(action: {
            showCertificateAlert = true
        }) {
            HStack {
                Image(systemName: "doc.badge.arrow.up")
                Text("Export Official ESG Audit Report (PDF)")
                    .font(AppTheme.Typography.headline)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(AppTheme.Gradients.primary)
            .foregroundColor(.white)
            .cornerRadius(14)
        }
    }
}

struct LCAProgessRow: View {
    let label: String
    let percentage: Int
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(label)
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                Spacer()
                Text("\(percentage)%")
                    .font(AppTheme.Typography.caption.bold())
                    .foregroundColor(AppTheme.Colors.textPrimary)
            }
            
            GeometryReader { g in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(AppTheme.Colors.surfaceBorder)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(color)
                        .frame(width: g.size.width * CGFloat(percentage) / 100.0)
                }
            }
            .frame(height: 6)
        }
    }
}
