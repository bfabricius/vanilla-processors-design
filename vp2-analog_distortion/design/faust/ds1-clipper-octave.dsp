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

declare name "ds1-diode-clipper";
declare version "0.1";
declare author "Benjamin Fabricius";
declare description "Simple VA-model of the Boss DS-1 dual-clipper distortion circuit.";

import("stdfaust.lib");

// the dsclipper expects a pregain and a dc offset that can be applied to
// the input signal.
// after pregain and offset stage, we clip the signal at full range of 1./-1.
// before processing it with our non linear model of the ds1 clipping stage
ds1clipper(drive,offset) = *(pregain) : +(offset) : clip(-1,1) : ds1clp
with {
    pregain = pow(10.0,2*drive);
    clip(lo,hi) = min(hi) : max(lo);
    // ds1clp is our non-linear clipping function (aka. the va model we developed)
    ds1clp(x) = x / (1+abs(x)^2.5)^(1/2.5);
    postgain = max(1.0,1.0/pregain);
};

// using a dcblocker to remove DC noise (enery around 0-20Hz) that is caused
// when using offsetting the input
// we do not want this low frequency energy as it can cause our output
// to peak considerably higher and the low frequency energy is generally unwanted
// in our output
ds1clipper_nodc(drive,offset) = ds1clipper(drive,offset) : fi.dcblocker;

// the overall dsp process is defined here
// run a ramp into the ds1clipper

O  = hslider("offset",0,0,1.0,0.01);
D  = hslider("distortion [midi: ctrl 0x70]",0,0,1.0,0.01);

// distortion = ds1clipper(D,O); // effect.lib
distortion = ds1clipper(0,0.9); // effect.lib

// process = ramp(0.01) : -(1.5) : distortion
// with {
//   integrator = + ~ _ ;
//   ramp(slope) = slope : integrator - 2.0;
// };


process = os.oscsin(400) : distortion;
