import SwiftUI

struct ProfileView: View {
    @Environment(AppRouter.self) private var router
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.xl) {
                // Header
                VStack(spacing: AppTheme.Spacing.sm) {
                    Circle()
                        .fill(AppTheme.Gradients.primary)
                        .frame(width: 80, height: 80)
                        .overlay(
                            Text("A")
                                .font(.largeTitle.bold())
                                .foregroundColor(.white)
                        )
                        .shadow(radius: 5)
                    
                    Text("Adithya Anand")
                        .font(AppTheme.Typography.title2)
                    
                    Text("adithya@example.com")
                        .font(AppTheme.Typography.subheadline)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
                .padding(.top, AppTheme.Spacing.xl)
                
                // Menu List
                VStack(spacing: 0) {
                    ProfileMenuRow(icon: "envelope.fill", title: "My Enquiries", color: .blue) {
                        router.navigate(to: .myEnquiries)
                    }
                    Divider().padding(.leading, 50)
                    
                    ProfileMenuRow(icon: "heart.fill", title: "Saved Products", color: .red) {}
                    Divider().padding(.leading, 50)
                    
                    ProfileMenuRow(icon: "gearshape.fill", title: "Settings", color: .gray) {}
                    Divider().padding(.leading, 50)
                    
                    ProfileMenuRow(icon: "questionmark.circle.fill", title: "Help & Support", color: .orange) {}
                    Divider().padding(.leading, 50)
                    
                    ProfileMenuRow(icon: "info.circle.fill", title: "About Scan2Source", color: AppTheme.Colors.primary) {}
                }
                .background(AppTheme.Colors.surface)
                .cornerRadius(AppTheme.CornerRadius.large)
                .padding(.horizontal)
                
                // Footer
                VStack(spacing: 8) {
                    Button("Sign Out") {
                        // Sign out logic
                        router.navigate(to: .signIn)
                    }
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(AppTheme.Colors.error)
                    .padding()
                    
                    Text("Scan2Source v1.0")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.textTertiary)
                    
                    Text("Sustainable Packaging Made Simple")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.textTertiary)
                }
                .padding(.bottom, AppTheme.Spacing.xl)
            }
        }
        .background(AppTheme.Colors.backgroundSecondary.ignoresSafeArea())
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProfileMenuRow: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.md) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                    .frame(width: 30)
                
                Text(title)
                    .font(AppTheme.Typography.bodyMedium)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(AppTheme.Colors.textTertiary)
            }
            .padding()
        }
    }
}
