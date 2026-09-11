import SwiftUI

struct BrowseCategoriesView: View {
    @Environment(AppRouter.self) private var router
    @Environment(DataManager.self) private var dataManager
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @State private var selectedCategory: PackagingCategory? = nil
    @State private var appeared = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                // Header
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    Text("Browse Categories")
                        .font(AppTheme.Typography.largeTitle)
                        .foregroundColor(AppTheme.Colors.textPrimary)
                    Text("Find packaging by type")
                        .font(AppTheme.Typography.subheadline)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
                .padding(.horizontal)
                .padding(.top, AppTheme.Spacing.base)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : -10)
                
                // Category Grid
                LazyVGrid(columns: columns, spacing: AppTheme.Spacing.base) {
                    ForEach(Array(PackagingCategory.allCases.enumerated()), id: \.element) { index, category in
                        BrowseCategoryCard(
                            category: category,
                            count: count(for: category),
                            isSelected: selectedCategory == category
                        )
                        .onTapGesture {
                            selectedCategory = category
                            withAnimation(.spring(response: 0.3)) {
                                dataManager.browseCategoryFilter = category
                                dataManager.loadMatchesForCategory(category)
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                router.navigate(to: .supplierResults)
                            }
                        }
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 20)
                        .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(Double(index) * 0.07), value: appeared)
                    }
                }
                .padding(.horizontal)
                
                // Bottom padding
                Spacer(minLength: AppTheme.Spacing.xxxl)
            }
            .padding(.bottom, AppTheme.Spacing.xxl)
        }
        .background(AppTheme.Colors.backgroundSecondary.ignoresSafeArea())
        .navigationBarHidden(true)
        .onAppear {
            withAnimation {
                appeared = true
            }
        }
        .onDisappear {
            selectedCategory = nil
        }
    }
    
    private func count(for category: PackagingCategory) -> Int {
        dataManager.products.filter { $0.category == category }.count
    }
}

// MARK: - Browse Category Card (grid version with count, different from horizontal chip)
struct BrowseCategoryCard: View {
    let category: PackagingCategory
    let count: Int
    var isSelected: Bool = false
    
    @State private var isPressed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            HStack {
                Image(systemName: category.iconName)
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 48, height: 48)
                    .background(.white.opacity(0.25))
                    .cornerRadius(AppTheme.CornerRadius.medium)
                
                Spacer()
                
                // Arrow indicator
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(category.displayName)
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                HStack(spacing: 4) {
                    Image(systemName: "shippingbox.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.7))
                    Text("\(count) Products")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(.white.opacity(0.85))
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 160)
        .background(
            LinearGradient(
                colors: [Color(hex: category.gradientColors.0), Color(hex: category.gradientColors.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(AppTheme.CornerRadius.large)
        .shadow(color: Color(hex: category.gradientColors.1).opacity(isSelected ? 0.5 : 0.3), radius: isSelected ? 16 : 10, x: 0, y: isSelected ? 8 : 5)
        .scaleEffect(isSelected ? 0.96 : 1.0)
        .animation(.spring(response: 0.3), value: isSelected)
    }
}
