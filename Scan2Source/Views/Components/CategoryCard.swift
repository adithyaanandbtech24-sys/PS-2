import SwiftUI

struct CategoryCard: View {
    let category: PackagingCategory
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AppTheme.Spacing.md) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            colors: [Color(hex: category.gradientColors.0), Color(hex: category.gradientColors.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: category.iconName)
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                }
                
                Text(category.displayName)
                    .font(AppTheme.Typography.captionBold)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 80)
            .padding(.vertical, AppTheme.Spacing.sm)
            .cardStyle()
        }
    }
}
