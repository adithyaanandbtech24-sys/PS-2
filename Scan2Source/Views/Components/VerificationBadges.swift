import SwiftUI

struct VerificationBadges: View {
    let badges: [VerificationBadge]
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            ForEach(badges, id: \.self) { badge in
                HStack(spacing: 4) {
                    Image(systemName: badge.iconName)
                        .font(.system(size: 10))
                    Text(badge.displayName)
                        .font(.system(size: 10, weight: .semibold))
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 4)
                .background(Color(hex: badge.color).opacity(0.1))
                .foregroundColor(Color(hex: badge.color))
                .cornerRadius(4)
            }
        }
    }
}
