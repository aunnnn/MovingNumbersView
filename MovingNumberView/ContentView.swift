//
//  ContentView.swift
//  MovingNumbersView
//
//  Created by Wirawit Rueopas on 4/12/20.
//  Copyright © 2020 Wirawit Rueopas. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var numberOfDecimalPlaces: Double = 2
    @State var value: Double = 19
    let presetNumbers: [Double] = [
        0,9,
        10,19,29,99,
        129,
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
                    Text("Decimal places \(Int(numberOfDecimalPlaces)):")
                    Slider(value: $numberOfDecimalPlaces, in: (0...6))
                }
            }.padding()
            ForEach(presetNumbers, id: \.self) { num in
                Button(action: {
                    self.value = num
                }) {
                    Text("\(num)")
                }
            }
            HStack {
                MovingNumbersView(
                    number: value,
                    numberOfDecimalPlaces: Int(numberOfDecimalPlaces),
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
            HStack {
                MovingNumbersView(
                    number: value,
                    numberOfDecimalPlaces: Int(numberOfDecimalPlaces),
                    verticalDigitSpacing: 0
                ) { s in
                    Text(s)
                }.border(Color.red, width: 2)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
