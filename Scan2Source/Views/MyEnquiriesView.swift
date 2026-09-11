import SwiftUI

struct MyEnquiriesView: View {
    @Environment(AppRouter.self) private var router
    @Environment(DataManager.self) private var dataManager
    
    @State private var selectedTab: EnquiryTab = .active
    
    var filteredEnquiries: [Enquiry] {
        dataManager.enquiries.filter { $0.status.tab == selectedTab }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Picker("Enquiry Tab", selection: $selectedTab) {
                ForEach(EnquiryTab.allCases, id: \.self) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            .background(AppTheme.Colors.surface)
            
            ScrollView {
                if filteredEnquiries.isEmpty {
                    emptyState
                } else {
                    LazyVStack(spacing: AppTheme.Spacing.base) {
                        ForEach(filteredEnquiries) { enquiry in
                            EnquiryCard(enquiry: enquiry)
                                .onTapGesture {
                                    if enquiry.status == .quotationReceived {
                                        router.navigate(to: .quotationDetail(enquiryId: enquiry.id))
                                    }
                                }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("My Enquiries")
        .navigationBarTitleDisplayMode(.large)
        .background(AppTheme.Colors.backgroundSecondary.ignoresSafeArea())
    }
    
    var emptyState: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Image(systemName: "tray")
                .font(.system(size: 60))
                .foregroundColor(AppTheme.Colors.textTertiary)
            Text("No \(selectedTab.rawValue) Enquiries")
                .font(AppTheme.Typography.title2)
            Text("You don't have any enquiries in this section yet.")
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 100)
    }
}

struct EnquiryCard: View {
    @Environment(DataManager.self) private var dataManager
    let enquiry: Enquiry
    
    var body: some View {
        Group {
            if let supplier = dataManager.getSupplier(id: enquiry.supplierId),
               let product = dataManager.getProduct(id: enquiry.productId) {
                
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(supplier.companyName)
                                .font(AppTheme.Typography.headline)
                            Text(product.friendlyName)
                                .font(AppTheme.Typography.subheadline)
                                .foregroundColor(AppTheme.Colors.textSecondary)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            Text(enquiry.formattedDate)
                                .font(AppTheme.Typography.caption)
                                .foregroundColor(AppTheme.Colors.textTertiary)
                            
                            Text(enquiry.status.displayName)
                                .font(AppTheme.Typography.captionBold)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color(hex: enquiry.status.statusColor).opacity(0.1))
                                .foregroundColor(Color(hex: enquiry.status.statusColor))
                                .cornerRadius(AppTheme.CornerRadius.small)
                        }
                    }
                }
                .padding()
                .cardStyle()
            }
        }
    }
}
