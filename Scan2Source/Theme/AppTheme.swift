import SwiftUI

// MARK: - Scan2Source Design System

struct AppTheme {
    
    // MARK: - Colors
    struct Colors {
        // Primary
        static let primary = Color(hex: "#10B981")         // Green
        static let primaryDark = Color(hex: "#059669")
        static let primaryLight = Color(hex: "#D1FAE5")
        static let primarySubtle = Color(hex: "#ECFDF5")
        
        // Teal Accent
        static let accent = Color(hex: "#0D9488")
        static let accentDark = Color(hex: "#0F766E")
        static let accentLight = Color(hex: "#CCFBF1")
        
        // Text
        static let textPrimary = Color(hex: "#111827")
        static let textSecondary = Color(hex: "#4B5563")
        static let textTertiary = Color(hex: "#9CA3AF")
        static let textInverse = Color.white
        
        // Background
        static let background = Color(hex: "#FFFFFF")
        static let backgroundSecondary = Color(hex: "#F9FAFB")
        static let backgroundTertiary = Color(hex: "#F3F4F6")
        
        // Surface (cards, sheets)
        static let surface = Color.white
        static let surfaceBorder = Color(hex: "#E5E7EB")
        
        // Semantic
        static let success = Color(hex: "#10B981")
        static let warning = Color(hex: "#F59E0B")
        static let error = Color(hex: "#EF4444")
        static let info = Color(hex: "#3B82F6")
        
        // Match score gradients
        static let matchHigh = Color(hex: "#10B981")       // 80%+
        static let matchMedium = Color(hex: "#F59E0B")     // 50-80%
        static let matchLow = Color(hex: "#EF4444")        // <50%
        
        // Verification badge colors
        static let verified = Color(hex: "#10B981")
        static let gstVerified = Color(hex: "#3B82F6")
        static let udyamVerified = Color(hex: "#8B5CF6")
        
        // Rating
        static let star = Color(hex: "#F59E0B")
        
        static func matchColor(for score: Double) -> Color {
            if score >= 0.8 { return matchHigh }
            else if score >= 0.5 { return matchMedium }
            else { return matchLow }
        }
    }
    
    // MARK: - Typography
    struct Typography {
        static let largeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
        static let title1 = Font.system(size: 28, weight: .bold, design: .rounded)
        static let title2 = Font.system(size: 22, weight: .semibold, design: .rounded)
        static let title3 = Font.system(size: 20, weight: .semibold, design: .rounded)
        static let headline = Font.system(size: 17, weight: .semibold, design: .default)
        static let body = Font.system(size: 17, weight: .regular, design: .default)
        static let bodyMedium = Font.system(size: 17, weight: .medium, design: .default)
        static let callout = Font.system(size: 16, weight: .regular, design: .default)
        static let subheadline = Font.system(size: 15, weight: .regular, design: .default)
        static let footnote = Font.system(size: 13, weight: .regular, design: .default)
        static let caption = Font.system(size: 12, weight: .regular, design: .default)
        static let captionBold = Font.system(size: 12, weight: .semibold, design: .default)
        
        // Special
        static let tagline = Font.system(size: 18, weight: .medium, design: .rounded)
        static let matchScore = Font.system(size: 36, weight: .bold, design: .rounded)
        static let price = Font.system(size: 20, weight: .bold, design: .rounded)
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let base: CGFloat = 16
        static let lg: CGFloat = 20
        static let xl: CGFloat = 24
        static let xxl: CGFloat = 32
        static let xxxl: CGFloat = 48
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let xl: CGFloat = 20
        static let pill: CGFloat = 100
    }
    
    // MARK: - Shadows
    struct Shadows {
        static func card() -> some View {
            Color.clear
                .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
                .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
        }
    }
    
    // MARK: - Gradients
    struct Gradients {
        static let primary = LinearGradient(
            colors: [Colors.primary, Colors.accent],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let primarySoft = LinearGradient(
            colors: [Colors.primaryLight, Colors.accentLight],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let splash = LinearGradient(
            colors: [Color(hex: "#065F46"), Color(hex: "#0F766E"), Color(hex: "#10B981")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let loading = LinearGradient(
            colors: [Colors.primary.opacity(0.1), Colors.primary.opacity(0.3), Colors.primary.opacity(0.1)],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

// MARK: - Color Extension (Hex Support)

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Button Styles

struct PrimaryCTA: ButtonStyle {
    var isFullWidth: Bool = true
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTheme.Typography.headline)
            .foregroundColor(.white)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .padding(.horizontal, AppTheme.Spacing.xl)
            .padding(.vertical, AppTheme.Spacing.base)
            .background(AppTheme.Gradients.primary)
            .cornerRadius(AppTheme.CornerRadius.large)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct SecondaryCTA: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTheme.Typography.headline)
            .foregroundColor(AppTheme.Colors.primary)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, AppTheme.Spacing.xl)
            .padding(.vertical, AppTheme.Spacing.base)
            .background(AppTheme.Colors.primarySubtle)
            .cornerRadius(AppTheme.CornerRadius.large)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                    .stroke(AppTheme.Colors.primary.opacity(0.3), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct OutlineCTA: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTheme.Typography.headline)
            .foregroundColor(AppTheme.Colors.textPrimary)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, AppTheme.Spacing.xl)
            .padding(.vertical, AppTheme.Spacing.base)
            .background(Color.clear)
            .cornerRadius(AppTheme.CornerRadius.large)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                    .stroke(AppTheme.Colors.surfaceBorder, lineWidth: 1.5)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - View Modifiers

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(AppTheme.Colors.surface)
            .cornerRadius(AppTheme.CornerRadius.large)
            .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
            .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

struct GlassStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .cornerRadius(AppTheme.CornerRadius.large)
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
    
    func glassStyle() -> some View {
        modifier(GlassStyle())
    }
}

// MARK: - Shimmer Effect

struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.0),
                        Color.white.opacity(0.3),
                        Color.white.opacity(0.0)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .offset(x: phase)
                .mask(content)
            )
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 300
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}
