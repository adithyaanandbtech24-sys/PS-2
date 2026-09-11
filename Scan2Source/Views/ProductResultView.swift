import SwiftUI

struct ProductResultView: View {
    @Environment(AppRouter.self) private var router
    @Environment(DataManager.self) private var dataManager
    
    @State private var isEditing = false
    @State private var showDetails = false
    @State private var editedCategory = ""
    @State private var editedCapacity = ""
    @State private var editedClosure = ""
    @State private var editedShape = ""
    
    var analysis: ProductAnalysis {
        dataManager.currentAnalysis ?? ProductAnalysis.example
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.lg) {
                // Title
                VStack(spacing: AppTheme.Spacing.sm) {
                    Text("Here's what we found")
                        .font(AppTheme.Typography.title1)
                        .foregroundColor(AppTheme.Colors.textPrimary)
                    Text("Confirm if this matches your packaging")
                        .font(AppTheme.Typography.subheadline)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
                .multilineTextAlignment(.center)
                .padding(.top, AppTheme.Spacing.base)
                
                // Image
                ZStack {
                    if let image = dataManager.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(AppTheme.CornerRadius.large)
                            .shadow(color: Color.black.opacity(0.1), radius: 16, x: 0, y: 8)
                    } else {
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                            .fill(AppTheme.Gradients.primarySoft)
                            .frame(height: 200)
                            .overlay(
                                VStack(spacing: AppTheme.Spacing.sm) {
                                    Image(systemName: dataManager.selectedCategory?.iconName ?? "photo")
                                        .font(.system(size: 56))
                                        .foregroundColor(AppTheme.Colors.primary)
                                    Text(analysis.category)
                                        .font(AppTheme.Typography.headline)
                                        .foregroundColor(AppTheme.Colors.primaryDark)
                                }
                            )
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.base)
                
                // Result Card
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    // Category + Confidence
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                            Text("Detected Product")
                                .font(AppTheme.Typography.caption)
                                .foregroundColor(AppTheme.Colors.textTertiary)
                                .textCase(.uppercase)
                                .tracking(0.5)
                            if isEditing {
                                TextField("Category", text: $editedCategory)
                                    .font(AppTheme.Typography.title2)
                                    .textFieldStyle(.roundedBorder)
                            } else {
                                Text(analysis.category)
                                    .font(AppTheme.Typography.title2)
                                    .foregroundColor(AppTheme.Colors.textPrimary)
                            }
                        }
                        
                        Spacer()
                        
                        if !isEditing {
                            // Confidence badge
                            VStack(spacing: 4) {
                                ZStack {
                                    Circle()
                                        .stroke(AppTheme.Colors.success.opacity(0.2), lineWidth: 4)
                                        .frame(width: 52, height: 52)
                                    Circle()
                                        .trim(from: 0, to: CGFloat(analysis.confidence))
                                        .stroke(AppTheme.Colors.success, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                                        .rotationEffect(.degrees(-90))
                                        .frame(width: 52, height: 52)
                                    Text("\(Int(analysis.confidence * 100))%")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(AppTheme.Colors.success)
                                }
                                Text("confident")
                                    .font(.system(size: 10))
                                    .foregroundColor(AppTheme.Colors.textTertiary)
                            }
                        }
                    }
                    
                    // Tag Pills
                    HStack(spacing: AppTheme.Spacing.sm) {
                        if isEditing {
                            TextField("Capacity", text: $editedCapacity)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 90)
                            TextField("Type", text: $editedClosure)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 90)
                            TextField("Shape", text: $editedShape)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 100)
                        } else {
                            TagPill(text: analysis.estimatedCapacity, color: AppTheme.Colors.primary)
                            TagPill(text: analysis.closure, color: AppTheme.Colors.accent)
                            TagPill(text: analysis.shape, color: Color(hex: "#8B5CF6"))
                        }
                    }
                    
                    Divider().padding(.vertical, AppTheme.Spacing.sm)
                    
                    // Technical Details
                    DisclosureGroup("View Technical Details", isExpanded: $showDetails) {
                        VStack(spacing: AppTheme.Spacing.sm) {
                            ForEach(analysis.technicalDetails, id: \.label) { detail in
                                HStack {
                                    Text(detail.label)
                                        .font(AppTheme.Typography.body)
                                        .foregroundColor(AppTheme.Colors.textSecondary)
                                    Spacer()
                                    Text(detail.value)
                                        .font(AppTheme.Typography.bodyMedium)
                                        .foregroundColor(AppTheme.Colors.textPrimary)
                                }
                            }
                        }
                        .padding(.top, AppTheme.Spacing.sm)
                    }
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(AppTheme.Colors.primary)
                    .accentColor(AppTheme.Colors.primary)
                }
                .padding(AppTheme.Spacing.base)
                .cardStyle()
                .padding(.horizontal, AppTheme.Spacing.base)
                
                // Action Buttons
                VStack(spacing: AppTheme.Spacing.md) {
                    if isEditing {
                        Button(action: {
                            // Apply edits to current analysis
                            dataManager.currentAnalysis = ProductAnalysis(
                                category: editedCategory.isEmpty ? analysis.category : editedCategory,
                                estimatedCapacity: editedCapacity.isEmpty ? analysis.estimatedCapacity : editedCapacity,
                                shape: editedShape.isEmpty ? analysis.shape : editedShape,
                                closure: editedClosure.isEmpty ? analysis.closure : editedClosure,
                                material: analysis.material,
                                confidence: analysis.confidence
                            )
                            isEditing = false
                        }) {
                            Text("Save Changes ✓")
                        }
                        .buttonStyle(PrimaryCTA())
                        
                        Button(action: { isEditing = false }) {
                            Text("Cancel")
                        }
                        .buttonStyle(OutlineCTA())
                    } else {
                        Button(action: {
                            router.navigate(to: .requirementsForm)
                        }) {
                            Text("That's right ✓")
                        }
                        .buttonStyle(PrimaryCTA())
                        
                        Button(action: {
                            // Seed edit fields
                            editedCategory = analysis.category
                            editedCapacity = analysis.estimatedCapacity
                            editedClosure = analysis.closure
                            editedShape = analysis.shape
                            isEditing = true
                        }) {
                            Text("Edit Details")
                        }
                        .buttonStyle(OutlineCTA())
                        
                        Button(action: {
                            router.goBack()
                        }) {
                            HStack {
                                Image(systemName: "arrow.backward")
                                Text("Scan a different product")
                            }
                            .font(AppTheme.Typography.subheadline)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                        }
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.base)
                .padding(.top, AppTheme.Spacing.lg)
                
                Spacer(minLength: 40)
            }
        }
        .background(AppTheme.Colors.backgroundSecondary.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { router.goBack() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(AppTheme.Colors.primary)
                }
            }
        }
    }
}

struct TagPill: View {
    let text: String
    var color: Color = AppTheme.Colors.primary
    
    var body: some View {
        Text(text)
            .font(AppTheme.Typography.subheadline)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(color.opacity(0.1))
            .foregroundColor(color)
            .cornerRadius(AppTheme.CornerRadius.pill)
    }
}
