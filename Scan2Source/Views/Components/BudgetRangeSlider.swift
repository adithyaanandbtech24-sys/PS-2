import SwiftUI

struct BudgetRangeSlider: View {
    @Binding var minPrice: Double
    @Binding var maxPrice: Double
    let bounds: ClosedRange<Double>
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            HStack {
                Text("₹\(Int(minPrice))")
                    .font(AppTheme.Typography.bodyMedium)
                Spacer()
                Text("₹\(Int(maxPrice))")
                    .font(AppTheme.Typography.bodyMedium)
            }
            .foregroundColor(AppTheme.Colors.textPrimary)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(AppTheme.Colors.surfaceBorder)
                        .frame(height: 4)
                        .cornerRadius(2)
                    
                    let minOffset = CGFloat((minPrice - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)) * geometry.size.width
                    let maxOffset = CGFloat((maxPrice - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)) * geometry.size.width
                    
                    Rectangle()
                        .fill(AppTheme.Colors.primary)
                        .frame(width: maxOffset - minOffset, height: 4)
                        .offset(x: minOffset)
                        .cornerRadius(2)
                    
                    Circle()
                        .fill(Color.white)
                        .shadow(radius: 2)
                        .frame(width: 24, height: 24)
                        .offset(x: minOffset - 12)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let percentage = (value.location.x / geometry.size.width)
                                    let rawValue = bounds.lowerBound + Double(percentage) * (bounds.upperBound - bounds.lowerBound)
                                    minPrice = min(max(bounds.lowerBound, rawValue), maxPrice - 1)
                                }
                        )
                    
                    Circle()
                        .fill(Color.white)
                        .shadow(radius: 2)
                        .frame(width: 24, height: 24)
                        .offset(x: maxOffset - 12)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let percentage = (value.location.x / geometry.size.width)
                                    let rawValue = bounds.lowerBound + Double(percentage) * (bounds.upperBound - bounds.lowerBound)
                                    maxPrice = max(min(bounds.upperBound, rawValue), minPrice + 1)
                                }
                        )
                }
            }
            .frame(height: 24)
        }
    }
}
