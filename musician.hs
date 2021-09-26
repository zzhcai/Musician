module Proj2 (Pitch, Chord, GameState,
              toPitch, feedback, initialGuess, nextGuess) where

import Data.List ( (\\), group, sort, sortBy, subsequences )
import Data.Ord ( comparing )

-- | Pitch is specified by two Char values: the first one represents
--   the musical note, the second represents the octave.
data Pitch = Pitch Char Char
    deriving Eq

instance Show Pitch where
    show (Pitch note octave) = [note, octave]

-- | Chord is a list of Pitch. Feedback is a 3-tuple of Int values.
--   GameState is a list of all remaining possible target chords.
type Chord     = [Pitch]
type Feedback  = (Int, Int, Int)
type GameState = [Chord]

getNote :: Pitch -> Char
getNote (Pitch m n) = m

getOctave :: Pitch -> Char
getOctave (Pitch m n) = n

-- | Takes a string, give Just 'the Pitch named by the string', or Nothing if
--   the pitch name is invalid.
toPitch :: String -> Maybe Pitch
toPitch [m, n] | elem m "ABCDEFG" && elem n "123"
  = Just $ Pitch m n
toPitch _ = Nothing

-- | Takes a target chord then a chord guess, gives feedback (n1, n2, n3).
--   n1 is the number of correct pitches.
--   n2 is the number of those with the right note but the wrong octave.
--   n2 is the number of those with the right octave but the wrong note.
feedback :: Chord -> Chord -> Feedback
feedback target guess = (n1, n2, n3)
    where
      n1 = 3 - length (target \\ guess)
      n2 = 3 - n1 - length (map getNote target \\ map getNote guess)
      n3 = 3 - n1 - length (map getOctave target \\ map getOctave guess)

-- | Gives a tuple of (initial guess, all possible target chords).
--   The optimal initial guess should cover 3 different notes and 2 different
--   octaves, in order to obtain a more informatic feedback.
--   Here I sugguest the initial guess to be 'A2', 'B1' and 'C1'.
initialGuess :: (Chord, GameState)
initialGuess
  = ([Pitch 'A' '2', Pitch 'B' '1', Pitch 'C' '1'], allChord)
    where
      allPitch = [ Pitch m n | m <- "ABCDEFG", n <- "123" ]
      allChord = [ ps | ps <- subsequences allPitch, length ps == 3 ]

-- | Takes a tuple of (previous guess, previous all possible targets) and the
--   composer's feedback. Gives a tuple (new guess, remaining possible targets).
--   Remaining possible targets are those that gives the same feedback with the
--   composer's feedback.
--   The new guess is the one in the set of remaining possible targets, which
--   mathematically, is expected to maximally reduce the number of candidates.
nextGuess :: (Chord, GameState) -> Feedback -> (Chord, GameState)
nextGuess (guess, state) result = (guess', state')
    where
      state' = filter (\x -> feedback x guess == result) state
      avgRemCands = [ (avgRemained state' x, x) | x <- state' ]
      guess' = snd $ head $ sortBy (comparing (\(x,y) -> x)) avgRemCands

-- | Takes the set of current remaining targets and a guess of candidate target.
--   Gives the average number of possible targets left after guessing it.
--   For example, suppose there are ten remaining candidate targets, and one
--   guess gives the answer (3,0,0), three others give (1,0,2), and the
--   remaining six give the answer (2,0,1).
--   If the correct target feedbacks (3,0,0), we can remove all other nine
--   candidates. So we have a probability of 1/10 to get 1 remained.
--   This is similar for (1,0,2) and (2,0,1), therefore the average number of
--   remaining targets is 1*1/10 + 3*3/10 + 6*6/10 = 4.6.
avgRemained :: GameState -> Chord -> Double
avgRemained state guess
  = sum [ groupSize ^ 2 / stateSize
        | group <- groupedRem
        , let groupSize = fromIntegral $ length group
        ]
    where
      stateSize = fromIntegral $ length state
      groupedRem = group $ sort [ feedback cand guess | cand <- state ]
