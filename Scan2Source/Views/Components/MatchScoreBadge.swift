import SwiftUI

struct MatchScoreBadge: View {
    let score: Double // 0 to 1
    
    var percentage: Int {
        Int(score * 100)
    }
    
    var color: Color {
        AppTheme.Colors.matchColor(for: score)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: 4)
            
            Circle()
                .trim(from: 0, to: CGFloat(score))
                .stroke(color, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))
            
            Text("\(percentage)%")
                .font(AppTheme.Typography.captionBold)
                .foregroundColor(color)
        }
        .frame(width: 44, height: 44)
    }
}
