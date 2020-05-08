# MovingNumbersView
Moving numbers effect in SwiftUI.

![Demo](https://raw.githubusercontent.com/aunnnn/MovingNumbersView/master/mvndemo2.gif)

Also used in the Robinhood-like line plot library [RHLinePlot](https://github.com/aunnnn/RHLinePlot) demo.

## Features :sparkles:
- Smooth digit transition
- Dynamic decimal places
- Support commas
- Support negative numbers

## Installation
Drag [MovingNumberView.swift](https://github.com/aunnnn/MovingNumbersView/blob/master/MovingNumberView/MovingNumbersView.swift) to your project. Use and customize however you like.

## How it was done

Basically there are one view for each digit, comma, dot, and minus sign, all centered in a `HStack` by default. Check out [`VisualElementType`](https://github.com/aunnnn/MovingNumbersView/blob/master/MovingNumberView/MovingNumbersView%2BComponents.swift) enum.

![Graph](https://raw.githubusercontent.com/aunnnn/MovingNumbersView/master/mvn-diagram.jpeg)

To show a number, we move only the vertical digit stack up and down to the right offset. Try removing the mask and see it in action:

![How](https://raw.githubusercontent.com/aunnnn/MovingNumbersView/master/mvn-how.gif)

The digit is represented as 10-digit stack, and it's being moving up and down via `VerticalShift` geometry effect, which just offsets the digit stack by the current digit presented. (I believe the normal `transform/offset` might work too.)

The assigned `id`s are important. Each visual element is assigned a number relative to its significance. We use a multiple of `10`s for digit, a negative multiple of `10`s for decimal places, `0` for dot and `1` is for minus sign. Comma has the `id` of next digit plus 5.

For example, `-1,234.56 -> ids = [1(-), 40, 35(,), 30, 20, 10, 0(.), -10, -20]`.

This scheme allows SwiftUI to calculate the right insertion/removal transitioning. 
Moving from 9 to 19 is moving from `ids = [10("9")]` to `ids = [20("1"), 10("9")]`. That is, we don't animate `9` to `1`, but simply bring in a new `1`.
