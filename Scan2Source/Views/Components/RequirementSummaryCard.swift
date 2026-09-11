import SwiftUI

struct RequirementSummaryCard: View {
    let requirement: Requirement
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            HStack {
                ZStack {
                    Circle()
                        .fill(AppTheme.Colors.primaryLight)
                        .frame(width: 48, height: 48)
                    Image(systemName: requirement.category.iconName)
                        .foregroundColor(AppTheme.Colors.primary)
                        .font(.system(size: 24))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(requirement.colour) \(requirement.category.displayName)")
                        .font(AppTheme.Typography.headline)
                        .foregroundColor(AppTheme.Colors.textPrimary)
                    Text("\(requirement.detectedProduct.estimatedCapacity) • \(requirement.detectedProduct.material)")
                        .font(AppTheme.Typography.subheadline)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
                
                Spacer()
            }
            
            Divider()
            
            HStack {
                Label("\(requirement.quantity) pieces", systemImage: "shippingbox.fill")
                    .font(AppTheme.Typography.subheadline)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                Spacer()
                Label("₹\(Int(requirement.budgetMin))-₹\(Int(requirement.budgetMax))/pc", systemImage: "indianrupesign")
                    .font(AppTheme.Typography.subheadline)
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
            
            if !requirement.customizations.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(requirement.customizations, id: \.self) { customization in
                            Text(customization.displayName)
                                .font(AppTheme.Typography.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(AppTheme.Colors.primarySubtle)
                                .foregroundColor(AppTheme.Colors.primaryDark)
                                .cornerRadius(4)
                        }
                    }
                }
            }
        }
        .padding(AppTheme.Spacing.base)
        .cardStyle()
    }
}
