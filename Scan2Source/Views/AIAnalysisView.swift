import SwiftUI

struct AIAnalysisView: View {
    @Environment(AppRouter.self) private var router
    @Environment(DataManager.self) private var dataManager
    
    @State private var isPulsing = false
    @State private var analysisComplete = false
    
    let steps = [
        "Understanding product...",
        "Checking shape...",
        "Estimating size...",
        "Finding similar packaging..."
    ]
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.xxl) {
            Spacer()
            
            // Pulsing image container
            ZStack {
                // Outer pulse ring
                Circle()
                    .fill(AppTheme.Colors.primary.opacity(0.08))
                    .frame(width: 240, height: 240)
                    .scaleEffect(isPulsing ? 1.3 : 0.8)
                    .opacity(isPulsing ? 0 : 0.8)
                
                // Middle ring
                Circle()
                    .fill(AppTheme.Colors.primary.opacity(0.15))
                    .frame(width: 200, height: 200)
                    .scaleEffect(isPulsing ? 1.15 : 0.9)
                
                // Image or placeholder
                if let image = dataManager.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 160, height: 160)
                        .clipShape(Circle())
                        .shadow(color: AppTheme.Colors.primary.opacity(0.3), radius: 20)
                } else {
                    // Category-based placeholder
                    Circle()
                        .fill(AppTheme.Gradients.primary)
                        .frame(width: 160, height: 160)
                        .overlay(
                            Image(systemName: dataManager.selectedCategory?.iconName ?? "sparkles")
                                .font(.system(size: 60))
                                .foregroundColor(.white)
                        )
                        .shadow(color: AppTheme.Colors.primary.opacity(0.4), radius: 20)
                }
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: false)) {
                    isPulsing = true
                }
            }
            
            // Title
            VStack(spacing: AppTheme.Spacing.sm) {
                Text("Analysing packaging...")
                    .font(AppTheme.Typography.title3)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                Text("Our AI is understanding your product")
                    .font(AppTheme.Typography.subheadline)
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
            
            // Animated steps
            AnimatedProgressView(steps: steps) {
                // All steps complete → navigate
                withAnimation {
                    analysisComplete = true
                }
                // Set a mock analysis result
                dataManager.currentAnalysis = ProductAnalysis(
                    category: dataManager.selectedCategory?.displayName ?? "Cosmetic Pump Bottle",
                    estimatedCapacity: "100 ml",
                    shape: "Cylindrical",
                    closure: "Pump",
                    material: "PET",
                    confidence: Double.random(in: 0.88...0.97)
                )
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    router.navigate(to: .productResult)
                }
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
            
            Spacer()
        }
        .background(AppTheme.Colors.backgroundSecondary.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { router.goBack() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(AppTheme.Colors.textTertiary)
                }
            }
        }
    }
}
