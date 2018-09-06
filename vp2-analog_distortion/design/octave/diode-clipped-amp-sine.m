% Copyright (c) 2018, Benjamin Fabricius <ben@htaudio.de>
%
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without modification,
% are permitted provided that the following conditions are met:
%
%     * Redistributions of source code must retain the above copyright notice,
%       this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright notice,
%       this list of conditions and the following disclaimer in the documentation
%       and/or other materials provided with the distribution.
%     * Neither the name of vanilla-processors nor the names of its contributors
%       may be used to endorse or promote products derived from this software
%       without specific prior written permission.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
% "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
% LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
% A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
% CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
% EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
% PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
% PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
% LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
% NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%

clear all;
close all;
clc;
Fs=44100;
Ts=1/Fs;
t=0:Ts:1;
%input sine at 10Hz
f=5;
x=sin(2*pi*f*t);
subplot(1,2,1);
plot(t,x);
xlabel('Time t');
ylabel('Amplitude');
title('Sine at 5Hz');
% amplify input by factor 5
af=4;
x=af*x;
% clipped output
n=2.5;
y=x./(1+abs(x).^n).^(1/n);
subplot(1,2,2);
plot(t,y,'r');
xlabel('Time t');
ylabel('Amplitude');
title('4-time amplified sine at 5Hz after non-linear clipping');
