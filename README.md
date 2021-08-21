# Life.scm  

A simple Chez Scheme implementation of Conway's Game of Life.


# Usage

Run the automaton (in the REPL) with the functions: 
`draw-grid` and `life` combined as follows:

`(draw-grid (life generations grid))` where:

- `generations` is a nonnegative integer (it may be 0)
 representing the number of generations the automaton must 
 run for before drawing the final grid and
- `grid` is a square (see examples below) list representing 
the grid.

# Examples

The first example is the still life called "block".
the grid is a 4x4 = 16 elements list:
```
(draw-grid (life 12 '(
	#f #f #f #f
	#f #t #t #f
	#f #t #t #f
	#f #f #f #f)))
```

The second example is the so-called "beehive", with a 
5x5 = 25 elements list:
```
(draw-grid ( life 34 '(
	#f #f #f #f #f
	#f #f #t #t #f
	#f #t #f #f #t
	#f #f #t #t #f
	#f #f #f #f #f)))
```
