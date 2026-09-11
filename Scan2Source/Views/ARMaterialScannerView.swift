import SwiftUI

struct ARMaterialScannerView: View {
    @Environment(AppRouter.self) private var router
    @Environment(DataManager.self) private var dataManager
    
    @State private var isScanning = true
    @State private var scanProgress: Double = 0.0
    @State private var detectedMaterial: String = "Analyzing Surface Density..."
    @State private var polymerCode: String = "Detecting..."
    @State private var confidenceScore: Int = 0
    @State private var scanTargetFound = false
    @State private var pulseAnimation = false
    
    var body: some View {
        ZStack {
            // Simulated AR Dark Viewport
            Color.black.ignoresSafeArea()
            
            // Grid Lines Simulation
            GeometryReader { geo in
                Path { path in
                    let w = geo.size.width
                    let h = geo.size.height
                    let step: CGFloat = 40
                    
                    for x in stride(from: 0, to: w, by: step) {
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: h))
                    }
                    for y in stride(from: 0, to: h, by: step) {
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: w, y: y))
                    }
                }
                .stroke(Color.green.opacity(0.15), lineWidth: 1)
            }
            
            // AR Center Reticle Target
            VStack {
                Spacer()
                
                ZStack {
                    // Outer pulsing ring
                    Circle()
                        .stroke(AppTheme.Colors.primary.opacity(pulseAnimation ? 0.8 : 0.2), lineWidth: 3)
                        .frame(width: 260, height: 260)
                        .scaleEffect(pulseAnimation ? 1.08 : 0.95)
                        .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: pulseAnimation)
                    
                    // Scanning square reticle
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.8), style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [20, 10]))
                        .frame(width: 220, height: 220)
                    
                    // Detected Node Markers
                    if scanTargetFound {
                        VStack(spacing: 8) {
                            HStack {
                                Image(systemName: "smallcircle.filled.circle")
                                    .foregroundColor(.green)
                                Text("Polymer Mesh Detected")
                                    .font(.caption2.bold())
                                    .foregroundColor(.green)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(12)
                            
                            Text("rPET / High Recyclability Grade")
                                .font(.caption.bold())
                                .foregroundColor(.white)
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                }
                
                Spacer()
            }
            
            // HUD Overlay Info Top
            VStack {
                HStack {
                    Button(action: { router.goBack() }) {
                        Image(systemName: "chevron.left")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 6) {
                        Circle()
                            .fill(scanTargetFound ? Color.green : Color.yellow)
                            .frame(width: 10, height: 10)
                        Text(scanTargetFound ? "SURFACE LOCKED" : "SCANNING AR SURFACE")
                            .font(.caption.bold())
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(20)
                }
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.top, AppTheme.Spacing.md)
                
                Spacer()
                
                // Bottom Real-time Data Card
                VStack(spacing: AppTheme.Spacing.md) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("DETECTED MATERIAL")
                                .font(.caption2.bold())
                                .foregroundColor(Color.white.opacity(0.7))
                            Text(detectedMaterial)
                                .font(AppTheme.Typography.title2)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("SPI CODE")
                                .font(.caption2.bold())
                                .foregroundColor(Color.white.opacity(0.7))
                            Text(polymerCode)
                                .font(AppTheme.Typography.title2)
                                .foregroundColor(AppTheme.Colors.primary)
                        }
                    }
                    
                    // Live Confidence Bar
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("AI Material Scan Confidence")
                                .font(.caption)
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(confidenceScore)%")
                                .font(.caption.bold())
                                .foregroundColor(AppTheme.Colors.primary)
                        }
                        
                        GeometryReader { g in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.white.opacity(0.2))
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(AppTheme.Gradients.primary)
                                    .frame(width: g.size.width * CGFloat(confidenceScore) / 100.0)
                            }
                        }
                        .frame(height: 6)
                    }
                    
                    if scanTargetFound {
                        Button(action: {
                            if let firstProd = dataManager.products.first {
                                router.navigate(to: .carbonFootprint(productId: firstProd.id))
                            } else {
                                router.goBack()
                            }
                        }) {
                            HStack {
                                Image(systemName: "leaf.fill")
                                Text("View Carbon Footprint & ESG Score")
                                    .font(AppTheme.Typography.headline)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(AppTheme.Gradients.primary)
                            .foregroundColor(.white)
                            .cornerRadius(14)
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .padding(AppTheme.Spacing.lg)
                .background(Color.black.opacity(0.85))
                .cornerRadius(24)
                .padding(AppTheme.Spacing.md)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            pulseAnimation = true
            simulateARScan()
        }
    }
    
    private func simulateARScan() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation {
                detectedMaterial = "rPET (Post-Consumer)"
                polymerCode = "♻️ #1 PETE"
                confidenceScore = 65
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            withAnimation {
                confidenceScore = 96
                scanTargetFound = true
            }
        }
    }
}
