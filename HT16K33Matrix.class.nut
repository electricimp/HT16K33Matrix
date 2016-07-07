class HT16K33Matrix {
    // Squirrel class for 1.2-inch 8x8 LED matrix displays driven by the HT16K33 controller
    // For example: http://www.adafruit.com/products/1854

    // Bus: I2C
    // Availibility: Device

    // Written by Tony Smith (@smittytone) October 2014
    // Copyright 2014-2016 Electric Imp
    // Issued under the MIT license (MIT)

    static VERSION = [1,1,0];

    // HT16K33 registers and HT16K33-specific variables
    static HT16K33_REGISTER_DISPLAY_ON  = "\x81"
    static HT16K33_REGISTER_DISPLAY_OFF = "\x80"
    static HT16K33_REGISTER_SYSTEM_ON   = "\x21"
    static HT16K33_REGISTER_SYSTEM_OFF  = "\x20"
    static HT16K33_DISPLAY_ADDRESS      = "\x00"
    static HT16K33_I2C_ADDRESS          = 0x70

    // Proportionally space character set
    static pcharset = [
    [0x00, 0x00],                   // space - Ascii 32
    [0xfa],                         // !
    [0xc0, 0x00, 0xc0],             // "
    [0x24, 0x7e, 0x24, 0x7e, 0x24], // #
    [0x24, 0xd4, 0x56, 0x48],       // $
    [0xc6, 0xc8, 0x10, 0x26, 0xc6], // %
    [0x6c, 0x92, 0x6a, 0x04, 0x0a], // &
    [0xc0],                         // '
    [0x7c, 0x82],                   // (
    [0x82, 0x7c],                   // )
    [0x10, 0x7c, 0x38, 0x7c, 0x10], // *
    [0x10, 0x10, 0x7c, 0x10, 0x10], // +
    [0x06, 0x07],                   // ,
    [0x10, 0x10, 0x10, 0x10, 0x10], // -
    [0x06, 0x06],                   // .
    [0x04, 0x08, 0x10, 0x20, 0x40], // /
    [0x7c, 0x8a, 0x92, 0xa2, 0x7c], // 0 - Ascii 48
    [0x42, 0xfe, 0x02],             // 1
    [0x46, 0x8a, 0x92, 0x92, 0x62], // 2
    [0x44, 0x92, 0x92, 0x92, 0x6c], // 3
    [0x18, 0x28, 0x48, 0xfe, 0x08], // 4
    [0xf4, 0x92, 0x92, 0x92, 0x8c], // 5
    [0x3c, 0x52, 0x92, 0x92, 0x8c], // 6
    [0x80, 0x8e, 0x90, 0xa0, 0xc0], // 7
    [0x6c, 0x92, 0x92, 0x92, 0x6c], // 8
    [0x60, 0x92, 0x92, 0x94, 0x78], // 9
    [0x36, 0x36],                   // : - Ascii 58
    [0x36, 0x37],                   // ;
    [0x10, 0x28, 0x44, 0x82],       // <
    [0x24, 0x24, 0x24, 0x24, 0x24], // =
    [0x82, 0x44, 0x28, 0x10],       // >
    [0x60, 0x80, 0x9a, 0x90, 0x60], // ?
    [0x7c, 0x82, 0xba, 0xaa, 0x78], // @
    [0x7e, 0x90, 0x90, 0x90, 0x7e], // A - Ascii 65
    [0xfe, 0x92, 0x92, 0x92, 0x6c], // B
    [0x7c, 0x82, 0x82, 0x82, 0x44], // C
    [0xfe, 0x82, 0x82, 0x82, 0x7c], // D
    [0xfe, 0x92, 0x92, 0x92, 0x82], // E
    [0xfe, 0x90, 0x90, 0x90, 0x80], // F
    [0x7c, 0x82, 0x92, 0x92, 0x5c], // G
    [0xfe, 0x10, 0x10, 0x10, 0xfe], // H
    [0x82, 0xfe, 0x82],             // I
    [0x0c, 0x02, 0x02, 0x02, 0xfc], // J
    [0xfe, 0x10, 0x28, 0x44, 0x82], // K
    [0xfe, 0x02, 0x02, 0x02, 0x02], // L
    [0xfe, 0x40, 0x20, 0x40, 0xfe], // M
    [0xfe, 0x40, 0x20, 0x10, 0xfe], // N
    [0x7c, 0x82, 0x82, 0x82, 0x7c], // O
    [0xfe, 0x90, 0x90, 0x90, 0x60], // P
    [0x7c, 0x82, 0x92, 0x8c, 0x7a], // Q
    [0xfe, 0x90, 0x90, 0x98, 0x66], // R
    [0x64, 0x92, 0x92, 0x92, 0x4c], // S
    [0x80, 0x80, 0xfe, 0x80, 0x80], // T
    [0xfc, 0x02, 0x02, 0x02, 0xfc], // U
    [0xf8, 0x04, 0x02, 0x04, 0xf8], // V
    [0xfc, 0x02, 0x3c, 0x02, 0xfc], // W
    [0xc6, 0x28, 0x10, 0x28, 0xc6], // X
    [0xe0, 0x10, 0x0e, 0x10, 0xe0], // Y
    [0x86, 0x8a, 0x92, 0xa2, 0xc2], // Z - Ascii 90
    [0xfe, 0x82, 0x82],             // [
    [0x40, 0x20, 0x10, 0x08, 0x04], // \
    [0x82, 0x82, 0xfe],             // ]
    [0x20, 0x40, 0x80, 0x40, 0x20], // ^
    [0x02, 0x02, 0x02, 0x02, 0x02], // _
    [0xc0, 0xe0],                   // '
    [0x04, 0x2a, 0x2a, 0x1e],       // a - Ascii 97
    [0xfe, 0x22, 0x22, 0x1c],       // b
    [0x1c, 0x22, 0x22, 0x22],       // c
    [0x1c, 0x22, 0x22, 0xfc],       // d
    [0x1c, 0x2a, 0x2a, 0x10],       // e
    [0x10, 0x7e, 0x90, 0x80],       // f
    [0x18, 0x25, 0x25, 0x3e],       // g
    [0xfe, 0x20, 0x20, 0x1e],       // h
    [0xbc, 0x02],                   // i
    [0x02, 0x01, 0x21, 0xbe],       // j
    [0xfe, 0x08, 0x14, 0x22],       // k
    [0xfc, 0x02],                   // l
    [0x3e, 0x20, 0x18, 0x20, 0x1e], // m
    [0x3e, 0x20, 0x20 0x1e],        // n
    [0x1c, 0x22, 0x22, 0x1c],       // o
    [0x3f, 0x22, 0x22, 0x1c],       // p
    [0x1c, 0x22, 0x22, 0x3f],       // q
    [0x22, 0x1e, 0x20, 0x10],       // r
    [0x12, 0x2a, 0x2a, 0x04],       // s
    [0x20, 0x7c, 0x22, 0x04],       // t
    [0x3c, 0x02, 0x02, 0x3e],       // u
    [0x38, 0x04, 0x02, 0x04, 0x38], // v
    [0x3c, 0x06, 0x0c, 0x06, 0x3c], // w
    [0x22, 0x14, 0x08, 0x14, 0x22], // x
    [0x39, 0x05, 0x06, 0x3c],       // y
    [0x26, 0x2a, 0x2a, 0x32],       // z - Ascii 122
    [0x10, 0x7c, 0x82, 0x82],       // {
    [0xee],                         // |
    [0x82, 0x82, 0x7c, 0x10],       // }
    [0x40, 0x80, 0x40, 0x80],       // ~
    [0x60, 0x90, 0x90, 0x60],       // Degrees sign - Ascii 127
    ];

    // Class private properties
    _buffer = null;
    _led = null;

    _ledAddress = 0;
    _alphaCount = 96;
    _rotationAngle = 0;
    _rotateFlag = false;
    _inverseVideoFlag = false;
    _debug = false;

    constructor(impI2Cbus = null, i2cAddress = 0x70, debug = false) {

        // Parameters:
        //  1. Whichever configured imp I2C bus is to be used for the HT16K33
        //  2. The HT16K33's I2C address (default: 0x70)
        //  3. Boolean - set/unset to log/silence error messages
        //
        // Returns:
        //  HT16K33Matrix instance, or null on error

        if (impI2Cbus == null) {
            throw "HT16K33MatrixPro requires a non-null imp I2C object";
            return null;
        }

        _led = impI2Cbus;
        _ledAddress = i2cAddress << 1;
        _buffer = [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00];
        _debug = debug;
    }

    function init(brightness = 15, angle = 0) {

        // Parameters:
        //  1. Display brightness, 1-15 (default: 15)
        //  2. Display auto-rotation angle, 0 to -360 degrees (default: 0)
        //
        // Returns: Nothing

        // Angle range can be -360 to + 360 - ignore values beyond this
        if (angle < -360 || angle > 360) angle = 0;

        // Convert angle in degrees to internal value:
        // 0 = none, 1 = 90 clockwise, 2 = 180, 3 = 90 anti-clockwise
        if (angle < 0) angle = 360 + angle;

        if (angle > 3) {
            if (angle < 45 || angle > 360) angle = 0;
            if (angle >= 45 && angle < 135) angle = 1;
            if (angle >= 135 && angle < 225) angle = 2;
            if (angle >= 225) angle = 3
        }

        if (angle != 0) {
            _rotateFlag = true;
        } else {
            _rotageFlag = false;
        }

        _rotationAngle = angle;

        // Set the brightness (which also wipes and power-cycles the display)
        setBrightness(brightness);
    }

    function setBrightness(brightness = 15) {

        // Parameters:
        // 1. Display brightness, 1-15 (default: 15)
        //
        // Returns: Nothing

        if (brightness > 15) brightness = 15;
        if (brightness < 0) brightness = 0;
        brightness = brightness + 224;

        // Wipe the display completely first, so preserve what's in '_buffer'
        local sbuffer = [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00];
        for (local i = 0 ; i < 8 ; ++i) {
            sbuffer[i] = _buffer[i];
        }

        // Clear the LED matrix
        clearDisplay();

        // Power cycle the LED matrix
        powerDown();
        powerUp();

        // Write the new brightness value to the HT16K33
        _led.write(_ledAddress, brightness.tochar() + "\x00");

        // Restore what's was in '_buffer'
        for (local i = 0 ; i < 8 ; ++i) {
            _buffer[i] = sbuffer[i];
        }

        // Write buffer contents back to the LED matrix
        _writeDisplay();
    }

    function clearDisplay() {

        // Parameters: None
        // Returns: Nothing

        _buffer = [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00];
        _writeDisplay();
    }

    function setInverseVideo(state = true) {

        // Parameters:
        //  1. Boolean: whether inverse video is set (true) or unset (false)
        //
        // Returns: Nothing

        if (typeof state != "bool") state = true;
        _inverseVideoFlag = state;
        _writeDisplay();
    }

    function powerDown() {
        _led.write(_ledAddress, HT16K33_REGISTER_DISPLAY_OFF);
        _led.write(_ledAddress, HT16K33_REGISTER_SYSTEM_OFF);
    }

    function powerUp() {
        _led.write(_ledAddress, HT16K33_REGISTER_SYSTEM_ON);
        _led.write(_ledAddress, HT16K33_REGISTER_DISPLAY_ON);
    }

    function displayIcon(glyphMatrix, center = false) {
        // Displays a custom character
        // Parameters:
        //  1. Array of 1-8 8-bit values defining a pixel image
        //     The data is passed as columns
        //  2. Boolean indicating whether the icon should be displayed
        //     centred on the screen
        //
        // Returns: nothing

        if (glyphMatrix == null || typeof glyphMatrix != "array") {
            if (_debug) server.error("HT16K33Matrix.displayIcon() passed undefined icon array");
            return;
        }

        if (glyphMatrix.len() < 1 || glyphMatrix.len() > 8) {
            if (_debug) server.error("HT16K33Matrix.displayIcon() passed incorrectly sized icon array");
            return;
        }

        if (_rotateFlag) glyphMatrix = _rotateMatrix(glyphMatrix, _rotationAngle);
        _buffer = [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00];

        for (local i = 0 ; i < glyphMatrix.len() ; ++i) {
            local a = i;
            if (center) a = i + ((8 - glyphMatrix.len()) / 2).tointeger();

            if (_inverseVideoFlag) {
                _buffer[a] = ~glyphMatrix[i];
            } else {
                _buffer[a] = glyphMatrix[i];
            }
        }

        _writeDisplay();
    }

    function displayChar(asciiValue = 32) {
        // Display a single character specified by its Ascii value
        // Parameters:
        //  1. Character Ascii code (default: 32 [space])
        //
        // Returns: nothing

        asciiValue = asciiValue - 32;
        if (asciiValue < 0 || asciiValue > _alphaCount) asciiValue = 0;
        local inputMatrix = clone(charset[asciiValue]);
        if (_rotateFlag) inputMatrix = _rotateMatrix(inputMatrix, _rotationAngle);
        _buffer[i] = [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00];
        for (local i = 0 ; i < glyphMatrix.len() ; ++i) {
            if (_inverseVideoFlag) {
                _buffer[i] = ~inputMatrix[i];
            }
            else {
                _buffer[i] = inputMatrix[i];
            }
        }

        _writeDisplay();
    }

    function displayLine(line) {
        // Bit-scroll through the characters in the variable ‘line’
        // Parameters:
        //  1. String of text
        //
        // Returns: nothing

        if (line == null || line == "") {
            if (_debug) server.error("HT16K33Matrix.displayLine() sent a null or zero-length string");
            return;
        }

        foreach (index, character in line) {
            local glyph = clone(pcharset[character - 32]);

            // Add an empty spacer column to the character matrix
            glyph.append(0x00);

            foreach (column, columnValue in glyph) {
                local cursor = column;
                local glyphToDraw = glyph;
                local increment = 1;
                local outputFrame = [0,0,0,0,0,0,0,0];
                for (local k = 0 ; k < 8 ; ++k) {
                    if (cursor < glyphToDraw.len()) {
                        outputFrame[k] = _flip(glyphToDraw[cursor]);
                        ++cursor;
                    } else {
                        if (index + increment < line.len()) {
                            glyphToDraw = clone(pcharset[line[index + increment] - 32]);
                            glyphToDraw.append(0x00);
                            ++increment;
                            cursor = 1;
                            outputFrame[k] = _flip(glyphToDraw[0]);
                        }
                    }
                }

                for (local k = 0 ; k < 8 ; ++k) {
                    if (_inverseVideoFlag) {
                        _buffer[k] = ~outputFrame[k];
                    } else {
                        _buffer[k] = outputFrame[k];
                    }
                }

                // Pause between frames according to level of rotation
                if (_rotationAngle == 0) {
                    imp.sleep(0.060);
                } else {
                    imp.sleep(0.045);
                }

                if (_rotateFlag) _buffer = _rotateMatrix(_buffer, _rotationAngle);
                _writeDisplay();
            }
        }
    }

    // ****** PRIVATE FUNCTIONS - DO NOT CALL ******

    function _writeDisplay() {
        // Takes the contents of _buffer and writes it to the LED matrix
        // Uses function processByte() to manipulate regular values to
        // Adafruit 8x8 matrix's format
        local dataString = HT16K33_DISPLAY_ADDRESS;

        for (local i = 0 ; i < 8 ; ++i) {
            dataString = dataString + (_processByte(_buffer[i])).tochar() + "\x00";
        }

        _led.write(_ledAddress, dataString);
    }

    function _flip(value) {
        // Function used to manipulate pre-defined character matrices
        // ahead of rotation by changing their byte order
        local a = 0;
        local b = 0;

        for (local i = 0 ; i < 8 ; ++i) {
            a = value & (1 << i);
            if (a > 0) b = b + (1 << (7 - i));
        }

        return b;
    }

    function _rotateMatrix(inputMatrix, angle = 0) {
        // Value of angle determines the rotation:
        // 0 = none, 1 = 90 clockwise, 2 = 180, 3 = 90 anti-clockwise
        if (angle == 0) return inputMatrix;

        local a = 0;
        local lineValue = 0;
        local outputMatrix = [0,0,0,0,0,0,0,0];

        // Note: it's quicker to have three case-specific
        // code blocks than a single, generic block
        switch(angle) {
            case 1:
                for (local y = 0 ; y < 8 ; ++y) {
                    lineValue = inputMatrix[y];
                    for (local x = 7 ; x > -1 ; --x) {
                        a = lineValue & (1 << x);
                        if (a != 0) outputMatrix[7 - x] = outputMatrix[7 - x] + (1 << y);
                    }
                }
                break;

            case 2:
                for (local y = 0 ; y < 8 ; ++y) {
                    lineValue = inputMatrix[y];
                    for (local x = 7 ; x > -1 ; --x) {
                        a = lineValue & (1 << x);
                        if (a != 0) outputMatrix[7 - y] = outputMatrix[7 - y] + (1 << (7 - x));
                    }
                }
                break;

            case 3:
                for (local y = 0 ; y < 8 ; ++y) {
                    lineValue = inputMatrix[y];
                    for (local x = 7 ; x > -1 ; --x) {
                        a = lineValue & (1 << x);
                        if (a != 0) outputMatrix[x] = outputMatrix[x] + (1 << (7 - y));
                    }
                }
                break;
        }

        return outputMatrix;
    }

    function _processByte(byteValue) {
        // Adafruit 8x8 matrix requires some data manipulation:
        // Bits 7-0 of each line need to be sent 0 through 7,
        // and bit 0 rotate to bit 7

        local result = 0;
        local a = 0;
        for (local i = 0 ; i < 8 ; ++i) {
            // Run through each bit in byteValue and set the
            // opposite bit in result accordingly, ie. bit 0 -> bit 7,
            // bit 1 -> bit 6, etc.
            a = byteValue & (1 << i);
            if (a > 0) result = result + (1 << (7 - i));
        }

        // Get bit 0 of result
        result & 0x01;

        // Shift result bits one bit to right
        result = result >> 1;

        // if old bit 0 is set, set new bit 7
        if (a > 0) result = result + 0x80;
        return result;
    }
}
