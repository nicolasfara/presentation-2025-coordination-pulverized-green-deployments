#import "@preview/touying:0.6.1": *
#import themes.metropolis: *
#import "@preview/fontawesome:0.5.0": *
#import "@preview/ctheorems:1.1.3": *
#import "@preview/numbly:0.1.0": numbly
#import "utils.typ": *

// Pdfpc configuration
// typst query --root . ./example.typ --field value --one "<pdfpc-file>" > ./example.pdfpc
#let pdfpc-config = pdfpc.config(
    duration-minutes: 30,
    start-time: datetime(hour: 14, minute: 10, second: 0),
    end-time: datetime(hour: 14, minute: 40, second: 0),
    last-minutes: 5,
    note-font-size: 12,
    disable-markdown: false,
    default-transition: (
      type: "push",
      duration-seconds: 2,
      angle: ltr,
      alignment: "vertical",
      direction: "inward",
    ),
  )

// Theorems configuration by ctheorems
#show: thmrules.with(qed-symbol: $square$)
#let theorem = thmbox("theorem", "Theorem", fill: rgb("#eeffee"))
#let corollary = thmplain(
  "corollary",
  "Corollary",
  base: "theorem",
  titlefmt: strong
)
#let definition = thmbox("definition", "Definition", inset: (x: 1.2em, top: 1em))
#let example = thmplain("example", "Example").with(numbering: none)
#let proof = thmproof("proof", "Proof")

#show: metropolis-theme.with(
  aspect-ratio: "16-9",
  footer: self => self.info.institution,
  config-common(
    // handout: true,
    preamble: pdfpc-config,
    show-bibliography-as-footnote: bibliography(title: none, "bibliography.bib"),
  ),
  config-info(
    title: [Declarative Deployment Planning for Green Pulverised Collective Computational Systems],
    // subtitle: [Subtitle],
    author: author_list(
      (
        ("Antonio Brogi", "antonio.brogi@unipi.it"),
        ("Roberto Casadei", "roby.casadei@unibo.it"),
        (first_author("Nicolas Farabegoli"), "nicolas.farabegoli@unibo.it"),
        ("Stefano Forti", "stefano.forti@unipi.it"),
        ("Mirko Viroli", "mirko.viroli@unibo.it"),
      )
    ),
    date: datetime.today().display("[day] [month repr:long] [year]"),
    institution: [University of Bologna & University of Pisa],
    //logo: align(right)[#image("images/disi.svg", width: 55%)],
  ),
)

#set text(font: "Fira Sans", weight: "light", size: 20pt)
#show math.equation: set text(font: "Fira Math")

#set raw(tab-size: 4)
#show raw: set text(size: 1em)
#show raw.where(block: true): block.with(
  fill: luma(240),
  inset: (x: 1em, y: 1em),
  radius: 0.7em,
  width: 100%,
)

#show bibliography: set text(size: 0.75em)
#show footnote.entry: set text(size: 0.75em)
#show quote: set text(size: 1.25em, style: "italic")

// #set heading(numbering: numbly("{1}.", default: "1.1"))

#title-slide()

// == Outline <touying:hidden>

// #components.adaptive-columns(outline(title: none, indent: 1em))

== DePPS -- _Declarative Deployment Planning for Pulverised Systems_

#quote[How to get a *good deployment plan* for pulverised systems?]

#v(1em)

=== Research Gap

- Previos works just #bold[compared] alternative deployments
- _MILP_ and _SAT_ may have issues with #bold[expressiveness], #bold[scalability], #bold[implementation], and #bold[operational aspects].

#only("2")[
  // #v(2em)
  #line(length: 100%)
  #components.side-by-side(columns: (1fr, 3fr))[
    #align(center)[
      #text(
        size: 2em,
        "DePPS",
        font: "Fira Sans",
        weight: "bold",
        fill: rgb("#4CAF50"),
      )
    ]
  ][
    _#underline[De]clarative deployment #underline[P]lanning for #underline[P]ulverised #underline[S]ystems_
  ]
  #v(0.5em)
  - *Prolog-based* planner for deployments based on non-functional requirements
  - Integration with *Alchemist simulator* for managing real-world dynamics
]

= Background

== Aggregate Computing

#components.side-by-side[
  Programming and computational model for *collective* behavior

  - Devices equipped with #bold[sensors] and #bold[actuators]
  - Devices can #bold[communicate] with each other (#underline[neighbors])
  - Devices work in #bold[asyncronous] rounds of execution
][
  #figure(image("images/scr-result.png"))
]

== Round-based Interaction

#only("1")[
  1. *sense*: the device get its sensors' values and neighbors' messages (not expired) 
  #figure(image("images/ac-messages-perception.svg"))
]
#only("2")[
  2. *compute*: The device evaluates the #underline[aggregate program] and produces a message to share with neighbors
  #figure(image("images/ac-computation.svg"))
]
#only("3")[
  3. *interact*: The prescribed actions are performed (through actuators) and the messages are sent to neighbors
  #figure(image("images/ac-messages-propagation.svg"))
]
#only("4")[
  4. *sleep*: The device goes to sleep until the next round
  #figure(image("images/ac.svg"))
]

== Pulverised Systems

#figure(image("images/pulverization.png"))

== Prolog

#components.side-by-side(columns: (2fr, 1fr))[
  Prolog is a *declarative* programming
  language based on #underline[first-order logic].

  - Consist of #bold[clauses] (or predicates)
  - Clauses with empty premises are called #bold[facts]

  ```prolog
  nice(X) :- honest(X), gentle(X).

  honest(alice).
  honest(barbara).
  gentle(barbara).
  ```

  ```prolog
  ?- nice(X).
  X = barbara ;
  ```
][
  #figure(image("images/file-type-prolog.svg", width: 60%))
]

= *DePPS* -- Architecture and Methodology

== Architecture 

#figure(image("images/alchemist-prolog.svg"))

== Prolog-based Planner

=== Knowledge Representation

A *digital device* is identified by a UID `DigDev`, the UID of its _knowledge_ component `k` and a list of UIDs of its _sense_ `S`, _act_ `A`, _behavior_ `B`, and _communication_ `C` components.

```prolog
digitalDevice(DigDev, K, [S, A, B, C]).
```

The components are associated with HW requirement `*HWReqs` and the maximul tollerated latency `*MaxLatToK` toward the knowledge component.

```prolog
knowledge(K, HWReqs).
sense(S, SHWReqs, SMaxLatToK).
act(A, AHWReqs, SMaxLatToK).
behaviour(B, BHWReqs, BMaxLatToK).
communication(C, CHWReqs, CMaxLatToK).
```

*Physical devices* (PD) are denoted by their UID `N`, available and total hardware `FreeHW` and `TotHW`, a list of `Sensors` and `Actuators` they can use.

```prolog
physicalDevice(N, FreeHW, TotHW, Sensors, Actuators).
```

Each PD has #bold[PUE] (Power Usage Effectiveness) associated, and an #bold[energy source mix].

```prolog
energySourceMix(N, [(P1,EnergySource1), ..., (PK,EnergySourceK)]).
pue(N, PUE).
```

Each PD is #bold[connected] to other physical devices though a *link* denoted by its available `Latency` and `Bandwidth`.

```prolog
link(N1, N2, Latency, Bandwidth).
```

// #slide[
//   #bibliography("bibliography.bib")
// ]
