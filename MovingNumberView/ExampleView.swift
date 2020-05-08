//
//  ExampleView.swift
//  MovingNumberView
//
//  Created by Wirawit Rueopas on 5/7/20.
//  Copyright © 2020 Wirawit Rueopas. All rights reserved.
//

import SwiftUI

struct ExampleView: View {
    
    @State private var number: Double = 0
    @State private var decimalPlaces = 2
    
    private let presets: [Double] = [
        1,
        7,
        9,
        39,
        99,
        319,
        999,
        0.0099,
        0.099,
        1234.567,
        1_234_567
    ]
    
    var body: some View {
        VStack {
            Form {
                VStack {
                    MovingNumbersView(
                        number: number,
                        numberOfDecimalPlaces: decimalPlaces,
                        fixedWidth: 300) { str in
                            Text(str)
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                    }
                }
                
                Section {
                    Text("\(number)")
                    Slider(value: $number, in: (0...1_000_000))
                    Stepper("Decimal: \(decimalPlaces)", value: $decimalPlaces, in: (0...10))
                }
                
                Section(header: Text("Presets")) {
                    presetView()
                        .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    private func presetView() -> some View {
        let numRows = Int(ceil(Double(presets.count) / 3.0))
        return ForEach(0..<numRows) { row in
            self.presetRow(row)
        }
    }
    
    private func presetRow(_ row: Int) -> some View {
        let count: Int = min(self.presets.count - row * 3, 3)
        return HStack(spacing: 8) {
            ForEach(0..<count) { col in
                self.presetButton(row, col: col)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color.blue)
            }
        }
    }
    
    private func presetButton(_ row: Int, col: Int) -> some View {
        Button(action: {
            self.number = self.presets[row * 3 + col]
        }) {
            Text("\(self.presets[row * 3 + col])")
        }
    }
}

struct ExampleView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleView()
    }
}
