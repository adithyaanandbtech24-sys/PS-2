import SwiftUI

struct SupplierDetailView: View {
    @Environment(AppRouter.self) private var router
    @Environment(DataManager.self) private var dataManager
    
    let supplierId: UUID
    let productId: UUID
    
    var body: some View {
        Group {
            if let supplier = dataManager.getSupplier(id: supplierId),
               let product = dataManager.getProduct(id: productId) {
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Header
                        VStack(spacing: AppTheme.Spacing.md) {
                            Text(supplier.companyName)
                                .font(AppTheme.Typography.title1)
                                .multilineTextAlignment(.center)
                            
                            HStack {
                                Image(systemName: "mappin.circle.fill")
                                Text(supplier.location)
                            }
                            .font(AppTheme.Typography.subheadline)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                            
                            HStack(spacing: 4) {
                                Text(supplier.ratingStars)
                                    .foregroundColor(AppTheme.Colors.star)
                                Text("(\(supplier.reviewCount) Reviews)")
                                    .foregroundColor(AppTheme.Colors.textTertiary)
                            }
                            .font(AppTheme.Typography.subheadline)
                            
                            Text("Est. \(String(supplier.yearEstablished))")
                                .font(AppTheme.Typography.caption)
                                .foregroundColor(AppTheme.Colors.textTertiary)
                            
                            // Badges
                            HStack {
                                ForEach(supplier.verificationBadges, id: \.self) { badge in
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
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(AppTheme.Colors.surface)
                        
                        // Product Highlight
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                            Text("Matched Product")
                                .font(AppTheme.Typography.title3)
                            
                            HStack(spacing: AppTheme.Spacing.md) {
                                LinearGradient(colors: [Color(hex: product.category.gradientColors.0), Color(hex: product.category.gradientColors.1)], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(AppTheme.CornerRadius.medium)
                                    .overlay(
                                        Image(systemName: product.category.iconName)
                                            .foregroundColor(.white)
                                            .font(.title)
                                    )
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(product.friendlyName)
                                        .font(AppTheme.Typography.headline)
                                    Text("Capacity: \(product.capacity) • Material: \(product.material)")
                                        .font(AppTheme.Typography.subheadline)
                                        .foregroundColor(AppTheme.Colors.textSecondary)
                                    Text("MOQ: \(product.moq) | ₹\(Int(product.priceMin))-₹\(Int(product.priceMax))")
                                        .font(AppTheme.Typography.subheadline)
                                        .foregroundColor(AppTheme.Colors.textSecondary)
                                }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Divider().padding(.horizontal)
                        
                        // About
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                            Text("About Supplier")
                                .font(AppTheme.Typography.title3)
                            Text(supplier.about.isEmpty ? "No description available for this supplier." : supplier.about)
                                .font(AppTheme.Typography.body)
                                .foregroundColor(AppTheme.Colors.textSecondary)
                                .lineSpacing(4)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Stats
                        HStack {
                            SupplierStatBox(title: "Response Time", value: supplier.responseTime)
                            SupplierStatBox(title: "Lead Time", value: supplier.leadTime)
                            SupplierStatBox(title: "Products", value: "\(supplier.totalProducts)")
                        }
                        .padding(.horizontal)
                        
                        // Reviews
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                            Text("Reviews")
                                .font(AppTheme.Typography.title3)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: AppTheme.Spacing.md) {
                                    ReviewCard(review: Review(userName: "Rahul S.", rating: 5.0, comment: "Excellent quality and fast delivery. Highly recommended!"))
                                    ReviewCard(review: Review(userName: "Anjali K.", rating: 4.0, comment: "Good communication, products met expectations."))
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                        
                        // Disclaimer
                        Text("Manufacturing, payment and delivery are handled directly by the third-party supplier.")
                            .font(AppTheme.Typography.caption)
                            .foregroundColor(AppTheme.Colors.textTertiary)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    .padding(.bottom, 100) // Space for sticky buttons
                }
                .background(AppTheme.Colors.backgroundSecondary.ignoresSafeArea())
                .overlay(
                    // Sticky Bottom Bar
                    VStack {
                        Spacer()
                        HStack(spacing: AppTheme.Spacing.md) {
                            Button(action: {
                                // Save logic here
                            }) {
                                Image(systemName: "heart")
                                    .font(.title2)
                                    .foregroundColor(AppTheme.Colors.primary)
                                    .frame(width: 50, height: 50)
                                    .background(AppTheme.Colors.surface)
                                    .cornerRadius(AppTheme.CornerRadius.medium)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                                            .stroke(AppTheme.Colors.primary.opacity(0.3), lineWidth: 1)
                                    )
                            }
                            
                            Button("Send Enquiry") {
                                router.navigate(to: .sendEnquiry(supplierId: supplier.id, productId: product.id))
                            }
                            .buttonStyle(PrimaryCTA())
                        }
                        .padding()
                        .background(AppTheme.Colors.surface)
                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: -5)
                    }
                    , alignment: .bottom
                )
                
            } else {
                Text("Supplier or Product not found.")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SupplierStatBox: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(AppTheme.Typography.headline)
                .foregroundColor(AppTheme.Colors.primaryDark)
            Text(title)
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(AppTheme.Colors.primarySubtle)
        .cornerRadius(AppTheme.CornerRadius.medium)
    }
}

struct ReviewCard: View {
    let review: Review
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(review.userName)
                    .font(AppTheme.Typography.subheadline)
                    .bold()
                Spacer()
                Text(String(repeating: "★", count: Int(review.rating)))
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.star)
            }
            Text(review.comment)
                .font(AppTheme.Typography.callout)
                .foregroundColor(AppTheme.Colors.textSecondary)
                .lineLimit(3)
        }
        .padding()
        .frame(width: 250)
        .cardStyle()
    }
}
