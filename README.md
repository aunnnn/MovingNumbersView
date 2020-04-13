# MovingNumbersView
Moving numbers effect like Robinhood app in SwiftUI.

![Demo](https://raw.githubusercontent.com/aunnnn/MovingNumbersView/master/mvn-demo.gif)

Also used in the Robinhood-like line plot library [RHLinePlot](https://github.com/aunnnn/RHLinePlot) demo.

## How it was done

Basically there are one view for each digit, comma, dot, and minus sign. Check out [`VisualElementType`](https://github.com/aunnnn/MovingNumbersView/blob/master/MovingNumberView/MovingNumbersView%2BComponents.swift) enum.

The digit is represented as 10-digit stack, and it's being moving up and down via `VerticalShift` geometry effect, which just offsets the digit stack by the current digit presented. (I believe the normal `transform/offset` might work too.)

The assigned `id`s are important. Each visual element is assigned a number relative to its significance. We use a multiple of `10`s for digit, `0` for dot and `1` is for minus sign. Comma has the `id` of next digit plus 5.

For example, `-1,234.56 -> ids = [1(-), 40, 35, 30, 20, 10, 0(.), -10, -20]`.

This scheme allows SwiftUI to calculate the right insertion/removal transitioning. 
Moving from 9 to 19 is moving from `ids = [10("9")]` to `ids = [20("1"), 10("9")]`. That is, we don't animate `9` to `1`, but simply bring in a new `1`.


## Features
- Dynamic decimal places
- Support commas
- Support negative numbers

## Installation
Just use or customize the source however you like.
