#import "eugrdays26.typ": sect, settings
#import "@preview/polylux:0.4.0": *
#import "@preview/cetz:0.5.2": canvas, draw
#import "@preview/cetz-plot:0.1.4": plot
#show: settings.with(
  title: [What you should know about OFDM],
  subtitle: [An introduction to the method underlying most broadband communication schemes],
  author: [Marcus Müller],
  presdate: datetime(month: 11, year: 2026, day: 17),
)
#slide[
  #sect[The Multipath Channel]
  = Which Problem Are We Solving?

  - People want high _data rates_
  - High data rates means many _symbols_ per second
  - Many symbols per second means _high bandwidth_

  So where's the problem?
]
#slide[
  == The Multipath Channel

  - signal takes more than a single path
  - even simplifying assumption that it's discrete paths: many of them!

  Is there a problem with multipath?\
  _Inter-symbol-Interference_ (ISI) (blackboard: pulse train, delayed pulse train)
  #only(2)[
    #canvas({
      import draw: *
      plot.plot(
        size: (14, 6),
        x-min: -4 * calc.pi,
        x-max: 4 * calc.pi,
        x-tick-step: calc.pi,
        x-format: plot.formats.multiple-of,
        y-min: -1.5,
        y-max: 1.5,
        y-tick-step: 1,
        {
          plot.add(
            calc.sin,
            domain: (-4 * calc.pi, 4 * calc.pi),
            samples: 250,
            label: $sin (x)$,
          )
        },
      )
    })]
  #only(3)[
    #canvas({
      import draw: *
      plot.plot(
        size: (14, 6),
        x-min: -4 * calc.pi,
        x-max: 4 * calc.pi,
        x-tick-step: calc.pi,
        x-format: plot.formats.multiple-of,
        y-min: -1.5,
        y-max: 1.5,
        y-tick-step: 1,
        {
          plot.add(
            calc.sin,
            domain: (-4 * calc.pi, 4 * calc.pi),
            samples: 250,
            label: $sin (x)$,
          )
          plot.add(
            x => calc.sin(x - 0.95 * calc.pi),
            domain: (-4 * calc.pi, 4 * calc.pi),
            samples: 250,
            label: $sin (x-0.95 dot pi)$,
          )
        },
      )
    })]
  #only(4)[
    #canvas({
      import draw: *
      plot.plot(
        size: (14, 6),
        x-min: -4 * calc.pi,
        x-max: 4 * calc.pi,
        x-tick-step: calc.pi,
        x-format: plot.formats.multiple-of,
        y-min: -1.5,
        y-max: 1.5,
        y-tick-step: 1,
        {
          plot.add(
            calc.sin,
            domain: (-4 * calc.pi, 4 * calc.pi),
            samples: 250,
            label: $sin (x)$,
          )
          plot.add(
            x => calc.sin(x - 0.95 * calc.pi),
            domain: (-4 * calc.pi, 4 * calc.pi),
            samples: 250,
            label: $sin (x-0.95 dot pi)$,
          )
          plot.add(
            x => calc.sin(x) + calc.sin(x - 0.95 * calc.pi),
            domain: (-4 * calc.pi, 4 * calc.pi),
            samples: 250,
            label: $sin(x) + sin (x-0.95 dot pi)$,
          )
        },
      )
    })]
  #only(5)[
    #align(center)[*But wait!*]\
    It gets worse!
  ]
  #only(6)[
    #canvas({
      import draw: *
      plot.plot(
        size: (14, 6),
        x-min: -4 * calc.pi,
        x-max: 4 * calc.pi,
        x-tick-step: calc.pi,
        x-format: plot.formats.multiple-of,
        y-min: -1.5,
        y-max: 1.5,
        y-tick-step: 1,
        {
          plot.add(
            x => calc.sin(1.3 * x),
            domain: (-4 * calc.pi, 4 * calc.pi),
            samples: 250,
            label: $sin (1.3 dot x)$,
          )
          plot.add(
            x => calc.sin(1.3 * (x - 0.95 * calc.pi)),
            domain: (-4 * calc.pi, 4 * calc.pi),
            samples: 250,
            label: $sin (1.3 dot (x- 0.95 dot pi))$,
          )
          plot.add(
            x => calc.sin(1.3 * x) + calc.sin(1.3 * (x - 0.95 * calc.pi)),
            domain: (-4 * calc.pi, 4 * calc.pi),
            samples: 250,
            label: $sin(1.3 dot x) + sin (1.3 dot (x-0.95 dot pi))$,
          )
        },
      )
    })]
  #only(7)[
    #canvas({
      import draw: *
      plot.plot(
        size: (14, 6),
        x-min: -4 * calc.pi,
        x-max: 4 * calc.pi,
        x-tick-step: calc.pi,
        x-format: plot.formats.multiple-of,
        y-min: -1.5,
        y-max: 1.5,
        y-tick-step: 1,
        {
          plot.add(
            x => calc.sin(1.8 * x),
            domain: (-4 * calc.pi, 4 * calc.pi),
            samples: 250,
            label: $sin (1.8 dot x)$,
          )
          plot.add(
            x => calc.sin(1.8 * (x - 0.95 * calc.pi)),
            domain: (-4 * calc.pi, 4 * calc.pi),
            samples: 250,
            label: $sin (1.8 dot (x- 0.95 dot pi))$,
          )
          plot.add(
            x => calc.sin(1.8 * x) + calc.sin(1.8 * (x - 0.95 * calc.pi)),
            domain: (-4 * calc.pi, 4 * calc.pi),
            samples: 250,
            label: $sin(1.8 dot x) + sin (1.8 dot (x-0.95 dot pi))$,
          )
        },
      )
    })]
]
#slide[
  = Multipath: Time & Frequency Domain

  - _Delay spread_ in multipath leads to symbols overlapping following symbols
  - inevitably, this must come with _frequency selectiveness_

  Why am I telling you about frequency selectiveness?

  - _Tapped Delay Line Model_ (blackboard)
]
#slide[
  = What to Do about the Problem?

  "Revert" it:
  - This is called an _equalizer_ (fr: _Égaliseur_, fi: _taajuuskorjain_, de: _Entzerrer_), because it "fixes"\
    the inequality between frequency (de: it de-distorts)
  - many approaches, among these
    - _zero-forcing EQ_: build filter, inverse in amplitude and phase (in general becomes infinitely complex)
      - uuuuh what happens to noise at the frequencies you basically delete??
    - _decision-feedback EQ_: take the first thing coming out of channel, figure out what it was, find how much that influences second, subtract, \
      find second original, figure out how first and second affect third… and so
      - uuuhh what happens when you make a mistake in the first?
    - and many more…
  - all of these approaches are computationally complex and have sad properties w.r.t. errors
]
#slide[
  = What to Do about the Problem?

  OK, what about making it go away?

  - Send symbols only at much lower rate
  - Delayed Echos come "within" the gap between samples \
    #sym.arrow no problem in time domain
  - Lower symbol rate \
    #sym.arrow lower bandwidth \
    #sym.arrow smaller difference between highest and lowest frequency \
    #sym.arrow low difference between "strongest" and "weakest" frequency\
    #sym.arrow no problem in time domain

  Fine and dandy. But what about symbol rate?
  - yeah that drops by the same factor we're reducing symbol rate

]
#slide[
  == Multi-carrier Systems

  - we reduced bandwidth, so we could just put proprtionally more of the same on the RF
  - summa summarum, same datarate

  The catch?
  - still need to figure out phase, amplitude for each channel
  - individual channels might be very weak
    - would be nice having error correction over all channels
    - but then, not really independent channels
  - if we do $N$ channels, we simply get $N$ times the effort
]
#slide[
  == 1 Step back: Can I See the Tapped-delay Line Model, Again?

  #context {
    let taps = 5
    let dx = 2.8
    let x-pos(k) = k * dx

    // explicit text(size:) — see the freeze note below
    let gain-label(k) = text(size: 0.7em, [$h_#k$])
    let lw = measure(gain-label(0)).width // canvas units == cm by default

    let tri-w = calc.max(1.3cm, 2.4 * lw)
    let tri-h = tri-w

    let y-wire = 0cm
    let y-base = -1.4cm
    let y-apex = y-base - tri-h
    let y-label = y-base - tri-h / 3
    let y-bus = y-apex - 0.7cm

    canvas({
      import draw: *

      for k in range(taps) {
        circle(
          (x-pos(k), y-wire),
          radius: 0.08,
          fill: black,
          name: "tap" + str(k),
        )
      }

      for k in range(taps - 1) {
        let x = x-pos(k)
        line((x, y-wire), (x + 0.55, y-wire), mark: (end: ">"))
        rect((x + 0.55, y-wire - 0.45cm), (x + 2.05, y-wire + 0.45cm))
        content((x + 1.3, y-wire), $z^(-1)$)
        line((x + 2.05, y-wire), (x + dx, y-wire), mark: (end: ">"))
      }

      content((-1.8, y-wire), [$x[n]$], name: "xn")
      line("xn", "tap0", mark: (end: ">"))

      let sum-x = x-pos(taps - 1) + 2.4
      content((sum-x, y-wire), [Σ], frame: "circle", padding: 0.12, name: "sum")
      content((sum-x + 2.0, y-wire), [$y[n]$], name: "yn")
      line("sum.east", "yn", mark: (end: ">"))
      line("tap" + str(taps - 1), "sum.west", mark: (end: ">"))

      for k in range(taps) {
        let x = x-pos(k)
        line((x, y-wire), (x, y-base), mark: (end: ">"))
        line(
          (x * 1cm - tri-w / 2, y-base),
          (x * 1cm + tri-w / 2, y-base),
          (x, y-apex),
          close: true,
        )
        content((x, y-label), gain-label(k))
        line((x, y-apex), (x, y-bus), mark: (end: ">"))
      }

      line((x-pos(0), y-bus), (sum-x, y-bus), "sum.south", mark: (end: ">"))
    })
  }
  Hm, what's the mathematical operation here?

  - It's a convolution: \
    $y[n] &= h[0] dot x[n] + h[1]dot x[n-1] + h[2]dot x[n-2] + h[3] dot x[n-3] dot h[4] dot x[n-4] \
    &= limits(sum)_(ell=0)^4 h[ell]dot x[n-ell]$
  - Oh fun, it's a convolution! Seriously!
  - We know what to do with a convolution

]
#slide[
  == Fourier Transform & Convolution
  Electrical engineers just Fourier-transform everything
  #image("xkcd.jpg", height: 70%)
  Source xkcd \#26, #link("https://xkcd.com/26/")
]
#slide[
  == Fourier Transform & Convolution
  Fourier transform convolution property: \
  $cal(F)(a*b) = cal(F)(a) dot cal(F)(b),$\
  with $*$ being the convolution operator.

  Ideas what we can build out of that?
]
#slide[
  == Discrete Fourier Transform vs continuous Fourier transform
  #table(
    columns: (0.4fr, 1fr, 1fr),
    row-gutter: 1.5em,
    stroke: none,
    [], [Continuous Fourier transform], [Discrete Fourier transform],
    [formula],
    [
      $cal(F){x(t)}(f) = limits(integral)_(-infinity)^(+infinity) x(tau) e^(-j 2 pi dot tau dot f) d tau$],
    [$"DFT"(bold(x))[n] = limits(sum)_(m=0)^(N-1) v[m] dot e^(-j 2 pi dot m/N dot n)$],

    [convolution theorem],
    [$cal(F){x*h}(f) = cal(F){x}(f) dot cal(F){h}(f),$],
    [$"DFT"(bold(x) limits(*)_"circ" bold(h)) = "DFT"(bold(x)) limits(dot)_"e-wise" "DFT"(bold(h))$],
  )

  uh, what's that $limits(*)_"circ"$ in there?

  #show: later
  *Circular convolution* (blackboard)
]

