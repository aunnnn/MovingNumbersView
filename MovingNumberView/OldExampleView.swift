//
//  OldExampleView.swift
//  MovingNumbersView
//
//  Created by Wirawit Rueopas on 4/12/20.
//  Copyright © 2020 Wirawit Rueopas. All rights reserved.
//

import SwiftUI

struct OldExampleView: View {
    @State var numberOfDecimalPlaces: Int = 2
    @State var value: Double = 19
    let presetNumbers: [Double] = [
        0,9,
        10,19,99,
        199,
        100.2354,
        199.99,
        -12345,
        12345,
        312_345,
        1_312_345,
    ]
    
    var body: some View {
        VStack {
            VStack {
                VStack {
                    Text("Number \(value):")
                    Slider(value: $value, in: (0...10_000))
                }
                VStack {
                    Stepper("Decimal places (\(numberOfDecimalPlaces))", value: $numberOfDecimalPlaces, in: 0...6)
                }
            }.padding()
            Text("Fixed Width (better animation)")
            HStack {
                MovingNumbersView(
                    number: value,
                    numberOfDecimalPlaces: numberOfDecimalPlaces,
                    verticalDigitSpacing: 0,
                    fixedWidth: 300
                ) { s in
                    Text(s)
                        .fontWeight(.heavy)
                        .font(.largeTitle)
                }
                .mask(LinearGradient(
                    gradient: Gradient(stops: [
                        Gradient.Stop(color: .clear, location: 0),
                        Gradient.Stop(color: .black, location: 0.2),
                        Gradient.Stop(color: .black, location: 0.8),
                        Gradient.Stop(color: .clear, location: 1.0)]),
                    startPoint: .top,
                    endPoint: .bottom))
                    .border(Color.red, width: 2)
                
            }
            Text("Dynamic Width")
            HStack {
                MovingNumbersView(
                    number: value,
                    numberOfDecimalPlaces: numberOfDecimalPlaces,
                    verticalDigitSpacing: 0
                ) { s in
                    Text(s)
                }.border(Color.red, width: 2)
            }
            ForEach(presetNumbers, id: \.self) { num in
                Button(action: {
                    self.value = num
                }) {
                    Text("\(num)")
                }
            }
        }
    }
}

struct OldExampleView_Previews: PreviewProvider {
    static var previews: some View {
        OldExampleView()
    }
}
