//
//  MovingNumbersView+Components.swift
//  MovingNumberView
//
//  Created by Wirawit Rueopas on 4/12/20.
//  Copyright © 2020 Wirawit Rueopas. All rights reserved.
//

import SwiftUI

extension MovingNumbersView {
    enum VisualElementType: CustomDebugStringConvertible, Identifiable {
        case digit(Int, position: Int)
        case comma(position: Int)
        case dot
        case decimalDigit(Int, position: Int)
        case minus
        
        var id: Int {
            // - Digit has id as a multiple of 10s,
            // - Decimal place has a negative multiple of 10s
            // - 0 is reserved for dot.
            // - 1 is reserved for minus
            // - comma is the id of previous digit + 5.
            //
            // I.e. -1,234.56 -> [1(minus), 40, 35, 30, 20, 10, 0(dot), -10, -20]
            switch self {
            case let .digit(_, position):
                assert(position > 0)
                return 10 * position
            case let .comma(position):
                assert(position > 0)
                // Give comma the id between two digits.
                return 10 * position + 5
            case let .decimalDigit(_, position):
                assert(position > 0)
                return -10 * position
            case .dot:
                // Reserve 0 for dot
                return 0
            case .minus:
                // Reserve of "-"
                return 1
            }
        }
        var debugDescription: String {
            switch self {
            case .dot: return "."
            case let .comma(p): return ",(pos:\(p))"
            case let .digit(val, p): return "\(val)(pos:\(p))"
            case let .decimalDigit(val, p): return "\(val)(pos:\(p))"
            case .minus: return "-"
            }
        }
    }
    
    func viewFromElement(_ element: VisualElementType) -> some View {
        switch element {
        case let .digit(value, _):
            return AnyView(self.buildDigitStack(showingDigit: value))
        case let .decimalDigit(value, _):
            return AnyView(self.buildDigitStack(showingDigit: value))
        case .dot:
            return AnyView(self.buildDot())
        case .comma:
            return AnyView(self.buildComma())
        case .minus:
            return AnyView(self.buildMinus())
        }
    }
    
    func buildDigitStack(showingDigit digit: Int) -> some View {
        let digit = CGFloat(digit)
        let ds = TenDigitStack(
            spacing: verticalDigitSpacing,
            elementBuilder: elementBuilder)
            .modifier(VerticalShift(
                diffNumber: digit,
                digitSpacing: verticalDigitSpacing))
        return ds
    }
    
    func buildComma() -> some View {
        elementBuilder(",")
    }
    
    func buildDot() -> some View {
        elementBuilder(".")
    }
    
    func buildMinus() -> some View {
        elementBuilder("-")
    }
    
    /// A vertical stack of 9 -> 0.
    struct TenDigitStack: View {
        var spacing: CGFloat? = nil
        let elementBuilder: (String) -> Text
        var body: some View {
            VStack(alignment: .leading, spacing: spacing) {
                ForEach((0...9).reversed(), id: \.self) { iDigit in
                    self.elementBuilder("\(iDigit)")
                }
            }
            .padding(.bottom, spacing)
            // Padding so the bottom most digit (0)
            // has the padding like others.
        }
    }
    
    struct VerticalShift: GeometryEffect {
        var diffNumber: CGFloat
        let digitSpacing: CGFloat
        
        var animatableData: CGFloat {
            get { diffNumber }
            set { diffNumber = newValue }
        }
        
        func effectValue(size: CGSize) -> ProjectionTransform {
            // The 0.5 is to center right at a single number.
            // i.e. for 10 digits the center is between some two numbers.
            let translationY = -size.height/2 + (size.height / 10) * (diffNumber + 0.5) + digitSpacing/2
            return .init(.init(
                translationX: 0,
                y: translationY
            ))
        }
    }
}

func round(_ number: Double, numPlaces: Int) -> Double {
    let power = pow(10.0, Double(numPlaces))
    return round(number * power)/power
}
