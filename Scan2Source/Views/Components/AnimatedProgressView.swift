import SwiftUI

struct AnimatedProgressView: View {
    let steps: [String]
    @State private var currentStep: Int = 0
    let onComplete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                HStack(spacing: AppTheme.Spacing.md) {
                    ZStack {
                        Circle()
                            .fill(index < currentStep ? AppTheme.Colors.success : AppTheme.Colors.surfaceBorder)
                            .frame(width: 24, height: 24)
                        
                        if index < currentStep {
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        } else {
                            Circle()
                                .stroke(AppTheme.Colors.surfaceBorder, lineWidth: 2)
                                .frame(width: 24, height: 24)
                        }
                    }
                    
                    Text(step)
                        .font(AppTheme.Typography.bodyMedium)
                        .foregroundColor(index <= currentStep ? AppTheme.Colors.textPrimary : AppTheme.Colors.textTertiary)
                        .opacity(index <= currentStep ? 1 : 0.5)
                }
                .animation(.spring(), value: currentStep)
            }
        }
        .onAppear {
            startAnimation()
        }
    }
    
    private func startAnimation() {
        for index in 0...steps.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 1.0) {
                withAnimation {
                    currentStep = index
                }
                if index == steps.count {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        onComplete()
                    }
                }
            }
        }
    }
}
