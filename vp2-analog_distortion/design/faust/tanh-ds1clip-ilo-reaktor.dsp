// Copyright (c) 2018, Benjamin Fabricius <ben@htaudio.de>
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
//     * Redistributions of source code must retain the above copyright notice,
//       this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright notice,
//       this list of conditions and the following disclaimer in the documentation
//       and/or other materials provided with the distribution.
//     * Neither the name of vanilla-processors nor the names of its contributors
//       may be used to endorse or promote products derived from this software
//       without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

declare name "ds1-diode-clipper-ilo-reaktor";
declare version "0.1";
declare author "Benjamin Fabricius";
declare description "Example of using infinite linear oversampling for waveshaping.";

import("stdfaust.lib");
import("maths.lib");

// note: the ds-1 clipping model is replaced with a similar clipping function
// for this example design.
// the virtual analog model apporximation derived for the ds-1 clipper is non-
// trivial to integrate, which makes using it for ILO anti-aliasing difficult.

// constants env
constant = environment {
    thresh = 0.00001;
};

// the naive clipping non-linearity, no oversampling
ds1clp = tanh;

// the integral of tanh x -> int tanh(x) dx => logn(cosh(x)) + constant (<- const neglected)
int_ds1clp = cosh : log;

// now we need a differentiator that implements ILO and also checks
// for divisions by zero. in that case we switch the output to the ds1clp naive
// waveshaper instead
// i/o: 4 inputs, 1 output
// i1: xs: audio input
// i2: fx: the naive waveshaping expression
// i3: int_fx: the integrated naive waveshaper
// i4: thresh: a small threshold to check again divisions by zero (e.g. .00001)
differentiator(xs, fx, int_fx, thresh) = select2(comp(xs,thresh), (nom(int_fx),den(xs) : /), fx)
with {
  nom(integralx) = integralx,(integralx : mem) : -;
  den(xs) = xs,(xs : mem) : -;
  comp(xs,t) = (xs,(xs : mem) : - : abs), t : >;
};

// the waveshaper fx
// i/o: 1 inp, 1 outp
// i1: xs: audio input
waveshaper(xs) = xs, (xs : ds1clp), (xs : int_ds1clp) ,0.0001 : differentiator;

// simple amplifier stage using a ui slider to setup the amount of amplification
// min: 0, max: 64.0, step: 0.01
// i/o; 1 inp, 1 outp
amp = hslider("Ampl.", 0 , 0 , 1, 0.01) : *(64) : si.smoo;

// main dsp process
process = _ : *(amp) : waveshaper;
