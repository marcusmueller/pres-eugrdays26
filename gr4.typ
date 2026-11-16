#import "eugrdays26.typ": sect, settings
#import "@preview/polylux:0.4.0": *
#show: settings.with(
  title: [GNU Radio 4: Updates, Direction, and Usability.],
  subtitle: [A community roadmap.],
  author: [Marcus Müller],
  presdate: datetime(month: 11, year: 2026, day: 16),
)
#slide[
  #sect[Intro]
  == Overview & Introduction

  - Who am I?
  - Why am I here?
  - No seriously, why am I still here?
]
#slide[
  = Who am I?
  Marcus Müller #link("mailto:mmueller@gnuradio.org")[mmueller\@gnuradio.org]

  - GNU Radio Maintainer 2018 – 2021
  - GNU Radio Maintainer 2025 –
  - Eletrical engineer, communications engineering
  - Terrible nerd

  - Basically raised within the GNU Radio community

]
#slide[
  #sect[Motivation]
  = Why "do" GNU Radio? (Why am I here?)
  - Progress happens where people talk to each other
  - Talking to each other requires a shared model of the world
  - GNU Radio offers this model for SDR applications
    - Adopts the very engineering-typical flow chart approach,
    - but gives flow chart elements a specific form,
    - brings its own _approach_ to solving technical issues

  #sym.arrow GNU Radio serves as a *Lingua Franca* for academic, industrial and hobbyist SDR
]
#slide[
  = Why "do" GNU Radio in the age of AI?

  Reality, whether I like it or not#footnote[As you can probably guess from my heritage, I have qualms about the ethical side of this;
    let's talk about that over dinner.
  ]:
  - AI-assisted or even AI-led coding is widely applied commercially
    - Citing a friend#footnote[Fischer, M. and Müller, M.: "Musings over pizza and beer", Proceedings of Café Kolb, Bretzfeld, November 2026 (unpublished)\
        #v(1em)
      ]:\
      "_A specific solution trumps one that is built atop a framework, as it
      can optimize for the use case. The fact that an open-source framework solves
      the common problems for you stops being an advantage when the solution-generating
      LLM does the same._"
  - GNU Radio is indubitably a framework
  - GR 3's definite shortcomings in performance of solutions to particular  problems
    - _actually_ arises from generality (cache-hostility of worksize-maximizing ring buffer)
]
#slide[
  = Why the hell am I still standing here?
  With cost of code creation#footnote[Not maintenance, stewardship, security implications…#v(1em)] down,\
  knowing *what* to do, and *why* to do it becomes more important than ever
  - Obvious to academic crowds
    - inherently face this problem regularly
    - often more able to choose _what_ to do
  - Commercial: Business goals always defined purpose (_why_)
    - insight that less code that's easy to maintain better creeps back in
    - even when re-generatable at any whim, design choices based on non-software factors (_what_) get lost (even when prompt preserved)
]
#slide[
  = Why the hell am I still standing here?
  "Everyone builds their optimal solution for themselves"
  - ignores the network effect of learning about other people's problems
  - ignores the commercial viability of spending energy of reinventing the wheel
    - as in "CO#sub[2] spent"
    - as in "Software Developers you burn out per year"
    - as in "Effort required for review quality not to drop"
]
#slide[
  = Why the hell am I still standing here?

  - Even LLM code still is better when it adheres to best practices
  - Some people need to _understand_ what they're doing
    - Abstractions are actually fine!
    - But abstractions which you can't meaningfully inspect aren't
  - _Lingua Franca_: Flow Graph still useful for communication of intent and design
  - But communication isn't only point in software design
  - *Your language forms your thoughts* also applies to thinking about approaches
  - Atrophy of your design language #sym.arrow atrophy of your problem analysis

  #show: later
  #v(1em)
  Real strength: *Community*.
]
#slide[
  #sect[GNU Radio 4 progress]
  = GNU Radio 4 Progress Report
  - GNU Radio 4 nears a Release Candidate (RC)
    - After RC, can't break API again
      - "A GNU Radio release needs to be good for the duration of 1 standard PhD"
    - Means RC needs to be useful for broader audience

  Requirements: *GNU Radio brings SDR to the masses*
  - Easy & possible to build. incl. limited resource builders
  - Easy to long-term maintain
  - Packaged or packageable
  - Deployable in educational settings
  - Possible to write bindings for
  - Correct, easy-to-use and fast in real-world scenarios
]
#slide[
  == Ease of Building
  - Split block library from core
    - if every block needs changes in core, clearly not ready
    - test core separately, don't re-test on every added block
  - Supply SDK images
    - A block / OOT developer's job is not to build GNU Radio
]
#slide[
  == Ease of Maintainance
  - Split inherently means that API surface is clear and fixed
  - Super-build resitory #link("https://github.com/gnuradio/gnuradio4")[`gnuradio/gnuradio4`] sees fewer changes
  - Regular _GNU Radio 4 Technical Users Meetings_
  - Establish community stakeholder participation
    - e.g., Jeff Long works on porting GQRX
    - Philip Balister, Toby Flynn on embedded radios
    - Wylie Standage-Beier on OOT infrastructure
    - GSoC offerings (Daniel Estévez et al)
    - Derek maintains example OOT
]
#slide[
  == Packaging
  - SDK, SDK container available
  - OpenEmbedded recipes / layers advancing rapidly
  - Windows installers in the making
  - Debian packaging in the making
    - Priority of attention: Fedora after
  - In contact with other distro maintainers
]
#slide[
  == Educational Deployability
  - high school teacher needs to be able to run this on 30 different notebooks
  - university students need to run this on the cheapest macbook
  - consultants need to run this with 4h forewarning on locked-down, corporate laptops

  GNU Radio 4 already runs in WASM, i.e. VM-in-browser

  Enter: *gr4-studio* #link("https://github.com/gnuradio/gnuradio4-studio")[`gnuradio/gnuradio4-studio`]
]
#slide[
  === Gr4-studio
  #align(center)[#link(
    "https://f004.backblazeb2.com/file/gnuradio4-studio-public/commit/474a45f00c6d5daaf1f4e25d0f956e0cd424dd11/index.html",
  )[#image("gr4-studio.png", fit: "contain", height: 85%)]]
]
#slide[
  === Gr4-studio
  - Runs full GNU Radio in browser
  - Under the hood: RPC to #link("https://github.com/gnuradio/gnuradio4-control-plane")[`gnuradio/gnuradio4-control-plane`]
    - which by default runs within the same browser
  - Zero installation. Point browser at URL of gr4-studio instance and go
  - Implemented via "web-typical" technology
    - Deliberate decision against C++
    - Hope to tap web developer community
]
#slide[
  == Script bindings for GR4
  - "Triumph of TensorFlow"
    - GR3 knew this for about 20 years
    - Winning move is to allow definition of flow in scripting language
    - Community probably cares more about that than about computational performance
  - Problem: GR4 very C++-heavy
    - Much compile-time optimization
    - But also possible to construct flow graphs at run time
  - First step: Python bindings
    - Multiple aproaches
    - Multi-stakeholder multi-approach (Anthony, Wiley, …)
    - control-plane "shows how it's done" for dynamic bindings
]
#slide[
  == Correctness & Performance
  Shout out to Jeff Long (previous GNU Radio 3 maintainer!) for
  - porting GQRX to GR4
  - reporting findings
  - fixing them
  - driving design discussions

  === Ease of use
  - Probably last change before RC: _Settings unification_
    - unifies the interfaces for different settings
    - reduces tag special cases / design assumptions based on problem domain opinions
    - unifies error handling
]
#slide[
  #sect[Direction]
  = Directions: GNU Radio 4
  - GNU Radio 4: move towards stabilization
  - GNU Radio 4.1: informed by community usage, not primarily of "maintainer wishes"
  - GNU Radio 4: drive community usage by more useful modules
    - GQRX
    - Visualizations
    - DVB-S2

  *We're aiming for GNU Radio 4 to become the community-bearing SDR framework of choice, replacing GNU Radio 3.*
]
#slide[
  = Directions: GNU Radio 3
  - GNU Radio 3: Not going away soon (~ 5 years of foreseeable maintenance)
  - GNU Radio 3: Still new developments
    - #link("https://gnuradioworld.com")[GNU Radio World]: GRC-alike, but embeddable in websites, strong educational focus
    - Hardware acceleration buffers: #link("https://github.com/gnuradio/gnuradio/pulls?q=is%3Apr+author%3Awfarah")[`gnuradio/gnuradio` Wael's upstream work]
  - Interoperability: Strong plans for
    - GR4-in-GR3 (simply embed GR4 flow graph in GR3 block)
    - GR3-in-GR4 (extraction of work function, handlers, getters/setters for GR4 block)
  - Backflow of ideas
]
#slide[
  #align(center)[#text(size: 3em, weight: "black")[Questions & Answers#footnote[hopefully!#v(1em)]]]

  #v(10em)
  #align(right)[… thank you for your attention!]
]
