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

== DePPS

#quote[How can we make collective systems deployments greener while maintaining performance?]

=== Problem statement

- IoT ecosystems and robot swarms need *efficient deployment strategies*
- Current approaches *lack* automated deployment generation
- Need to balance *performance* with environmental *sustainability*

#v(2em)
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


// #slide[
//   #bibliography("bibliography.bib")
// ]
