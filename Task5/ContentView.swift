import SwiftUI

struct ContentView: View {
    
    @State private var location: CGPoint = CGPoint(x: 200, y: 200)
    private let squareWidth: CGFloat = 100
    private let squareHeight: CGFloat = 100
    
    var simpleDrag: some Gesture {
        DragGesture()
            .onChanged { value in
                self.location = value.location
            }
    }
    
    var body: some View { GeometryReader { proxy in
        
        let height = proxy.size.height
        let (topColor, bottomColor, topRatio) = colorForPosition(location, in: proxy.size)
        let topHeight = squareHeight * topRatio
        let bottomHeight = squareHeight - topHeight
        
        ZStack {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: height / 4)
                Rectangle()
                    .fill(.pink)
                    .frame(maxWidth: .infinity)
                    .frame(height: height / 4)
                Rectangle()
                    .fill(.yellow)
                    .frame(maxWidth: .infinity)
                    .frame(height: height / 4)
                Rectangle()
                    .fill(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: height / 4)
            }
            VStack(spacing: 0) {
                Rectangle()
                    .fill(topColor)
                    .frame(width: squareWidth, height: topHeight)
                Rectangle()
                    .fill(bottomColor)
                    .frame(width: squareWidth, height: bottomHeight)
            }
            .cornerRadius(10)
            .position(location)
            .gesture(simpleDrag)
        }
    }
    .ignoresSafeArea()
    }
    
    private func colorForPosition(_ position: CGPoint, in size: CGSize) -> (Color, Color, CGFloat) {
        let segmentHeight = size.height / 4
        let topY = position.y - squareHeight / 2
        let bottomY = position.y + squareHeight / 2
        let colors: [Color] = [.white, .pink, .yellow, .black]
        
        var topSegment = Int(topY / segmentHeight)
        var bottomSegment = Int(bottomY / segmentHeight)
        topSegment = min(max(topSegment, 0), colors.count - 1)
        bottomSegment = min(max(bottomSegment, 0), colors.count - 1)
        
        if topSegment == bottomSegment {
            let color = colors[topSegment]
            return (color.rectColor, color.rectColor, 1)
        } else {
            let topOverlap = min(segmentHeight * CGFloat(topSegment + 1), bottomY) - topY
            
            let topColor = colors[topSegment].rectColor
            let bottomColor = colors[bottomSegment].rectColor
            let topRatio = topOverlap / squareHeight
            
            return (topColor, bottomColor, topRatio)
        }
    }
}

extension Color {
    var isDark: Bool {
        self == .black || self == .pink
    }
    
    var rectColor: Color {
        self.isDark ? .white : .black
    }
}

#Preview {
    ContentView()
}
