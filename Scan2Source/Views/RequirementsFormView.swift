import SwiftUI

struct RequirementsFormView: View {
    @Environment(AppRouter.self) private var router
    @Environment(DataManager.self) private var dataManager
    
    @State private var quantity = 20
    @State private var selectedColour = "White"
    @State private var selectedCustomizations = Set<CustomizationOption>()
    @State private var minBudget: Double = 10
    @State private var maxBudget: Double = 50
    @State private var notes = ""
    
    let colors = ["White", "Blue", "Green", "Black", "Pink", "Clear", "Custom"]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xl) {
                Text("What do you need?")
                    .font(AppTheme.Typography.title1)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                    .padding(.top, AppTheme.Spacing.base)
                
                // Quantity
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    Text("Quantity")
                        .font(AppTheme.Typography.headline)
                    
                    HStack {
                        Button(action: { if quantity > 10 { quantity -= 10 } }) {
                            Image(systemName: "minus.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(AppTheme.Colors.primary)
                        }
                        
                        TextField("Qty", value: $quantity, formatter: NumberFormatter())
                            .font(AppTheme.Typography.title2)
                            .multilineTextAlignment(.center)
                            .keyboardType(.numberPad)
                            .frame(width: 100)
                        
                        Button(action: { quantity += 10 }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(AppTheme.Colors.primary)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(AppTheme.CornerRadius.medium)
                    .shadow(color: Color.black.opacity(0.05), radius: 5)
                }
                
                // Colour
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    Text("Colour")
                        .font(AppTheme.Typography.headline)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(colors, id: \.self) { color in
                                Button(action: { selectedColour = color }) {
                                    Text(color)
                                        .font(AppTheme.Typography.subheadline)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                        .background(selectedColour == color ? AppTheme.Colors.primary : Color.white)
                                        .foregroundColor(selectedColour == color ? .white : AppTheme.Colors.textPrimary)
                                        .cornerRadius(AppTheme.CornerRadius.pill)
                                        .shadow(color: Color.black.opacity(0.05), radius: 2)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                // Customizations
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    Text("Customization")
                        .font(AppTheme.Typography.headline)
                    
                    FlowLayout(spacing: 8) {
                        ForEach([CustomizationOption.logoPrinting, .customColour, .labelPrinting], id: \.self) { option in
                            Button(action: {
                                if selectedCustomizations.contains(option) {
                                    selectedCustomizations.remove(option)
                                } else {
                                    selectedCustomizations.insert(option)
                                }
                            }) {
                                HStack {
                                    Image(systemName: option.iconName)
                                    Text(option.displayName)
                                }
                                .font(AppTheme.Typography.subheadline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(selectedCustomizations.contains(option) ? AppTheme.Colors.primarySubtle : Color.white)
                                .foregroundColor(selectedCustomizations.contains(option) ? AppTheme.Colors.primaryDark : AppTheme.Colors.textPrimary)
                                .cornerRadius(AppTheme.CornerRadius.medium)
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                                        .stroke(selectedCustomizations.contains(option) ? AppTheme.Colors.primary : AppTheme.Colors.surfaceBorder, lineWidth: 1)
                                )
                            }
                        }
                    }
                }
                
                // Budget
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    Text("Budget per piece")
                        .font(AppTheme.Typography.headline)
                    
                    BudgetRangeSlider(minPrice: $minBudget, maxPrice: $maxBudget, bounds: 5...100)
                        .padding(.top, AppTheme.Spacing.md)
                }
                
                // Notes
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    Text("Anything else? (Optional)")
                        .font(AppTheme.Typography.headline)
                    
                    TextEditor(text: $notes)
                        .frame(height: 100)
                        .padding(8)
                        .background(Color.white)
                        .cornerRadius(AppTheme.CornerRadius.medium)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                                .stroke(AppTheme.Colors.surfaceBorder, lineWidth: 1)
                        )
                }
                
                Button(action: {
                    // Save requirement to dataManager
                    let req = Requirement(
                        detectedProduct: dataManager.currentAnalysis ?? ProductAnalysis.example,
                        category: dataManager.selectedCategory ?? .cosmeticBottle,
                        quantity: quantity,
                        colour: selectedColour,
                        customizations: Array(selectedCustomizations),
                        budgetMin: minBudget,
                        budgetMax: maxBudget,
                        notes: notes
                    )
                    dataManager.currentRequirement = req
                    router.navigate(to: .requirementSummary)
                }) {
                    Text("Review Requirements")
                }
                .buttonStyle(PrimaryCTA())
                .padding(.top, AppTheme.Spacing.lg)
                
                Spacer(minLength: 40)
            }
            .padding(.horizontal, AppTheme.Spacing.base)
        }
        .background(AppTheme.Colors.backgroundSecondary.ignoresSafeArea())
        .navigationTitle("Requirements")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Simple FlowLayout for SwiftUI
struct FlowLayout: Layout {
    var spacing: CGFloat
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        var height: CGFloat = 0
        var width: CGFloat = 0
        
        for row in rows {
            let rowHeight = row.map { $0.sizeThatFits(.unspecified).height }.max() ?? 0
            height += rowHeight + spacing
            let rowWidth = row.map { $0.sizeThatFits(.unspecified).width }.reduce(0, +) + CGFloat(row.count - 1) * spacing
            width = max(width, rowWidth)
        }
        
        return CGSize(width: width, height: max(0, height - spacing))
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        var y = bounds.minY
        
        for row in rows {
            var x = bounds.minX
            let rowHeight = row.map { $0.sizeThatFits(.unspecified).height }.max() ?? 0
            
            for view in row {
                let size = view.sizeThatFits(.unspecified)
                view.place(at: CGPoint(x: x, y: y), proposal: .unspecified)
                x += size.width + spacing
            }
            
            y += rowHeight + spacing
        }
    }
    
    private func computeRows(proposal: ProposedViewSize, subviews: Subviews) -> [[LayoutSubview]] {
        var rows: [[LayoutSubview]] = [[]]
        var currentRowWidth: CGFloat = 0
        let maxWidth = proposal.width ?? .infinity
        
        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            
            if currentRowWidth + size.width > maxWidth, !rows[rows.count - 1].isEmpty {
                rows.append([view])
                currentRowWidth = size.width + spacing
            } else {
                rows[rows.count - 1].append(view)
                currentRowWidth += size.width + spacing
            }
        }
        
        return rows
    }
}
