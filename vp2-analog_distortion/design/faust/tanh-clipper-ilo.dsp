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

declare name "ds1-diode-clipper-ilo";
declare version "0.1";
declare author "Benjamin Fabricius";
declare description "Example of using infinite linear oversampling for waveshaping.";

import("stdfaust.lib");
import("maths.lib");

// note: in order for this example to be easy to implement we assume that
// the ds1-clipper we have developed by modelling the boss ds-1 clippoing circuit
// is replace with a hyperbolic tangent clipping function.
// this clipping non-linearity is easier to integrate, which needs to be done
// in order to use infinit linear oversampling.
// this waveshaping function is not as exact a model of the original circuit but
// has a similar characteristic.
// we continue to refer to our clipping function as ds1clp for arguments sake.

constant = environment {
    thresh = 0.00001;
};

// the naive clipping non-linearity, no oversampling
ds1clp(x) = tanh(x);

// for infinite linear oversampling to work we need to integrate
// our waveshaping function
ds1clp_int(x) = (exp(-x) + exp(x)) : *(1/2) : log;

// with the integral we can find an infinite number of clipped valued between
// two discrete sample n and n-1 by subtracting the integrals for both n and n-1
// from each other
// finally we can average over all points by differntiating which is done by
// dividing by the difference of dsclp(n) and dsclp(n-1)
ds1clp_ilo_integraldiff(x) = x <: ds1clp_int, (mem : ds1clp_int) : -;
ds1clp_ilo_diff(x) = x <: ds1clp,(mem : ds1clp) : -;
ds1clp_ilo(x) = x <: ds1clp_ilo_integraldiff,ds1clp_ilo_diff : /;

comp = (ds1clp_ilo_diff : abs) < constant.thresh;
// ds1clp_ilo_sel(x) = select2(comp, ds1clp_ilo(x), ds1clp(x));
ds1clp_ilo_sel(x) = select2(comp(x), ds1clp_ilo(x), ds1clp(x));

// the dsclipper expects a pregain and a dc offset that can be applied to
// the input signal.
// after pregain and offset stage, we clip the signal at full range of 1./-1.
// before processing it with our non linear model of the ds1 clipping stage
ds1clipper_ilo(drive,offset) = *(pregain) : +(offset) : clip(-1,1) : ds1clp_ilo_sel
with {
    pregain = pow(10.0,2*drive);
    clip(lo,hi) = min(hi) : max(lo);
    postgain = max(1.0,1.0/pregain);
};

// the dsclipper expects a pregain and a dc offset that can be applied to
// the input signal.
// after pregain and offset stage, we clip the signal at full range of 1./-1.
// before processing it with our non linear model of the ds1 clipping stage


// using a dcblocker to remove DC noise (enery around 0-20Hz) that is caused
// when using offsetting the input
// we do not want this low frequency energy as it can cause our output
// to peak considerably higher and the low frequency energy is generally unwanted
// in our output
ds1clipper_ilo_nodc(drive,offset) = ds1clipper_ilo(drive,offset) : fi.dcblocker;

va_ds1clipper_ilo = ba.bypass1(bp, ds1clipper_ilo_nodc(drive:si.smoo,offset:si.smoo))
with{
	cnl_group(x)  = vgroup("BS DS-1 symmetrical diode clipper [tooltip: Reference:
		https://www.htaudio.de]", x);
	bp = cnl_group(checkbox("[0] Bypass [tooltip: When this is checked, the nonlinearity has no effect]"));
	drive = cnl_group(hslider("[1] Drive [tooltip: Amount of distortion]",
		0, 0, 1, 0.01));
	offset = cnl_group(hslider("[2] Offset [tooltip: Brings in even harmonics]",
		0, 0, 1, 0.01));
};

// the overall dsp process is defined here
process = va_ds1clipper_ilo;
