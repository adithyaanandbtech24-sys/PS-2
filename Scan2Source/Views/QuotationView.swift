import SwiftUI

struct QuotationView: View {
    @Environment(AppRouter.self) private var router
    @Environment(DataManager.self) private var dataManager
    
    let enquiryId: UUID
    
    var body: some View {
        Group {
            if let quotation = dataManager.getQuotation(for: enquiryId),
               let enquiry = dataManager.getEnquiry(id: enquiryId),
               let supplier = dataManager.getSupplier(id: quotation.supplierId),
               let product = dataManager.getProduct(id: enquiry.productId) {
                
                ScrollView {
                    VStack(spacing: AppTheme.Spacing.lg) {
                        
                        // Supplier Summary Card
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Quoted By")
                                    .font(AppTheme.Typography.caption)
                                    .foregroundColor(AppTheme.Colors.textSecondary)
                                Text(supplier.companyName)
                                    .font(AppTheme.Typography.headline)
                                Text(product.friendlyName)
                                    .font(AppTheme.Typography.subheadline)
                                    .foregroundColor(AppTheme.Colors.textSecondary)
                            }
                            Spacer()
                            Image(systemName: "doc.text.fill")
                                .font(.largeTitle)
                                .foregroundColor(AppTheme.Colors.accent)
                        }
                        .padding()
                        .background(AppTheme.Colors.surface)
                        .cornerRadius(AppTheme.CornerRadius.medium)
                        
                        // Price Card
                        VStack(spacing: AppTheme.Spacing.md) {
                            Text("Quoted Price")
                                .font(AppTheme.Typography.subheadline)
                                .foregroundColor(AppTheme.Colors.textSecondary)
                            
                            Text(quotation.formattedPrice)
                                .font(.system(size: 48, weight: .bold, design: .rounded))
                                .foregroundColor(AppTheme.Colors.success)
                            
                            Text("per piece")
                                .font(AppTheme.Typography.callout)
                                .foregroundColor(AppTheme.Colors.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.xl)
                        .background(AppTheme.Colors.surface)
                        .cornerRadius(AppTheme.CornerRadius.large)
                        .shadow(color: AppTheme.Colors.success.opacity(0.1), radius: 20, x: 0, y: 10)
                        
                        // Details List
                        VStack(spacing: 0) {
                            DetailRow(title: "Minimum Order Quantity", value: "\(quotation.moq) pcs")
                            Divider().padding(.horizontal)
                            DetailRow(title: "Lead Time", value: quotation.leadTime)
                            Divider().padding(.horizontal)
                            DetailRow(title: "Sample Availability", value: quotation.sampleAvailable ? "Available" : "Not Available")
                            if let samplePrice = quotation.samplePrice {
                                Divider().padding(.horizontal)
                                DetailRow(title: "Sample Price", value: "₹\(String(format: "%.0f", samplePrice))")
                            }
                            Divider().padding(.horizontal)
                            DetailRow(title: "Valid Until", value: quotation.formattedValidUntil)
                        }
                        .background(AppTheme.Colors.surface)
                        .cornerRadius(AppTheme.CornerRadius.medium)
                        
                        if !quotation.notes.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Supplier Notes")
                                    .font(AppTheme.Typography.headline)
                                Text(quotation.notes)
                                    .font(AppTheme.Typography.body)
                                    .foregroundColor(AppTheme.Colors.textSecondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(AppTheme.Colors.surface)
                            .cornerRadius(AppTheme.CornerRadius.medium)
                        }
                        
                        Spacer(minLength: 40)
                        
                        // Actions
                        VStack(spacing: AppTheme.Spacing.md) {
                            Button("Accept & Continue") {
                                // Accept logic
                            }
                            .buttonStyle(PrimaryCTA())
                            
                            Button("Contact Supplier") {
                                // Contact logic
                            }
                            .buttonStyle(SecondaryCTA())
                        }
                    }
                    .padding()
                }
                .background(AppTheme.Colors.backgroundSecondary.ignoresSafeArea())
                .navigationTitle("Quotation")
                .navigationBarTitleDisplayMode(.inline)
                
            } else {
                Text("Quotation not found.")
            }
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(AppTheme.Colors.textSecondary)
            Spacer()
            Text(value)
                .bold()
                .foregroundColor(AppTheme.Colors.textPrimary)
        }
        .padding()
    }
}
