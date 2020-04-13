//
//  MovingNumbersView.swift
//  MovingNumbersView
//
//  Created by Wirawit Rueopas on 4/12/20.
//  Copyright © 2020 Wirawit Rueopas. All rights reserved.
//

import SwiftUI

struct MovingNumbersView: View {
    /// The number to show.
    let number: Double
    
    /// Number of decimal places to show. If 0, will show integers (i.e. no dot or decimal)
    ///
    /// Note that we round up  before showing.
    let numberOfDecimalPlaces: Int
    
    /// Space between each digit in the 10-digit vertical stack
    var verticalDigitSpacing: CGFloat = 0
    
    var animationDuration: Double = 0.25
    
    /// Give a fixed width to the view. This would give better transition effect as digits are not clipped off.
    var fixedWidth: CGFloat? = nil
    
    /// Function to build digit, comma, and dot components
    let elementBuilder: (String) -> Text
    
    var digitStackAnimation: Animation {
        Animation
            .easeOut(duration: animationDuration)
    }
    
    var elementTransition: AnyTransition {
        AnyTransition.move(edge: .leading)
    }
    
    func getWholeVisualElements(whole: Int) -> [VisualElementType] {
        let wholeDigits = getAllDigitsInAscendingSignificance(number: whole)
        var wholeElements: [VisualElementType] = []
        
        for (i, digit) in wholeDigits.enumerated() {
            if i != 0 && i % 3 == 0 {
                wholeElements.append(.comma(position: i+1))
            }
            wholeElements.append(.digit(digit, position: i+1))
        }
        return wholeElements
    }
    
    func getFractionVisualElements(fraction: Double, numberOfDecimalPlaces: Int) -> [VisualElementType] {
        var fractionElements: [VisualElementType] = []
        let decimals = Int(round(fraction * pow(10.0, Double(numberOfDecimalPlaces))))
        // [5, 4]
        var fractionDigits = getAllDigitsInAscendingSignificance(number: decimals)
        // Prepend with 0s that're gone when fraction is 0.
        let numberOfAdditionalZeros = numberOfDecimalPlaces - fractionDigits.count
        if numberOfAdditionalZeros > 0 {
            fractionDigits = repeatElement(0, count: numberOfAdditionalZeros) + fractionDigits
        }
        
        // Work from least significant: [4, 5]
        for (i, digit) in fractionDigits.reversed().enumerated() {
            fractionElements.append(.decimalDigit(digit, position: i+1))
        }
        
        return fractionElements
    }
    
    func movingNumbersPlate() -> some View {
        let isNegative = self.number < 0
        
        // Deal with positive first
        let number = abs(self.number)
        
        // Rounding
        let roundedNumber = round(number, numPlaces: numberOfDecimalPlaces)
        
        // Split
        let (whole, fraction) = modf(roundedNumber)
        
        // Example: 123.45
        
        // Whole - 123
        let wholeElements = getWholeVisualElements(whole: Int(whole)) // [3,2,1]
        
        let negativeElement: [VisualElementType] = isNegative ? [.minus] : []
        let allElements: [VisualElementType]
        
        // Fraction
        if numberOfDecimalPlaces > 0 {
            // [4, 5]
            let fractionElements = getFractionVisualElements(fraction: fraction, numberOfDecimalPlaces: numberOfDecimalPlaces)
            allElements = negativeElement + wholeElements.reversed() + [.dot] + fractionElements
        } else {
            allElements = negativeElement + wholeElements.reversed()
        }
        
        // All elements are centered (digit stack, comma, dot)
        let finalResultView = HStack(alignment: .center, spacing: 0) {
            ForEach(allElements) { (element) in
                self.viewFromElement(element)
                    .transition(self.elementTransition)
                    .animation(self.digitStackAnimation)
            }
        }
        .frame(width: fixedWidth, alignment: .leading)
        
        //        print("All:", allElements)
        //        print("Ids:", allElements.map { $0.id })
        
        // PROBLEM: Final result view takes a big size
        // (i.e. 10-digit stack height, no. of digits width)
        // We want the final layout of the view to be just like
        // its appearance, i.e. A couple of Texts in HStack.
        
        // HACK: Make a stand-in estimated view for layout.
        // So this allows us to treat this view almost like Text
        //
        // TODO: Is there a better way to calculate layout correctly?
        // Would `PreferenceKey` works?
        let estimatedView = HStack(spacing: 0) {
            ForEach(allElements) { el -> Text in
                switch el {
                case .minus:
                    return self.elementBuilder("-")
                case .dot:
                    return self.elementBuilder(".")
                case .comma:
                    return self.elementBuilder(",")
                case .digit, .decimalDigit:
                    // This column takes the widest one.
                    // We estimate it to be 9.
                    return self.elementBuilder("9")
                }
            }
        }
        .frame(width: fixedWidth)
        
        return estimatedView
            .opacity(0)
            .overlay(
                finalResultView,
                alignment: .leading)
            .mask(Rectangle())
    }
    
    var body: some View {
        movingNumbersPlate()
    }
}

/// Given an **non-negative** integer, extract all digits starting *from least to most significant position*, i.e. 123 -> [3,2,1]
///
/// Note that if `number` is negative, we use `abs(number)`.
func getAllDigitsInAscendingSignificance(number: Int) -> [Int] {
    if number == 0 {
        return [0]
    }
    var rest = abs(number)
    var digits: [Int] = []
    while rest >= 10 {
        let quotient = rest / 10
        let d = rest - (quotient * 10)
        digits.append(d)
        rest = quotient
    }
    if rest != 0 {
        digits.append(rest)
    }
    return digits
}

struct MovingNumbersView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Demo:")
            MovingNumbersView(
                number: 123.456,
                numberOfDecimalPlaces: 3,
                verticalDigitSpacing: 6) { s in
                    Text(s)
                        .font(.headline)
                        .bold()
            }
        }.previewLayout(.fixed(width: 300, height: 300))
    }
}
