%% Audio Filter Using the Fast Fourier Transform (FFT)
% The Fast Fourier Transform is used for filtering and signal compression.
% Here we look at an example of a using the FFT to filter out static.

%% Making a sound
% First we choose some frequencies and play some notes through our speakers
% using MATLAB

InitializeWorkspaceDisplay %initialize the workspace and the display parameters
tic
freq = [261.63 277.18 293.66 311.13 329.63 349.23 369.99 392.00 415.30 ...
   440.00 466.16 493.88]; %the frequencies of middle C and semi-tones 
Fs = 2^15; %sampling frequency
t = 0:1/Fs:1-1/Fs; %a vector of times
n = numel(t); %number of time values
Cnote = sin(2*pi*freq(1)*t); %Middle C
Enote = sin(2*pi*freq(5)*t); %E above middle C
Gnote = sin(2*pi*freq(8)*t); %G above middle C
Major5th = (Cnote+Gnote)/2; %major 5th
Major3rd = (Cnote+Enote)/2; %major 3rd
MajorChord = (Cnote+Enote+Gnote)/3; %major 3rd
sound(Cnote,Fs) %play a sound
disp('Press <Enter> to continue'); pause
sound(Enote,Fs) %play a sound
disp('Press <Enter> to continue'); pause
sound(Gnote,Fs) %play a sound
disp('Press <Enter> to continue'); pause
sound(MajorChord,Fs) %play a sound

%% Looking at the Spectrum of the Sound
% Next we look at the Fourier decomposition of the C note using the FFT and
% plot the Fourier coefficients on a semi-log scale.

FFTCnote = fft(Cnote); %Fourier coefficients of the pure note
freqvec = -n/2:n/2-1; %values of the frequency
figure
semilogy(freqvec,abs(FFTCnote([n/2+1:n 1:n/2])))
axis([-Fs/2 Fs/2 1e-2 1e5])
xlabel('frequency')
ylabel('magnitude')
print -depsc CnoteSpectrum.eps
figure
semilogy(freqvec,abs(FFTCnote([n/2+1:n 1:n/2])))
axis([-400 400 1e-2 1e5])
xlabel('frequency')
ylabel('magnitude')
print -depsc CnoteSpectrumUpclose.eps

%% Add Some Static
% Now we add some static to the C note and plot its spectrum.

noisyC = Cnote+0.05*randn(size(t)); %random noise
sound(noisyC,Fs) %sounds like this
FFTnoisyC = fft(noisyC); %Fourier coefficients of the noisy C
figure
semilogy(freqvec,abs(FFTnoisyC([n/2+1:n 1:n/2])),'b')
axis([-Fs/2 Fs/2 1e-2 1e5])
xlabel('frequency')
ylabel('magnitude')
print -depsc NoisyCSpectrum.eps
figure
semilogy(freqvec,abs(FFTnoisyC([n/2+1:n 1:n/2])),'b')
axis([-400 400 1e-2 1e5])
xlabel('frequency')
ylabel('magnitude')
print -depsc NoisyCSpectrumUpclose.eps

%% Filter out the static
% Finally we filter out the static using a low pass filter and lay the
% restored C note.

filter = ones(1,n);
filter(601:n-599) = 0; %low pass filter
FFTfilterednoisyC = FFTnoisyC.*filter; %filtered spectrum
figure
semilogy(freqvec,abs(FFTfilterednoisyC([n/2+1:n 1:n/2])),'b')
axis([-Fs/2 Fs/2 1e-2 1e5])
xlabel('frequency')
ylabel('magnitude')
print -depsc FilteredCSpectrum.eps
figure
semilogy(freqvec,abs(FFTfilterednoisyC([n/2+1:n 1:n/2])),'b')
axis([-400 400 1e-2 1e5])
xlabel('frequency')
ylabel('magnitude')
print -depsc FilteredCSpectrumUpClose.eps
filterednoisyC = ifft(FFTfilterednoisyC);
sound(filterednoisyC,Fs) %restored C note

%%
% _Author: Fred J. Hickernell_


