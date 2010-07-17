module Types where

import Codec.Midi

type Tone = Int
type Intervals = [Int]
type Volume = Int
type Duration = Int

type Chord = [Tone]
type TimedChord = (Chord, Duration)
type Flow = [TimedChord]

type ToneToStop = (Tone, Duration)

data MusicState = MusicState {
	base :: Tone,
	intervals :: Intervals,
	beat :: Duration,
	remain :: Duration} deriving (Eq, Show)

type MidiEvent = (Ticks, Message)
type MidiTrack = [MidiEvent]


floatMin = 0.1 :: Float
floatZero = 0.001 :: Float

nullChord :: TimedChord
nullChord = ([], 0)

