//
//  ProfileStatisticsGraphView.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/15/21.
//

import SwiftUI

struct ProfileStatisticsGraphView: View {
    let dataPoints: [CGFloat]
    let colors: [Color]
    
    var body: some View {
        ZStack {
            VerticalDividerPath(dataPoints: dataPoints)
                .trim(to: 1)
                .stroke(Color(Assets.divider.color), style: StrokeStyle(lineWidth: 2, dash: [10]))
                .frame(height: 200)
            HorizontalDividerPath(dataPoints: dataPoints)
                .trim(to: 1)
                .stroke(Color(Assets.divider.color), style: StrokeStyle(lineWidth: 2, dash: [10]))
                .frame(height: 200)
            LineGraph(dataPoints: dataPoints)
                .trim(to: 1)
                .stroke(LinearGradient(gradient: .init(colors: colors), startPoint: .trailing, endPoint: .leading), lineWidth: 3)
                .frame(height: 200)
            PointsPath(dataPoints: dataPoints)
                .trim(to: 1)
                .fill(LinearGradient(gradient: .init(colors: colors), startPoint: .trailing, endPoint: .leading))
                .frame(height: 200)
        }
        .frame(height: 200)
    }
}

struct LineGraph: Shape {
    var dataPoints: [CGFloat]
    
    func path(in rect: CGRect) -> Path {
        
        func point(at ix: Int) -> CGPoint {
            let point = dataPoints[ix]
            let x = rect.width * CGFloat(ix) / CGFloat(dataPoints.count - 1)
            let y = (1-point) * rect.height
            return CGPoint(x: x, y: y)
        }
        
        return Path { p in
            guard dataPoints.count > 0 else { return }
            let start = dataPoints[0]
            p.move(to: CGPoint(x: 0, y: (1-start) * rect.height))
            for idx in dataPoints.indices {
                p.addLine(to: point(at: idx))
            }
        }
    }
}

struct HorizontalDividerPath: Shape {
    var dataPoints: [CGFloat]
    
    func path(in rect: CGRect) -> Path {
        
        return Path { p in
            guard dataPoints.count > 1 else { return }
            var newPoints = dataPoints
            if newPoints.last != 0 {
                newPoints.append(0)
            }
            for point in newPoints {
                p.move(to: .init(x: 0, y: (1-point) * rect.height))
                p.addLine(to: .init(x: rect.width, y: (1-point) * rect.height))
            }
        }
    }
}

struct VerticalDividerPath: Shape {
    var dataPoints: [CGFloat]
    
    func path(in rect: CGRect) -> Path {
        
        return Path { p in
            guard dataPoints.count > 1 else { return }
            p.move(to: CGPoint(x: 0, y: 0))
            for point in dataPoints.indices {
                p.addLine(to: .init(x: rect.width * CGFloat(point) / CGFloat(dataPoints.count - 1), y: rect.height))
                p.move(to: .init(x: (rect.width * CGFloat(point + 1) / CGFloat(dataPoints.count - 1)), y: 0))
            }
        }
    }
}

struct PointsPath: Shape {
    var dataPoints: [CGFloat]
    
    func path(in rect: CGRect) -> Path {
        
        func point(at ix: Int) -> CGPoint {
            let point = dataPoints[ix]
            let x = rect.width * CGFloat(ix) / CGFloat(dataPoints.count - 1)
            let y = (1-point) * rect.height
            return CGPoint(x: x, y: y)
        }
        
        return Path { p in
            guard dataPoints.count > 1 else { return }
            for index in dataPoints.indices {
                let center = point(at: index)
                p.move(to: center)
                p.addEllipse(in: .init(origin: .init(x: center.x - 4, y: center.y - 4), size: .init(width: 8, height: 8)))
            }
        }
    }
}
