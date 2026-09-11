import SwiftUI

struct SupplierCard: View {
    let product: Product
    let supplier: Supplier
    let matchScore: Double
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                HStack(alignment: .top, spacing: AppTheme.Spacing.md) {
                    ZStack {
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                            .fill(LinearGradient(
                                colors: [Color(hex: product.category.gradientColors.0), Color(hex: product.category.gradientColors.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: product.category.iconName)
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(product.friendlyName)
                            .font(AppTheme.Typography.headline)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                        
                        Text(supplier.companyName)
                            .font(AppTheme.Typography.subheadline)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                        
                        VerificationBadges(badges: supplier.verificationBadges)
                            .padding(.top, 4)
                    }
                    
                    Spacer()
                    
                    MatchScoreBadge(score: matchScore)
                }
                
                Divider()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Price Range")
                            .font(AppTheme.Typography.caption)
                            .foregroundColor(AppTheme.Colors.textTertiary)
                        Text("₹\(Int(product.priceMin)) - ₹\(Int(product.priceMax))")
                            .font(AppTheme.Typography.bodyMedium)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("Min. Order (MOQ)")
                            .font(AppTheme.Typography.caption)
                            .foregroundColor(AppTheme.Colors.textTertiary)
                        Text("\(product.moq) pcs")
                            .font(AppTheme.Typography.bodyMedium)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                    }
                }
                
                if !product.customizationOptions.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(product.customizationOptions.prefix(3), id: \.self) { option in
                                Text(option.displayName)
                                    .font(AppTheme.Typography.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(AppTheme.Colors.surfaceBorder)
                                    .foregroundColor(AppTheme.Colors.textSecondary)
                                    .cornerRadius(4)
                            }
                            if product.customizationOptions.count > 3 {
                                Text("+\(product.customizationOptions.count - 3)")
                                    .font(AppTheme.Typography.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(AppTheme.Colors.surfaceBorder)
                                    .foregroundColor(AppTheme.Colors.textSecondary)
                                    .cornerRadius(4)
                            }
                        }
                    }
                }
                
                Text("View Details")
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(AppTheme.Colors.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppTheme.Spacing.sm)
                    .background(AppTheme.Colors.primarySubtle)
                    .cornerRadius(AppTheme.CornerRadius.small)
            }
            .padding(AppTheme.Spacing.base)
            .cardStyle()
        }
        .buttonStyle(.plain)
    }
}
