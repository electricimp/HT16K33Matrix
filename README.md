# HT16K33Matrix

Hardware driver for [Adafruit 1.02-inch monochrome LED matrix display](http://www.adafruit.com/products/1854) based on the Holtek HT16K33 controller. The LED communicates over any imp I&sup2;C bus.

The class incorporates its own Ascii character set, from 32 ( space ) to 127 ( (c) )

## Class Usage

## Constructor: HT16K33Matrix(*impI2cBus, [i2cAddress]*)

To instantiate an HT16K33Matrix object pass the I&sup2;C bus to which the display is connected and, optionally, its I&sup2;C address. If no address is passed, the default value, `0x70` will be used. Pass an alternative address if you have changed the display’s address using the solder pads on rear of the LED’s circuit board.

The passed imp I&sup2;C bus must be configured before the HT16K33Matrix object is created.

```squirrel
hardware.i2c89.configure(CLOCK_SPEED_400_KHZ)
led <- HT16K33Matrix(hardware.i2c89)
```

## Class Methods

## init(*[brightness], [angle]*)

Call *init()* to set the matrix’s initial settings. All the parameters are optional.

- *brightness* sets the LED intensity (duty cycle) to a value between 0 (dim) and 15 (maximum); the default is 15. - *angle* specifies the optional angle by which any image drawn on the matrix will be rotated: 0 (0&deg;), 1 (90&deg;), 2 (180&deg;) or 3 (270&deg;); the default is 0.

```squirrel
// Set matrix to max brightness and to
// rotate all characters by 180 degrees

led.init(15, 2)
```

## displayChar(*[asciiValue]*)

Call *displayChar()* to write an Ascii character to the matrix. The value is optional; if no value is specified, the display will be set to display a space character. Unless the matrix is set to inverse video mode, this has the same effect as *clearDisplay()*.

```squirrel
// Set the display to show ‘A’

led.displayChar(65)
```

## displayIcon(*glyphMatrix*)

Call *displayIcon()* to write an non-standard character or graphic to the matrix. The character is passed as an array containing eight integer values, each a bit pattern for the rows making up the character, from top to bottom. If no array is passed, or an empty or incomplete array is passed, the function returns with no effect.

```squirrel
// Display a smiley on the matrix

local smiley = [0x3C, 0x42, 0xA5, 0x81, 0xA5, 0x99, 0x42, 0x3C]
led.displayIcon(smiley)
```

## displayLine(*line*)

Call *displayLine()* to write a string to the matrix. The characters (one or more) comprising the string will scroll leftward. If no string is passed, or an empty string is passed, the function returns with no effect.

```squirrel
// Display 'The quick brown fox...' on the display

local text = @"The quick brown fox jumped over the lazy dog"
led.displayline(text)
```

## clearDisplay()

Call *clearDisplay()* to blank the matrix.

## setInverseVideo(*state*)

Call *setInverseVideo()* to specify whether the characters on the matrix should be displayed in inverse video (dark on light) or standard video (light on dark). Pass `true` to select inverse video mode, `false` to select standard video. If no value is passed, inverse mode is selected automatically.

```squirrel
// Display 'The quick brown fox...' on the display in standard...

local text = @"The quick brown fox jumped over the lazy dog"
led.displayline(text)

// ...and in inverse video

led.setInverseVideo(true)
led.displayLine(text)
```

## setBrightness(*[brightness]*)

Call *setBrightness()* to set the matrix’s brightness (duty cycle) to a value between 0 (dim) and 15 (maximum). The value is optional; the matrix will be set to maximum brightness if no value is passed.

```squirrel
// Set the display brightness to 50%

led.setBrightness(8)
```

## powerDown()

The display can be turned off by calling *powerDown()*.

## powerUp()

The display can be turned on by calling *powerup()*.

## License

The HTK16K33Segment library is licensed under the [MIT License](./LICENSE).
