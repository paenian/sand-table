Testing with the Makelangelo firmware on the Adafruit motor shield.

Couldn't find documentation...

##MCODES
M17: Engage motors
M18: Disengage motors
M100: Show Help
M101: T### B### R### L### G### H### : process config
Top, Bottom, Right, Left, ?, ?

M114: Show current position

##GCODES
G0 & G1: Line Move
G2 & G3: Arc move
G4 S###: Pause ### seconds?
G20: Scale inches to CM
G21: Scale mm to cm
G59 X### Y### Z### : set tool offset
G90: Set Absolute Mode
G91: Set Relative Mode
G92 X### Y### Z### : Set Position

##DCODES
D0 (L|R)### : Move L or R motor ### distance.
D1 L### R### : Adjust spool diameter
D2 : Print pulley diameters
D3 : List SD Card Files
D4 <filename> : Draw file from SD
D5 : Print version number
D6 : set home position
D10 : Print Hardware Version Number

