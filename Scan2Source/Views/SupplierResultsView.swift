import SwiftUI

struct SupplierResultsView: View {
    @Environment(AppRouter.self) private var router
    @Environment(DataManager.self) private var dataManager
    
    @State private var sortOption: String = "Best Match"
    @State private var showFilters: Bool = false
    @State private var appeared = false
    
    let sortOptions = ["Best Match", "Lowest Price", "Lowest MOQ"]
    
    var sortedMatches: [MatchResult] {
        switch sortOption {
        case "Lowest Price":
            return dataManager.currentMatches.sorted { $0.product.priceMin < $1.product.priceMin }
        case "Lowest MOQ":
            return dataManager.currentMatches.sorted { $0.product.moq < $1.product.moq }
        default:
            return dataManager.currentMatches.sorted { $0.match.finalScore > $1.match.finalScore }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header bar
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Best Matches")
                            .font(AppTheme.Typography.title3)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                        if let cat = dataManager.browseCategoryFilter {
                            Text(cat.displayName)
                                .font(AppTheme.Typography.caption)
                                .foregroundColor(AppTheme.Colors.primary)
                        }
                    }
                    Spacer()
                    
                    Text("\(dataManager.currentMatches.count) results")
                        .font(AppTheme.Typography.subheadline)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                    
                    Button(action: { showFilters.toggle() }) {
                        Image(systemName: "line.3.horizontal.decrease.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(AppTheme.Colors.primary)
                    }
                    .padding(.leading, AppTheme.Spacing.sm)
                }
                
                Picker("Sort", selection: $sortOption) {
                    ForEach(sortOptions, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding()
            .background(AppTheme.Colors.surface)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            
            // Results list
            ScrollView {
                if sortedMatches.isEmpty {
                    emptyState
                } else {
                    LazyVStack(spacing: AppTheme.Spacing.base) {
                        ForEach(Array(sortedMatches.enumerated()), id: \.element.id) { index, result in
                            SupplierMatchCard(result: result)
                                .opacity(appeared ? 1 : 0)
                                .offset(y: appeared ? 0 : 20)
                                .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(Double(index) * 0.05), value: appeared)
                                .onTapGesture {
                                    router.navigate(to: .supplierDetail(supplierId: result.supplier.id, productId: result.product.id))
                                }
                        }
                    }
                    .padding()
                }
            }
        }
        .background(AppTheme.Colors.backgroundSecondary.ignoresSafeArea())
        .navigationTitle("Results")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .sheet(isPresented: $showFilters) {
            FilterSheetView()
        }
        .onAppear {
            withAnimation {
                appeared = true
            }
        }
    }
    
    var emptyState: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Spacer(minLength: 80)
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(AppTheme.Colors.textTertiary)
            Text("No Matches Found")
                .font(AppTheme.Typography.title2)
                .foregroundColor(AppTheme.Colors.textPrimary)
            Text("Try adjusting your filters or requirements.")
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(.top, 60)
    }
}

// MARK: - Supplier Match Card (uses MatchResult)
struct SupplierMatchCard: View {
    @Environment(AppRouter.self) private var router
    let result: MatchResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Gradient Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(result.product.friendlyName)
                        .font(AppTheme.Typography.headline)
                        .foregroundColor(.white)
                        .lineLimit(2)
                    Text(result.supplier.companyName)
                        .font(AppTheme.Typography.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(result.match.matchPercentage)%")
                        .font(AppTheme.Typography.title2)
                        .foregroundColor(.white)
                    Text("Match")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(8)
                .background(.ultraThinMaterial)
                .cornerRadius(AppTheme.CornerRadius.medium)
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [Color(hex: result.product.category.gradientColors.0), Color(hex: result.product.category.gradientColors.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                // Verification Badges
                HStack {
                    ForEach(result.supplier.verificationBadges, id: \.self) { badge in
                        HStack(spacing: 4) {
                            Image(systemName: badge.iconName)
                            Text(badge.displayName)
                        }
                        .font(AppTheme.Typography.captionBold)
                        .foregroundColor(Color(hex: badge.color))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(hex: badge.color).opacity(0.1))
                        .cornerRadius(AppTheme.CornerRadius.small)
                    }
                }
                
                // Details
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label(result.supplier.location, systemImage: "mappin.and.ellipse")
                            .font(AppTheme.Typography.subheadline)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                        
                        Label("MOQ: \(result.product.moq) pcs", systemImage: "shippingbox")
                            .font(AppTheme.Typography.subheadline)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("₹\(Int(result.product.priceMin)) – ₹\(Int(result.product.priceMax))")
                            .font(AppTheme.Typography.price)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                        Text("per piece")
                            .font(AppTheme.Typography.caption)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                    }
                }
                
                // Match Reasons
                if !result.match.matchReasons.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(result.match.matchReasons.prefix(3), id: \.self) { reason in
                            HStack(spacing: 6) {
                                Image(systemName: reason.iconName)
                                    .foregroundColor(AppTheme.Colors.success)
                                Text(reason.displayText)
                                    .font(AppTheme.Typography.caption)
                                    .foregroundColor(AppTheme.Colors.textSecondary)
                            }
                        }
                    }
                    .padding(.top, 4)
                }
                
                // CTA
                Button("View Supplier →") {
                    router.navigate(to: .supplierDetail(supplierId: result.supplier.id, productId: result.product.id))
                }
                .buttonStyle(SecondaryCTA())
                .padding(.top, 4)
            }
            .padding()
        }
        .cardStyle()
    }
}

// MARK: - Filter Sheet
struct FilterSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var verifiedOnly = false
    @State private var maxMOQ = 1000.0
    
    var body: some View {
        NavigationView {
            Form {
                Section("Price Range") {
                    Text("₹5 – ₹100 per piece")
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
                Section("Minimum Order Quantity") {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Text("Up to \(Int(maxMOQ)) pieces")
                        Slider(value: $maxMOQ, in: 50...5000, step: 50)
                            .tint(AppTheme.Colors.primary)
                    }
                }
                Section("Supplier Quality") {
                    Toggle("Verified Suppliers Only", isOn: $verifiedOnly)
                        .tint(AppTheme.Colors.primary)
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        verifiedOnly = false
                        maxMOQ = 1000
                    }
                    .foregroundColor(AppTheme.Colors.textSecondary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") { dismiss() }
                        .foregroundColor(AppTheme.Colors.primary)
                        .fontWeight(.semibold)
                }
            }
        }
    }
}
