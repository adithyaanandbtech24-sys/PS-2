import SwiftUI

struct FindingMatchesView: View {
    @Environment(AppRouter.self) private var router
    @Environment(DataManager.self) private var dataManager
    
    @State private var isPulsing = false
    
    let steps = [
        "Matching product type...",
        "Checking quantity availability...",
        "Checking customization options...",
        "Ranking suppliers..."
    ]
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.xxl) {
            Spacer()
            
            VStack(spacing: AppTheme.Spacing.md) {
                // Animated search icon
                ZStack {
                    Circle()
                        .fill(AppTheme.Colors.primary.opacity(0.08))
                        .frame(width: 220, height: 220)
                        .scaleEffect(isPulsing ? 1.5 : 0.8)
                        .opacity(isPulsing ? 0 : 1)
                    
                    Circle()
                        .fill(AppTheme.Colors.primary.opacity(0.15))
                        .frame(width: 170, height: 170)
                        .scaleEffect(isPulsing ? 1.2 : 0.9)
                    
                    Circle()
                        .fill(AppTheme.Gradients.primary)
                        .frame(width: 130, height: 130)
                        .overlay(
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 52))
                                .foregroundColor(.white)
                        )
                        .shadow(color: AppTheme.Colors.primary.opacity(0.4), radius: 20)
                }
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: false)) {
                        isPulsing = true
                    }
                }
                
                Text("Finding your perfect suppliers…")
                    .font(AppTheme.Typography.title3)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppTheme.Spacing.xl)
                
                Text("Matching against 50+ packaging products and 20+ verified suppliers")
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppTheme.Spacing.xxl)
            }
            
            AnimatedProgressView(steps: steps) {
                // Run matching engine
                if let req = dataManager.currentRequirement {
                    dataManager.loadMatchesForRequirement(req)
                } else if let cat = dataManager.selectedCategory ?? dataManager.browseCategoryFilter {
                    dataManager.loadMatchesForCategory(cat)
                } else {
                    dataManager.loadMatchesForCategory(.cosmeticBottle)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    router.navigate(to: .supplierResults)
                }
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
            
            Spacer()
        }
        .background(AppTheme.Colors.backgroundSecondary.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { router.goBack() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(AppTheme.Colors.textTertiary)
                }
            }
        }
    }
}
