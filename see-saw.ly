\version "2.12.2"
#(set-global-staff-size 20)

% un-comment the next line to remove Lilypond tagline:
% \header { tagline="" }

\pointAndClickOff

\paper {
  print-all-headers = ##t % allow per-score headers

  % un-comment the next line for A5:
  % #(set-default-paper-size "a5" )

  % un-comment the next line for no page numbers:
  % print-page-number = ##f

  % un-comment the next 3 lines for a binding edge:
  % two-sided = ##t
  % inner-margin = 20\mm
  % outer-margin = 10\mm

  % un-comment the next line for a more space-saving header layout:
  % scoreTitleMarkup = \markup { \center-column { \fill-line { \magnify #1.5 { \bold { \fromproperty #'header:dedication } } \magnify #1.5 { \bold { \fromproperty #'header:title } } \fromproperty #'header:composer } \fill-line { \fromproperty #'header:instrument \fromproperty #'header:subtitle \smaller{\fromproperty #'header:subsubtitle } } } }
}

\score {
<< \override Score.BarNumber #'break-visibility = #end-of-line-invisible
\override Score.BarNumber #'Y-offset = -1
\set Score.barNumberVisibility = #(every-nth-bar-number-visible 5)

% === BEGIN 5-LINE STAFF ===
    \new Staff { \new Voice="5line" {
    #(set-accidental-style 'modern-cautionary)
    \override Staff.TimeSignature #'style = #'numbered
    \set Voice.chordChanges = ##f % for 2.19.82 bug workaround
\time 2/4 g'4 e'4 | %{ bar 2: %} g'8 g'8 e'4 | %{ bar 3: %} g'8 g'8 e'8 e'8 | %{ bar 4: %} g'8 g'8 e'4 \bar "|." } }
% === END 5-LINE STAFF ===


%% === BEGIN JIANPU STAFF ===
    \new RhythmicStaff \with {
    \consists "Accidental_engraver"
    %% Get rid of the stave but not the barlines.
    %% This changes between Lilypond versions.
    %% \remove Staff_symbol_engraver %% worked pre-2.18, but 2.18 results in missing barlines (adding Barline_engraver won't help). Do this instead:
    \override StaffSymbol #'line-count = #0 %% tested in 2.15.40, 2.16.2, 2.18.0 and 2.18.2
    \override BarLine #'bar-extent = #'(-2 . 2) %% LilyPond 2.18: please make barlines as high as the time signature even though we're on a RhythmicStaff (2.16 and 2.15 don't need this although its presence doesn't hurt; Issue 3685 seems to indicate they'll fix it post-2.18)
    }
    { \new Voice="jianpu" {
    \override Beam #'transparent = ##f % (needed for LilyPond 2.18 or the above switch will also hide beams)
    \override Stem #'direction = #DOWN
    \override Stem #'length-fraction = #0
    \override Beam #'beam-thickness = #0.1
    \override Beam #'length-fraction = #0.5
    \override Voice.Rest #'style = #'neomensural % this size tends to line up better (we'll override the appearance anyway)
    \override Accidental #'font-size = #-4
    \override Tie #'staff-position = #2.5
    \override TupletBracket #'bracket-visibility = ##t
    \tupletUp
    \set Voice.chordChanges = ##t % 2.19 bug workaround
%} 
    \override Staff.TimeSignature #'style = #'numbered
    \override Staff.Stem #'transparent = ##t
     \time 2/4
#(define (note-five grob grob-origin context)
  (if (and (eq? (ly:context-property context 'chordChanges) #t)
      (or (grob::has-interface grob 'note-head-interface)
        (grob::has-interface grob 'rest-interface)))
    (begin
      (ly:grob-set-property! grob 'stencil
        (grob-interpret-markup grob
          (make-lower-markup 0.5 (make-bold-markup "5")))))))
  \applyOutput #'Voice #note-five g'4
#(define (note-three grob grob-origin context)
  (if (and (eq? (ly:context-property context 'chordChanges) #t)
      (or (grob::has-interface grob 'note-head-interface)
        (grob::has-interface grob 'rest-interface)))
    (begin
      (ly:grob-set-property! grob 'stencil
        (grob-interpret-markup grob
          (make-lower-markup 0.5 (make-bold-markup "3")))))))
  \applyOutput #'Voice #note-three e'4
| %{ bar 2: %} \set stemLeftBeamCount = #0
\set stemRightBeamCount = #1
  \applyOutput #'Voice #note-five g'8[
\set stemLeftBeamCount = #1
\set stemRightBeamCount = #1
  \applyOutput #'Voice #note-five g'8]
  \applyOutput #'Voice #note-three e'4
| %{ bar 3: %} \set stemLeftBeamCount = #0
\set stemRightBeamCount = #1
  \applyOutput #'Voice #note-five g'8[
\set stemLeftBeamCount = #1
\set stemRightBeamCount = #1
  \applyOutput #'Voice #note-five g'8]
\set stemLeftBeamCount = #0
\set stemRightBeamCount = #1
  \applyOutput #'Voice #note-three e'8[
\set stemLeftBeamCount = #1
\set stemRightBeamCount = #1
  \applyOutput #'Voice #note-three e'8]
| %{ bar 4: %} \set stemLeftBeamCount = #0
\set stemRightBeamCount = #1
  \applyOutput #'Voice #note-five g'8[
\set stemLeftBeamCount = #1
\set stemRightBeamCount = #1
  \applyOutput #'Voice #note-five g'8]
  \applyOutput #'Voice #note-three e'4
\bar "|." } }
% === END JIANPU STAFF ===

>>
\header{
composer="Chong"
title="跷跷板See-Saw"
}
\layout{} }
\score {
\unfoldRepeats
<< 

% === BEGIN MIDI STAFF ===
    \new Staff { \new Voice="midi" { \time 2/4 g'4 e'4 | %{ bar 2: %} g'8 g'8 e'4 | %{ bar 3: %} g'8 g'8 e'8 e'8 | %{ bar 4: %} g'8 g'8 e'4 } }
% === END MIDI STAFF ===

>>
\header{
composer="Chong"
title="跷跷板See-Saw"
}
\midi { \context { \Score tempoWholesPerMinute = #(ly:make-moment 84 4)}} }
