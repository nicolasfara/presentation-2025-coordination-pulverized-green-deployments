#import "@preview/touying:0.6.1": *
#import themes.metropolis: *
#import "@preview/fontawesome:0.5.0": *
#import "@preview/ctheorems:1.1.3": *
#import "@preview/numbly:0.1.0": numbly
#import "utils.typ": *
#import "@preview/cetz:0.3.4"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

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

#quote[How to get a *good deployment plan* for (pulverised) collective computational systems?]

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
  X = barbara;
  ```
][
  #figure(image("images/file-type-prolog.svg", width: 60%))
]

= *DePPS* -- Architecture and Methodology

== Architecture 

#figure(image("images/alchemist-prolog.svg"))

== Prolog-based Planner

A *digital device* is identified by a UID `DigDev`,
the UID of its _knowledge_ component `K` and a list of UIDs of its _sense_ `S`,
_act_ `A`, _behavior_ `B`, and _communication_ `C` components.

#figure(image("images/digital-device.svg"))

#pagebreak()

=== Knowledge Representation

```prolog
digitalDevice(DigDev, K, [S, A, B, C]).
```

The components are associated with HW requirement `*HWReqs` and the maximul tollerated latency `*MaxLatToK` toward the knowledge component.

```prolog
knowledge(K, HWReqs).
sense(S, SHWReqs, SMaxLatToK).
act(A, AHWReqs, AMaxLatToK).
behaviour(B, BHWReqs, BMaxLatToK).
communication(C, CHWReqs, CMaxLatToK).
```
#pagebreak()

*Physical devices* (PD) are denoted by their UID `N`, available and total hardware `FreeHW` and `TotHW`, a list of `Sensors` and `Actuators` they can use.

#figure(image("images/physical-device.svg"))

#pagebreak()

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

== Placement strategy

+ Select a node $mono("NK") in mono("Nodes")$ as placement target for $mono("K")$ component
+ The `placeKnowledge/4` predicate gets the HW requirements of $mono("K")$ and checks the `HWCaps` of $mono("NK")$ can support the new allocation, i.e., $mono("used(NK, HWUsed)" in I)$
+ The `placeComponents/6` assigns the $mono("A, S, B, C")$ components ensuring they meet the latency constrain towards the _knowledge_
  + Sensor and Actuators are placed onto nodes $mono("N") in mono("Nodes")$
  + Predicate `latencyOk` checks that the end-to-end latency between $mono("NK")$ and $mono("N")$ is $< mono("LatToK")$
  + Predicate `hwOk/5` check the current placement leave enought free HW on $mono("N")$
  + `placeComponents/6` recursively places the remaining components
+ A complete eligible placement is found when the list of components to be placed is empty `[]`

== Environment footprint assesment

+ `footprint/4` with a `Placement`, estimates `Energy` and `Carbon`.
  + Extract nodes from `Placement`, remove duplicates with `sort/2`.
+ Use `hardwareFootprint/5` to process each node:
  + Call `nodeEnergy/4`:
    - Get `FreeHW`, `TotHW`, and current allocation.
    - Compute load and energy before/after placement.
    - Energy = `(NewE - OldE) * PUE`.
  + Call `nodeEmissions/3`:
    - For each energy source: get carbon intensity and proportion.
    - Compute weighted average, multiply by energy to get emissions.
+ Accumulate per-node energy and emissions.
+ Return total `Energy` and `Carbon`.

== Placing multiple devices

The considered problem has the following #bold[characteristics]:
- Incurs in *exp-time* (worst-case) complexity #fa-warning()
- Is proved to be *NP-hard* #cite(label("7919155")) #fa-warning()

=== Solution

We devised a *heuristic-strategy* capable of placing #underline[multiple] devices by exploring candidate nodes from those with #bold[lower carbon intensity] to those with #bold[higher carbon intensity] #footnote("While it practically reduces search times, it remains worst-case exp-time.").

The `place/4` is extended to:
- sort the nodes by their *carbon intensity* and *energy consumption*
- impose a *threshold* on the carbon intensisty and energy consumption (single node)

= Evaluation

#slide[
  The proposed approach has been applied to #bold[different network topologies],
  and a #bold[variable number of devices]

  #components.side-by-side(columns: (2fr, 1fr))[
  We can (re)generate #bold[deployment plans] featuring:
  - improved *carbon footprint*
  - reduced *energy consumption*
  - reduced overall *latency*

  All the experiments are #underline[released as open-source] on GitHub #fa-github() with a permissive license, and permanently archived on #bold[Zenodo] #cite(label("nicolas_farabegoli_2025_14927541"))
  ][
    #figure((image("images/github-experiments-qr.svg", width: 70%)))
  ]
]

== Setup

We model a #underline[syntetic system] acting as a proxy for a *smart city event* or a *swarm* with devices moving around.

=== Experimental setup
#components.side-by-side[
#table(
  columns: 2,
  align: (left, left),
  inset: 0.4em,
  table.header(
    [#bold[Parameter]], [#bold[Value]]
  ),
    [Devices], [50, 75, 100],
    [Energy mix], [_sine wave_ pattern],
    [Topology], [_short-range_ and _cloud_],
    [Time], [720 steps #footnote("We considered 1 step = 1 minute")],
    [Reconf. time], [30 steps],
    [Movement], [Brownian motion],
    [Seed], [0-9]
)
][
  #show figure.caption: set text(size: 0.75em, style: "italic")
  #show figure.caption: it => [ #it.body]
  #figure(
    rect(
      image("images/experimental-setup-example.png", width: 80%),
      stroke: 0.1em + rgb("#eb811b"),
      radius: 0.3em,
      inset: 0.5em,
    ),
    caption: "Example of experimental setup with 100 devices",
  )
]

#pagebreak()

We evaluate two main scenarios:

#components.side-by-side[
  === Device Only

  Scenario acting as a *baseline*

  - Fully _peer-to-peer_ network
  - All the 5 _components_ to the corresponding physical device 
][
  === Placer

  Scenario invoving the *placer*

  - Use of the _cloud_ for offloading
  - Every 30 step, a new *deployment* is computed by the placed
]

Each device has an #bold[energy source mix] following a jittered sine wave as a proxy for a variable energy mix distribution.

== Results -- Energy & Carbon Emissions

Compared to the #bold[baseline] scenario:

- The proposed appraoch achieved *greener* deployments
  - 3 times *less* energy consumption #fa-check-circle()
  - *Less* carbon emissions #fa-check-circle()

Increasing the number of devices, the #bold[baseline] proportionally increase _energy_ and _carbon_ emission, reaching $12 text("kWh")$ with 100 nodes.

The #bold[placer] consume less than $2 text("kWh")$ with 50 nodes, increasing up to $3.5 text("kWh")$ with 100 nodes.

#figure(image("images/Carbon_vs_Energy_perNodes_perStrategy.svg"))

== Results -- Latency

We considered *two* type of _lantecies_:

#components.side-by-side[
  === Intra-component latency
  #figure(image("images/intra-latency.svg", width: 80%))

][
  === Inter-device latency
  #figure(image("images/inter-latency.svg", width: 80%))
]

// - #bold[Inter-device latency]: latency experienced by the #math.mono("C") component to communicate with neighboring digital devices
// - #bold[Intra-component latency]: latency experienced by a single _digital device_ to reach its five components (may offloaded to other physical devices)

Compared to the #bold[baseline] scenario:
- The #bold[placer] achieved *good* result in terms of latency:
  - Slight #text(fill: red, weight: "bold")[increase] in the _intra-components_ latency --- but *under control* #fa-tilde(solid: true, size: 1.5em)
  - *Similar* (or even _less_) _intra-device_ latency  #fa-check-circle()
// - The inter-device latency is proportional to the distance between devices
// - With pulverized deployment, *higher* intra-component latency expected
// - But inter-device latency is expected to be *similar* or even *lower*

The placer achieve *locally-preserving placements* keeping under control _intra-component_ latencies. 

#figure(image("images/IntraLatency_vs_InterLatency_perNodes_perStrategy.svg"))

= Conclusions

== Concluding Remarks

- We proposed *DePPS* a prolog-based planner integrated in Alchemist to evaluate deployment for _pulverized systems_
- We evaluate _DePPS_ with different simulates scenarios showing its ability to provide *greener* deployments with *low energy* consumption
- We provide a *reusable toolchain* for reproducing the experiments, and possibily assessing different kind of deployments

== Future work

- #bold[Continuous reasoning]: consider only *changes in the network* instead of re-applying the reasoner
- #bold[Decentralized placement]: current approach assumes a _centralized reasoner_ considering an up-to-date infrastructure view. An inprovement could consider multiple reasoners to focus on a *small part of the system*.
- #bold[End-to-end simulatio models]: consider (re-)configuration overhead and convergence time
- #bold[Generalization of rules]: The current placer provides a deployment plan as output. An alternative is to generate local deployment rules, instructing individual devices.

#focus-slide[*Thank you*]



// #slide[
//   #bibliography("bibliography.bib")
// ]
