import SwiftUI

struct SendEnquiryView: View {
    @Environment(AppRouter.self) private var router
    @Environment(DataManager.self) private var dataManager
    
    let supplierId: UUID
    let productId: UUID
    
    @State private var message: String = ""
    @State private var isEditing: Bool = false
    
    var body: some View {
        Group {
            if let supplier = dataManager.getSupplier(id: supplierId),
               let product = dataManager.getProduct(id: productId),
               let requirement = dataManager.currentRequirement {
                
                VStack(spacing: AppTheme.Spacing.md) {
                    
                    // Supplier Info Card
                    HStack(spacing: AppTheme.Spacing.md) {
                        Image(systemName: "building.2.fill")
                            .font(.largeTitle)
                            .foregroundColor(AppTheme.Colors.primary)
                            .frame(width: 60, height: 60)
                            .background(AppTheme.Colors.primarySubtle)
                            .cornerRadius(AppTheme.CornerRadius.medium)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(supplier.companyName)
                                .font(AppTheme.Typography.headline)
                            Text("Enquiring about: \(product.friendlyName)")
                                .font(AppTheme.Typography.subheadline)
                                .foregroundColor(AppTheme.Colors.textSecondary)
                        }
                        Spacer()
                    }
                    .padding()
                    .cardStyle()
                    
                    // Message Composer
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Text("Enquiry Message")
                            .font(AppTheme.Typography.headline)
                        
                        Text("This message was auto-generated from your requirements. Feel free to edit.")
                            .font(AppTheme.Typography.caption)
                            .foregroundColor(AppTheme.Colors.textTertiary)
                        
                        if isEditing {
                            TextEditor(text: $message)
                                .font(AppTheme.Typography.body)
                                .padding(8)
                                .background(Color.white)
                                .cornerRadius(AppTheme.CornerRadius.small)
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.small)
                                        .stroke(AppTheme.Colors.surfaceBorder, lineWidth: 1)
                                )
                                .frame(minHeight: 200)
                        } else {
                            ScrollView {
                                Text(message)
                                    .font(AppTheme.Typography.body)
                                    .foregroundColor(AppTheme.Colors.textPrimary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                            }
                            .frame(minHeight: 200)
                            .background(AppTheme.Colors.backgroundTertiary)
                            .cornerRadius(AppTheme.CornerRadius.medium)
                        }
                    }
                    .padding()
                    .cardStyle()
                    
                    Spacer()
                    
                    // Buttons
                    VStack(spacing: AppTheme.Spacing.md) {
                        Button(isEditing ? "Done Editing" : "Edit Message") {
                            withAnimation {
                                isEditing.toggle()
                            }
                        }
                        .buttonStyle(SecondaryCTA())
                        
                        Button("Send Enquiry") {
                            let enquiry = Enquiry(
                                userId: UUID(), // use actual user ID in real app
                                supplierId: supplier.id,
                                productId: product.id,
                                requirementId: requirement.id,
                                message: message
                            )
                            dataManager.addEnquiry(enquiry)
                            router.navigate(to: .enquirySent(enquiryId: enquiry.id))
                        }
                        .buttonStyle(PrimaryCTA())
                    }
                    .padding()
                }
                .padding(.vertical)
                .background(AppTheme.Colors.backgroundSecondary.ignoresSafeArea())
                .navigationTitle("Send Enquiry")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    if message.isEmpty {
                        message = Enquiry.generateMessage(product: product, requirement: requirement)
                    }
                }
                
            } else {
                Text("Error loading details.")
            }
        }
    }
}
