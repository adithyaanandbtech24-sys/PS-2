import SwiftUI

struct EnquirySentView: View {
    @Environment(AppRouter.self) private var router
    @Environment(DataManager.self) private var dataManager
    
    let enquiryId: UUID
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.0
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.xxl) {
            Spacer()
            
            // Success Animation
            ZStack {
                Circle()
                    .fill(AppTheme.Colors.success.opacity(0.2))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(AppTheme.Colors.success)
            }
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.6, blendDuration: 0.5)) {
                    scale = 1.0
                    opacity = 1.0
                }
            }
            
            VStack(spacing: AppTheme.Spacing.sm) {
                Text("Your enquiry has been sent!")
                    .font(AppTheme.Typography.title2)
                    .multilineTextAlignment(.center)
                
                Text("The supplier will review your requirements and get back to you soon.")
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            if let enquiry = dataManager.getEnquiry(id: enquiryId),
               let supplier = dataManager.getSupplier(id: enquiry.supplierId),
               let product = dataManager.getProduct(id: enquiry.productId) {
                
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    HStack {
                        Text("Supplier:")
                            .foregroundColor(AppTheme.Colors.textSecondary)
                        Spacer()
                        Text(supplier.companyName).bold()
                    }
                    HStack {
                        Text("Product:")
                            .foregroundColor(AppTheme.Colors.textSecondary)
                        Spacer()
                        Text(product.friendlyName).bold()
                    }
                    HStack {
                        Text("Date:")
                            .foregroundColor(AppTheme.Colors.textSecondary)
                        Spacer()
                        Text(enquiry.formattedDate).bold()
                    }
                    
                    Divider().padding(.vertical, 4)
                    
                    HStack {
                        Text("Status:")
                            .foregroundColor(AppTheme.Colors.textSecondary)
                        Spacer()
                        Text("Awaiting Response")
                            .foregroundColor(AppTheme.Colors.warning)
                            .bold()
                    }
                }
                .padding()
                .background(AppTheme.Colors.surface)
                .cornerRadius(AppTheme.CornerRadius.medium)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                        .stroke(AppTheme.Colors.surfaceBorder, lineWidth: 1)
                )
                .padding(.horizontal, AppTheme.Spacing.xl)
            }
            
            Spacer()
            
            VStack(spacing: AppTheme.Spacing.base) {
                Button("View My Enquiries") {
                    router.goToRoot()
                    // Assuming tab selection is handled by MyEnquiries being a route or tab
                    router.navigate(to: .myEnquiries)
                }
                .buttonStyle(PrimaryCTA())
                
                Button("Back to Home") {
                    router.goToRoot()
                }
                .buttonStyle(SecondaryCTA())
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
            .padding(.bottom, AppTheme.Spacing.xl)
        }
        .background(AppTheme.Colors.background.ignoresSafeArea())
        .navigationBarHidden(true)
    }
}
