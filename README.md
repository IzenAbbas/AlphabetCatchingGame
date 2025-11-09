# CatchAlphabets Game - Assembly Language Project (Fall 2024)
## Project Overview

This project implements a simple game called "CatchAlphabets," where the player controls a box using left and right arrow keys to catch falling alphabets. The game is implemented in Assembly Language and will run on DOSBox. The player earns points by catching falling characters, and the game ends after missing 10 characters.

## Game Details

### Game Start:
The game starts automatically when the program is run in DOSBox.

### Box Control:
A box (ASCII value 0xDC) appears in the center of the bottom row of the screen. It can be moved left or right using the arrow keys:

Left arrow key (scan code 0x4B) moves the box left.

Right arrow key (scan code 0x4D) moves the box right.

The box movement is handled by hooking the keyboard interrupt (9h).

### Falling Characters:
The game features characters (A-Z) falling from the top of the screen to the bottom. The characters start falling from the top and move down at different speeds. There should always be at least five characters falling at once.

The random number generation for the starting position of the characters is handled by the rand.asm subroutine.

### Score:
The score is displayed at the top right of the screen. Each time the player catches a falling character, the score increases by 1.

# Game Over:
The game ends when the player misses 10 falling characters. Upon game over, the program terminates, and DOSBox returns to its normal prompt.
