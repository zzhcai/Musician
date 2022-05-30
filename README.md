# Summary

Musician is a two-player logical guessing game created for this project. You will not find any information about the game anywhere else, but it is a simple game and this specification will tell you all you need to know.

For a Musician game, one player is the composer and the other is the performer. The composer begins by selecting a three-pitch musical chord, where each pitch comprises a musical note, one of A, B, C, D, E, F, or G, and an octave, one of 1, 2, or 3. This chord will be the target for the game. The order of pitches in the target is irrelevant, and no pitch may appear more than once. This game does not include sharps or flats, and no more or less than three notes may be included in the target.

Once the composer has selected the target chord, the performer repeatedly chooses a similarly defined chord as a guess and tells it to the composer, who responds by giving the performer the following feedback:

  1. how many pitches in the guess are included in the target (correct pitches)
  2. how many pitches have the right note but the wrong octave (correct notes)
  3. how many pitches have the right octave but the wrong note (correct octaves)

<br/>

In counting correct notes and octaves, multiple occurrences in the guess are only counted as correct if they also appear repeatedly in the target. Correct pitches are not also counted as correct notes and octaves. For example, with a target of A1, B2, A3, a guess of A1, A2, B1 would be counted as 1 correct pitch (A1), two correct notes (A2, B1) and one correct octave (A2). B1 would not be counted as a correct octave, even though it has the same octave as the target A1, because the target A1 was already used to count the guess A1 as a correct pitch. A few more examples:

<br/>

| Target   | Guess    | Answer |
| :---     | :---     |   ---: |
| A1,B2,A3 | A1,A2,B1 | 1,2,1  |
| A1,B2,C3 | A1,A2,A3 | 1,0,2  |
| A1,B1,C1 | A2,D1,E1 | 0,1,2  |
| A3,B2,C1 | C3,A2,B1 | 0,3,3  |

<br/>

The game finishes once the performer guesses the correct chord (all three pitches in the guess are in the target). The object of the game for the performer is to find the target with the fewest possible guesses.

This project was to write Haskell code to implement both the composer and performer parts of the game.


# Marks

- 14.6/15 (97.5%)

  ```
  pass toPitch check
  pass Testing your feedback function.
  pass Guessing validation test for target D1 B1 G3

  Guessing test 1 output:
  Successfully guessed the target E2 E1 F1
  Guesses taken: 4
  Points scored: 1.075

  Guessing test 2 output:
  Successfully guessed the target F3 D1 G3
  Guesses taken: 3
  Points scored: 1.4333333333333333

  Guessing test 3 output:
  Successfully guessed the target C2 C1 E2
  Guesses taken: 4
  Points scored: 1.075

  Guessing test 4 output:
  Successfully guessed the target D2 G1 B1
  Guesses taken: 5
  Points scored: 0.86

  Guessing test 5 output:
  Successfully guessed the target G1 A3 B1
  Guesses taken: 6
  Points scored: 0.7166666666666667

  Guessing test 6 output:
  Successfully guessed the target C1 D2 F2
  Guesses taken: 4
  Points scored: 1.075

  Guessing test 7 output:
  Successfully guessed the target C3 A3 A1
  Guesses taken: 4
  Points scored: 1.075

  Guessing test 8 output:
  Successfully guessed the target A2 E1 C3
  Guesses taken: 5
  Points scored: 0.86

  Guessing test 9 output:
  Successfully guessed the target F1 G3 B2
  Guesses taken: 5
  Points scored: 0.86

  Guessing test 10 output:
  Successfully guessed the target G2 D1 D3
  Guesses taken: 4
  Points scored: 1.075
  ```

- One of the most useful features of Haskell is the ability to define data types that cannot contain invalid values. This allows you to leverage the compiler to ensure correctness. For this reason you should prefer defining custom data types to using chars and ints. This would statically prevent ever accidentally creating an invalid pitch, like Pitch 'X' 'Y'.
