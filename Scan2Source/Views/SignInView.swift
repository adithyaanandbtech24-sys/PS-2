import SwiftUI

struct SignInView: View {
    @Environment(AppRouter.self) private var router
    @Environment(DataManager.self) private var dataManager
    
    @State private var isSignUp = false
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.xl) {
            Spacer()
            
            // Logo area
            VStack(spacing: AppTheme.Spacing.md) {
                Image(systemName: "leaf.fill")
                    .font(.system(size: 60))
                    .foregroundColor(AppTheme.Colors.primary)
                
                Text(isSignUp ? "Create Account" : "Welcome Back")
                    .font(AppTheme.Typography.largeTitle)
                
                Text("Scan2Source - Sustainable Sourcing")
                    .font(AppTheme.Typography.subheadline)
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
            
            // Form
            VStack(spacing: AppTheme.Spacing.base) {
                if isSignUp {
                    CustomTextField(icon: "person.fill", placeholder: "Full Name", text: $name)
                }
                
                CustomTextField(icon: "envelope.fill", placeholder: "Email Address", text: $email)
                CustomSecureField(icon: "lock.fill", placeholder: "Password", text: $password)
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
            
            // Actions
            VStack(spacing: AppTheme.Spacing.md) {
                Button(isSignUp ? "Create Account" : "Sign In") {
                    router.goHome()
                }
                .buttonStyle(PrimaryCTA())
                .padding(.horizontal, AppTheme.Spacing.xl)
                
                Button(action: {
                    withAnimation {
                        isSignUp.toggle()
                    }
                }) {
                    Text(isSignUp ? "Already have an account? Sign In" : "Don't have an account? Create one")
                        .font(AppTheme.Typography.subheadline)
                        .foregroundColor(AppTheme.Colors.primary)
                }
                
                Button("Skip for now") {
                    router.goHome()
                }
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.Colors.textTertiary)
                .padding(.top, AppTheme.Spacing.xl)
            }
            
            Spacer()
        }
        .background(AppTheme.Colors.background.ignoresSafeArea())
    }
}

struct CustomTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: icon)
                .foregroundColor(AppTheme.Colors.textTertiary)
                .frame(width: 20)
            
            TextField(placeholder, text: $text)
                .font(AppTheme.Typography.body)
        }
        .padding()
        .background(AppTheme.Colors.backgroundSecondary)
        .cornerRadius(AppTheme.CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                .stroke(AppTheme.Colors.surfaceBorder, lineWidth: 1)
        )
    }
}

struct CustomSecureField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: icon)
                .foregroundColor(AppTheme.Colors.textTertiary)
                .frame(width: 20)
            
            SecureField(placeholder, text: $text)
                .font(AppTheme.Typography.body)
        }
        .padding()
        .background(AppTheme.Colors.backgroundSecondary)
        .cornerRadius(AppTheme.CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                .stroke(AppTheme.Colors.surfaceBorder, lineWidth: 1)
        )
    }
}