#slide[
  == Circular convolution vs Reality

  - Our tapped delay-line channel does "straightforward" (acyclic) convolution!
  - So we fake it!

  #sym.arrow prepend end of $bold(v)$ before beginning, so that it sounds like the "echos" of the end overlap the beginning\
  _Cyclic Prefix_ (CP)

  How much do we prepend?
  - The delay spread, so that all the echos are there, so the CP is actually lost for data transmission
]
#slide[
  #sect[Implementation]
  = The OFDM transmitter
  How do we transmit that?
  (blackboard)

  #show: later
  Waaaaaait a second… \
  That's a multi-carrier system, with frequencies $0 dot 1/N, 1 dot 1/N dots (N-1) dot 1/N$?!

  Exactly! But it's not just *some* multi-carrier system!
]
#slide[
  = The OFDM receiver
  How do we receive that?
  (blackboard)
  1. receive $N + l_"CP"$ samples, call it $bold(u)$
  2. throw away $l_"CP"$ first values from $bold(u)$. Call the rest $bold(v)$.
  3. $bold(V) = "DFT"(bold(v))$, finally
  4. $hat(bold(T)) = bold(V) dot_"element-wise" bold(H)^(-1)$, the estimate of the transmitted symbols
]

#slide[
  == How do we get the inverse ("cyclified") channel estimate?

  Typically, by sending a preamble symbol
  - you know what you put in, $T$
  - you get something else out, $V$
  - you divide $bold(V) limits(:)_("e-w") bold(T)=hat(bold(H))$
]
#slide[
  #sect[Observations]
  = Observations about this Method
  == Sub-carrier Orthogonality
  - Mathematically: look at the DFT,\
    $"DFT"(bold(x))[n] = limits(sum)_(m=0)^(N-1) v[m] dot e^(-j 2 pi dot m/N dot n)$
    - $n$ behaves as "discretized frequency"
    - if $v[n] = e^(j 2 pi k/N dot n)$ itself, then
      - of that sum above the where $m=k$, you get $N$ summands of $e^(0)=1$,
      - for every other $m$, you get an oscillation at frequency $k-m mod N$, \
        i.e. something that, when summed up, is 0

  *#sym.arrow Orthogonality* of these sub-carriers
]
#slide[
  == Sub-carrier Shape

  - Sub-carriers in this multi-carrier system _tightly_ packed
  - In fact, doesn't get tighter: $N$ sub-carrier carrying $1/N$ of the overall symbol rate

  #v(1em)
  Shape of that sub-carrier?
  - Sinc, because $cal(F)$ of rectangle (blackboard)
]
#slide[
  #sect[Discussion]
  = Discussion: Effect of Frequency Error

  - Not hitting the nulls of the sincs #sym.arrow _Inter-Carrier Interference_ (ICI)\
    (blackboard)
  - Thus, need for good _fine-frequency estimation_
  - Thus, sensitive to Doppler!
  - Limits how long the symbol can become
    - If Doppler shift changes, we're hosed
]
#slide[
  = Discussion: Design Parameters
  - $l_"CP"$: Cyclic prefix length\
    Defined by channels's delay spread
  - $N$: DFT length
    - time-domain view: have to choose $N$ high enough, to get rid of ISI on the sub-carriers
    - frequency-domain view: need to split full bandwidth into many sub-bands that are "approximately flat" (blackboard)
    - want to choose $N$ high, so that overhead $l_"CP"/N$ becomes small
    - limited coherency time (time for which the channel stays the same, linked to Doppler spread)
]
