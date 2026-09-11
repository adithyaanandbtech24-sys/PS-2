import SwiftUI
import PhotosUI

struct ScanProductView: View {
    @Environment(AppRouter.self) private var router
    @Environment(DataManager.self) private var dataManager
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var showingCamera = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.xl) {
                // Header
                VStack(spacing: AppTheme.Spacing.sm) {
                    Text("Show us the packaging")
                        .font(AppTheme.Typography.title1)
                        .foregroundColor(AppTheme.Colors.textPrimary)
                    Text("you want.")
                        .font(AppTheme.Typography.title1)
                        .foregroundColor(AppTheme.Colors.primary)
                    Text("We'll find the perfect suppliers for you.")
                        .font(AppTheme.Typography.subheadline)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.top, AppTheme.Spacing.xl)
                
                // Upload Options
                HStack(spacing: AppTheme.Spacing.md) {
                    // Camera option
                    Button(action: {
                        showingCamera = true
                    }) {
                        VStack(spacing: AppTheme.Spacing.md) {
                            ZStack {
                                Circle()
                                    .fill(AppTheme.Colors.primary.opacity(0.1))
                                    .frame(width: 70, height: 70)
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(AppTheme.Colors.primary)
                            }
                            Text("Take Photo")
                                .font(AppTheme.Typography.headline)
                                .foregroundColor(AppTheme.Colors.textPrimary)
                            Text("Use your camera")
                                .font(AppTheme.Typography.caption)
                                .foregroundColor(AppTheme.Colors.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.xl)
                        .background(Color.white)
                        .cornerRadius(AppTheme.CornerRadius.large)
                        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
                    }
                    
                    // Photo Library option
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        VStack(spacing: AppTheme.Spacing.md) {
                            ZStack {
                                Circle()
                                    .fill(AppTheme.Colors.accent.opacity(0.1))
                                    .frame(width: 70, height: 70)
                                Image(systemName: "photo.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(AppTheme.Colors.accent)
                            }
                            Text("Upload Image")
                                .font(AppTheme.Typography.headline)
                                .foregroundColor(AppTheme.Colors.textPrimary)
                            Text("From your library")
                                .font(AppTheme.Typography.caption)
                                .foregroundColor(AppTheme.Colors.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.xl)
                        .background(Color.white)
                        .cornerRadius(AppTheme.CornerRadius.large)
                        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.base)
                
                // Divider
                HStack {
                    Rectangle().fill(AppTheme.Colors.surfaceBorder).frame(height: 1)
                    Text("or try a sample").font(AppTheme.Typography.caption).foregroundColor(AppTheme.Colors.textTertiary)
                    Rectangle().fill(AppTheme.Colors.surfaceBorder).frame(height: 1)
                }
                .padding(.horizontal, AppTheme.Spacing.base)
                
                // Sample images
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    Text("Sample Packaging")
                        .font(AppTheme.Typography.headline)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                        .padding(.horizontal, AppTheme.Spacing.base)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: AppTheme.Spacing.md) {
                        SampleImageCard(icon: "waterbottle.fill", color: AppTheme.Colors.primary, label: "Bottle") {
                            dataManager.selectedCategory = .cosmeticBottle
                            router.navigate(to: .aiAnalysis)
                        }
                        SampleImageCard(icon: "cylinder.fill", color: AppTheme.Colors.warning, label: "Jar") {
                            dataManager.selectedCategory = .jar
                            router.navigate(to: .aiAnalysis)
                        }
                        SampleImageCard(icon: "bag.fill", color: Color(hex: "#EC4899"), label: "Pouch") {
                            dataManager.selectedCategory = .pouch
                            router.navigate(to: .aiAnalysis)
                        }
                        SampleImageCard(icon: "shippingbox.fill", color: AppTheme.Colors.error, label: "Box") {
                            dataManager.selectedCategory = .box
                            router.navigate(to: .aiAnalysis)
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.base)
                }
                
                Spacer(minLength: AppTheme.Spacing.xxl)
            }
        }
        .background(AppTheme.Colors.backgroundSecondary.ignoresSafeArea())
        .navigationTitle("Scan Product")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: selectedItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    await MainActor.run {
                        dataManager.selectedImage = image
                        router.navigate(to: .aiAnalysis)
                    }
                }
            }
        }
    }
}

struct SampleImageCard: View {
    let icon: String
    let color: Color
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AppTheme.Spacing.sm) {
                ZStack {
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                        .fill(color.opacity(0.12))
                        .aspectRatio(1, contentMode: .fit)
                    Image(systemName: icon)
                        .font(.system(size: 30))
                        .foregroundColor(color)
                }
                Text(label)
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
        }
    }
}
