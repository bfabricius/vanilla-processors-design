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
%     * Neither the name of {{ project }} nor the names of its contributors
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









af=1.5;


n=2.5;


N=length(y);
X_mags=abs(fft(x));
Y_mags=abs(fft(y));
bin_vals=[0:N-1];




xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)');
title('FFT of the pure sine input (Hertz)');
axis tight;


%plot(fax_Hz(1:N_2), Y_mags(1:N_2), 'r');
%xlabel('Frequency (Hz)');
%ylabel('Magnitude');
%title('Single-sided Magnitude spectrum (Hertz)');
%axis tight;

%plot(fax_Hz(1:N_2), 10*log10(Y_mags(1:N_2)));

semilogx(fax_Hz(20:N_2), 10*log10(Y_mags(20:N_2)));
xlabel('Frequency (Hz)');

title('FFT of the diode-clipped sine output (Hertz)');

grid on;