import SwiftUI

struct HomeView: View {
    @Environment(AppRouter.self) private var router
    @Environment(DataManager.self) private var dataManager
    @State private var searchText = ""
    @State private var appeared = false
    
    let featuredCategories: [PackagingCategory] = [.cosmeticBottle, .pumpBottle, .jar, .pouch, .box]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xl) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Hello! 👋")
                            .font(AppTheme.Typography.title1)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                        Text("What packaging are you sourcing today?")
                            .font(AppTheme.Typography.subheadline)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                    }
                    Spacer()
                    Button(action: {
                        router.navigate(to: .profile)
                    }) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 38))
                            .foregroundStyle(AppTheme.Gradients.primary)
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.base)
                .padding(.top, AppTheme.Spacing.base)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : -10)
                
                // Search Bar
                SearchBar(text: $searchText, placeholder: "Search packaging or suppliers")
                    .padding(.horizontal, AppTheme.Spacing.base)
                    .opacity(appeared ? 1 : 0)
                
                // Primary Scan CTA
                Button(action: {
                    router.navigate(to: .scanProduct)
                }) {
                    HStack(spacing: AppTheme.Spacing.base) {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                            HStack(spacing: AppTheme.Spacing.sm) {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 14))
                                Text("AI-Powered")
                                    .font(AppTheme.Typography.captionBold)
                            }
                            .foregroundColor(.white.opacity(0.85))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(.white.opacity(0.2))
                            .cornerRadius(AppTheme.CornerRadius.pill)
                            
                            Text("Scan a Product")
                                .font(AppTheme.Typography.title2)
                                .foregroundColor(.white)
                            Text("Show us what you want")
                                .font(AppTheme.Typography.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        Spacer()
                        ZStack {
                            Circle()
                                .fill(.white.opacity(0.2))
                                .frame(width: 70, height: 70)
                            Image(systemName: "camera.viewfinder")
                                .font(.system(size: 36))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(AppTheme.Spacing.xl)
                    .background(AppTheme.Gradients.primary)
                    .cornerRadius(AppTheme.CornerRadius.xl)
                    .shadow(color: AppTheme.Colors.primary.opacity(0.35), radius: 16, x: 0, y: 8)
                }
                .padding(.horizontal, AppTheme.Spacing.base)
                .opacity(appeared ? 1 : 0)
                .scaleEffect(appeared ? 1 : 0.95)
                
                // Quick Actions Row
                HStack(spacing: AppTheme.Spacing.md) {
                    QuickActionButton(icon: "doc.text.fill", title: "My Enquiries", color: AppTheme.Colors.accent) {
                        router.navigate(to: .myEnquiries)
                    }
                    QuickActionButton(icon: "heart.fill", title: "Saved", color: Color(hex: "#EC4899")) {
                        // Saved screen - future
                    }
                    QuickActionButton(icon: "chart.bar.fill", title: "Analytics", color: Color(hex: "#8B5CF6")) {
                        // Analytics - future
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.base)
                .opacity(appeared ? 1 : 0)
                
                // Categories Section
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    HStack {
                        Text("Browse Categories")
                            .font(AppTheme.Typography.title3)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                        Spacer()
                        Button("See All") {
                            router.navigate(to: .browseCategories)
                        }
                        .font(AppTheme.Typography.subheadline)
                        .foregroundColor(AppTheme.Colors.primary)
                    }
                    .padding(.horizontal, AppTheme.Spacing.base)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: AppTheme.Spacing.md) {
                            ForEach(featuredCategories, id: \.self) { category in
                                CategoryCard(category: category) {
                                    dataManager.browseCategoryFilter = category
                                    dataManager.loadMatchesForCategory(category)
                                    router.navigate(to: .supplierResults)
                                }
                            }
                        }
                        .padding(.horizontal, AppTheme.Spacing.base)
                        .padding(.bottom, AppTheme.Spacing.sm)
                    }
                }
                .opacity(appeared ? 1 : 0)
                
                // How it works
                HowItWorksSection()
                    .opacity(appeared ? 1 : 0)
                
                Spacer(minLength: 100)
            }
        }
        .background(AppTheme.Colors.backgroundSecondary.ignoresSafeArea())
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                appeared = true
            }
        }
    }
}

// MARK: - Quick Action Button
struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AppTheme.Spacing.sm) {
                ZStack {
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                        .fill(color.opacity(0.1))
                        .frame(height: 52)
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundColor(color)
                }
                Text(title)
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - How It Works Section
struct HowItWorksSection: View {
    let steps = [
        ("camera.viewfinder", "Scan", "Photo or upload"),
        ("brain.head.profile", "AI Analyse", "Smart matching"),
        ("person.2.fill", "Connect", "Find suppliers"),
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("How it works")
                .font(AppTheme.Typography.title3)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .padding(.horizontal, AppTheme.Spacing.base)
            
            HStack(spacing: 0) {
                ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                    VStack(spacing: AppTheme.Spacing.sm) {
                        ZStack {
                            Circle()
                                .fill(AppTheme.Gradients.primary)
                                .frame(width: 52, height: 52)
                            Image(systemName: step.0)
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                        Text(step.1)
                            .font(AppTheme.Typography.captionBold)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                        Text(step.2)
                            .font(.system(size: 11))
                            .foregroundColor(AppTheme.Colors.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    
                    if index < steps.count - 1 {
                        Rectangle()
                            .fill(AppTheme.Colors.primary.opacity(0.2))
                            .frame(width: 30, height: 2)
                            .offset(y: -16)
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(AppTheme.CornerRadius.large)
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
            .padding(.horizontal, AppTheme.Spacing.base)
        }
    }
}

struct BottomNavButton: View {
    let icon: String
    let title: String
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                Text(title)
                    .font(.system(size: 10, weight: .medium))
            }
            .foregroundColor(isActive ? AppTheme.Colors.primary : AppTheme.Colors.textTertiary)
        }
    }
}
