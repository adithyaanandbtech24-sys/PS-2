import SwiftUI

struct RequirementSummaryView: View {
    @Environment(AppRouter.self) private var router
    @Environment(DataManager.self) private var dataManager
    
    var requirement: Requirement {
        dataManager.currentRequirement ?? Requirement(
            detectedProduct: ProductAnalysis.example,
            category: .cosmeticBottle,
            quantity: 50,
            colour: "Blue",
            customizations: [.logoPrinting, .customColour],
            budgetMin: 15,
            budgetMax: 35
        )
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.xl) {
                // Header
                VStack(spacing: AppTheme.Spacing.sm) {
                    Text("You're looking for")
                        .font(AppTheme.Typography.title1)
                        .foregroundColor(AppTheme.Colors.textPrimary)
                    Text("Review your requirements before we find matches")
                        .font(AppTheme.Typography.subheadline)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, AppTheme.Spacing.xl)
                
                // Summary Card
                RequirementSummaryCard(requirement: requirement)
                    .padding(.horizontal, AppTheme.Spacing.base)
                
                // Stats Row
                HStack(spacing: 0) {
                    StatBox(value: "\(requirement.quantity)", label: "Units", icon: "shippingbox.fill", color: AppTheme.Colors.primary)
                    Divider().frame(height: 50)
                    StatBox(value: "₹\(Int(requirement.budgetMin))–\(Int(requirement.budgetMax))", label: "Budget", icon: "indianrupeesign.circle.fill", color: AppTheme.Colors.success)
                    Divider().frame(height: 50)
                    StatBox(value: "\(requirement.customizations.count)", label: "Customize", icon: "paintbrush.fill", color: Color(hex: "#8B5CF6"))
                }
                .padding()
                .background(Color.white)
                .cornerRadius(AppTheme.CornerRadius.large)
                .shadow(color: Color.black.opacity(0.05), radius: 10)
                .padding(.horizontal, AppTheme.Spacing.base)
                
                Spacer(minLength: AppTheme.Spacing.xl)
                
                // CTAs
                VStack(spacing: AppTheme.Spacing.md) {
                    Button(action: {
                        router.navigate(to: .findingMatches)
                    }) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            Text("Find Matches")
                        }
                    }
                    .buttonStyle(PrimaryCTA())
                    
                    Button(action: {
                        router.goBack()
                    }) {
                        Text("Edit Requirements")
                    }
                    .buttonStyle(OutlineCTA())
                }
                .padding(AppTheme.Spacing.base)
            }
        }
        .background(AppTheme.Colors.backgroundSecondary.ignoresSafeArea())
        .navigationTitle("Summary")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StatBox: View {
    let value: String
    let label: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(color)
            Text(value)
                .font(AppTheme.Typography.captionBold)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(AppTheme.Colors.textTertiary)
        }
        .frame(maxWidth: .infinity)
    }
}
