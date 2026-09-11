import SwiftUI

struct WelcomeView: View {
    @Environment(AppRouter.self) private var router
    @State private var isVisible = false
    
    var body: some View {
        ZStack {
            AppTheme.Gradients.splash
                .ignoresSafeArea()
            
            VStack(spacing: AppTheme.Spacing.xxl) {
                Spacer()
                
                VStack(spacing: AppTheme.Spacing.sm) {
                    Text("Scan2Source")
                        .font(AppTheme.Typography.largeTitle)
                        .foregroundColor(.white)
                    
                    Text("See it. Match it. Source it.")
                        .font(AppTheme.Typography.tagline)
                        .foregroundColor(.white.opacity(0.8))
                }
                .offset(y: isVisible ? 0 : 50)
                .opacity(isVisible ? 1 : 0)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                    FeatureRow(icon: "camera.viewfinder", text: "Scan any packaging")
                    FeatureRow(icon: "brain", text: "AI understands it for you")
                    FeatureRow(icon: "shippingbox.and.arrow.backward", text: "Find the right supplier")
                }
                .padding(.horizontal, AppTheme.Spacing.xl)
                .offset(y: isVisible ? 0 : 50)
                .opacity(isVisible ? 1 : 0)
                
                Spacer()
                
                VStack(spacing: AppTheme.Spacing.base) {
                    Button(action: {
                        router.goHome()
                    }) {
                        Text("Get Started")
                            .font(AppTheme.Typography.headline)
                            .foregroundColor(AppTheme.Colors.primaryDark)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, AppTheme.Spacing.base)
                            .background(Color.white.opacity(0.95))
                            .cornerRadius(AppTheme.CornerRadius.large)
                    }
                    .padding(.horizontal, AppTheme.Spacing.xl)
                    
                    Button(action: {
                        router.navigate(to: .signIn)
                    }) {
                        Text("Already have an account? Sign In")
                            .font(AppTheme.Typography.subheadline)
                            .foregroundColor(.white)
                            .underline()
                    }
                }
                .offset(y: isVisible ? 0 : 50)
                .opacity(isVisible ? 1 : 0)
                
                Spacer().frame(height: AppTheme.Spacing.xl)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                isVisible = true
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .frame(width: 32)
            
            Text(text)
                .font(AppTheme.Typography.title3)
                .foregroundColor(.white)
            
            Spacer()
        }
    }
}
