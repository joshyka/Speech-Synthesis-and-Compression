clc;
clear all;

Fs = 10000;

% get audio samples
[s,Fs]=audioread('MySentence.wav');
L = Fs*0.01;%length of one block;
Total_blocks = length(s)/L;
for i=1:Total_blocks
    xi = s((i-1)*L + 1 : i*L);
    xi = xi.*hamming(length(xi));
    y = [xi;zeros(10*length(xi),1)];
    ceptrum(:,i) = abs(ifft(log(abs(fft(y)))));
end
    

figure, hold; 
c = 0.2;
for i=348:368
    c2=ceptrum(:,i) + i*c; 
    plot(c2);
    xlabel("frequency");
end 