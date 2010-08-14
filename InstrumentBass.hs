module InstrumentBass (bassTrack) where

import List
import Midi
import Random
import Types

takePart :: Flow -> [ToneToStop] -> [MidiEvent]
takePart flow playing
	| plToneEnds = toneMidi plTone 0 : takePart flow plRest
	| toneStarts = toneMidi tone1 80 : pauseMidi pause :
		takePart fRest newPlaying
	| plToneContinues = pauseMidi pause : takePart fRest newPlaying
	| otherwise = []
	where
		isPlaying = length playing > 0
		(plFstEnding:plRest) = playing
		(plTone, plDur) = plFstEnding
		plTones = map (\(t, _) -> t) playing
		
		isFlow = length flow > 0
		(ch:fRest) = flow
		tone1 = minimum $ tones ch
		dur1 = dur ch
		
		toneStarts = isFlow && (not isPlaying || (not $ elem tone1 plTones))
		plToneEnds = isPlaying && plDur == 0 && (not isFlow || tone1 /= plTone)
		plToneContinues = isPlaying && plDur == 0 && isFlow && plTone == tone1
		
		pause = minimum $ if isFlow then [dur1] else []
			++ if isPlaying then [plDur] else []
		newPlaying = sortPlayingEnd $ map (\(t, d) -> (t, d - pause)) $
			(tone1, dur1) : (if plToneContinues then plRest else playing)
		
		sortPlayingEnd = sortBy (\(_, d1) (_, d2) -> compare d1 d2)

bassTrack :: RandomGen g => Flow -> g -> MidiTrack
bassTrack flow _ = midiTrack 3 "Bass" 33 (takePart bassFlow []) (flow !! 0)
	where
		bassFlow = map newChordTones flow
		newChordTones ch = ch {tones = map (subtract 24) $ tones ch}

