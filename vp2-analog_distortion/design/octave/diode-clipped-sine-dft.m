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
fnyquist=Fs/2;
%input sine at 10Hz
f=400;
x=sin(2*pi*f*t);
% amplify input by factor 5
af=1.5;
x=af*x;
% clipped output
n=2.5;
y=x./(1+abs(x).^n).^(1/n);
% plot the dft
N=length(y);
X_mags=abs(fft(x));
Y_mags=abs(fft(y));
bin_vals=[0:N-1];
fax_Hz=bin_vals*Fs/N;
N_2=ceil(N/2);
subplot(1,2,1);
semilogx(fax_Hz(20:N_2), 10*log10(X_mags(20:N_2)));
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title('FFT of the pure sine input (Hertz)');
axis tight;
grid on;
% single sided dft magnitudes in hertz
%plot(fax_Hz(1:N_2), Y_mags(1:N_2), 'r');
%xlabel('Frequency (Hz)');
%ylabel('Magnitude');
%title('Single-sided Magnitude spectrum (Hertz)');
%axis tight;
% single sided dft magnitude spectrum in decibels and hertz
%plot(fax_Hz(1:N_2), 10*log10(Y_mags(1:N_2)));
subplot(1,2,2);
semilogx(fax_Hz(20:N_2), 10*log10(Y_mags(20:N_2)));
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title('FFT of the diode-clipped sine output (Hertz)');
axis tight;
grid on;
