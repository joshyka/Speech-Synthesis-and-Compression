clc;
clear;
Fs = 10000;
L = Fs*0.01;

[s,Fs]=audioread('MySentence.wav');
Total_blocks = length(s)/L;
% calculating LPC parameters for each block
for i=1:Total_blocks
    [a(:,i) g(:,i)]=lpc(s((i-1)*L+1:i*L),12);
end
% task 5.1 compute power spectrum
for i=1:Total_blocks
    %fs = 10000;
    fm = 1:Fs/2;
    wm = 2*pi*fm/Fs;
    f_sum = zeros(1,length(wm));
    for j=1:12
       f = a(j,i)*exp(-1j*wm*j);
       f_sum = f_sum + f;
    end
   magnitude_spectrum(i,:) = 1./abs(f_sum);
   
   power_spectra_1(i,:) = abs(magnitude_spectrum(i,:)).^2;
   
end

 %power_spectra of synthetic speech
 [s1,Fs]=audioread('Re-synthesized_speech_20.wav');
 for i=1:1500
     [a1(:,i),g1(:,i)] = lpc(s1((i-1)*L+1:i*L),12);
 end
 
 for i=1:Total_blocks
    f_sum1 = zeros(1,length(wm));
    for j=1:12
       f1 = a1(j,i)*exp(-1j*wm*j);
       f_sum1 = f_sum1 + f1;
    end
   magnitude_spectrum1(i,:) = 1./abs(f_sum1);
   
   power_spectra_2(i,:) = abs(magnitude_spectrum1(i,:)).^2;
   
end
 figure;
 plot(wm,power_spectra_1(1334,:))
 hold on;
 plot(wm,power_spectra_2(1334,:))
 title("power spectra");
 legend("original","synthesized");
 xlabel ('discrete frequency(in radians)')
 ylabel('Amplitude');
 
 %task 5.2 compute average distortion
 for i = 1:Total_blocks
     b_sum = 0;
     for m=1:length(wm)
         b_sum = b_sum + 10*log10(abs(magnitude_spectrum(i,m)-magnitude_spectrum1(i,m)).^2);
     end
     d(i) = b_sum/length(wm);
 end
 
 figure;
plot(1:Total_blocks,d);
title 'distortion of each block for P=12'
xlabel ('Blocks Number'),ylabel 'Amplitude(dB)'

 