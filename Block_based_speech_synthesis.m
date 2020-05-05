%task 2 and task 3
% task 2.2
clc;
clear;
Fs = 10000;
% get audio samples
[s,Fs]=audioread('MySentence.wav');

L = Fs*0.01;%length of one block;
Total_blocks = length(s)/L;
samples = 1:length(s);
t = samples/Fs;
% calculating LPC parameters for each block
% calculating LPC parameters for each block
for i=1:Total_blocks
    [a(:,i) g(:,i)]=lpc(s((i-1)*L+1:i*L),12);
end

% calculating residual sequence
residual_seq = zeros(length(s),1);
% calculating residual sequence for the first block
for n= 13 : L 
       temp_s = 0;
       for j=1:12
           temp_s = temp_s + a(j,1)*s(n-j);
       end
       residual_seq(n) = temp_s+s(n);
end

% calculating residual sequence for the rest of the block
for i=2:Total_blocks
   for n= (i-1)*L + 1 : i*L 
       temp_s = 0;
       for j=1:12
           temp_s = temp_s + a(j,i)*s(n-j);
       end
       residual_seq(n) = temp_s+s(n);
   end
end

figure;
subplot(2,1,1);
plot(72540:72740,residual_seq(72540:72740))
title('residual sequence');
xlabel('Sample number')
xlim([72540 72740])

subplot(2,1,2);
plot(72540:72740,s(72540:72740));
title('My sentence waveform');
xlabel('Sample number');
xlim([72540 72740])

% resynthesizing the speech signal
resinthesized_sentence = zeros(length(s),1);
% first block resynthesize
for n= 13 : L 
       temp_s1 = 0;
       for j=1:12
           temp_s1 = temp_s1+ a(j,1)*s(n-j);
       end
       resinthesized_sentence(n) = -temp_s1+residual_seq(n);
end

% resynthesizing the remaining blocks
for i=2:Total_blocks
   for n= (i-1)*L + 1 : i*L 
       temp_s1 = 0;
       for j=1:12
           temp_s1 = temp_s1 + a(j,i)*s(n-j);
       end
       resinthesized_sentence(n) = -temp_s1+residual_seq(n);
   end
end
audiowrite('Resynthesized_sentence.wav',resinthesized_sentence,10000);

figure;
subplot(3,1,1)
plot(t,s);
title('original speech');
xlabel("time (in second)");
subplot(3,1,2)
plot(t,resinthesized_sentence);
title('re-synthesized speech');
xlabel("time (in second)");
subplot(3,1,3)
plot(t,residual_seq);
title('residual sequence');
xlabel("time (in second)");


%task 3 block based speech resynthesis
modified_res=residual_seq;
for i=1:Total_blocks
       [B,I]=sort(abs(modified_res((i-1)*L+1:i*L))); 
       modified_res((i-1)*L+I(1:end-20))=0;
end

% resynthisizing the speech signal using K most significant residuals
resinthesized_sentence1 = zeros(length(s),1);
% first block resynthesize
for n= 13 : L 
       temp_s2 = 0;
       for j=1:12
           temp_s2 = temp_s2+ a(j,1)*s(n-j);
       end
       resinthesized_sentence1(n) = -temp_s2+modified_res(n);
end

% resynthesizing the remaining blocks
for i=2:Total_blocks
   for n= (i-1)*L + 1 : i*L 
       temp_s2 = 0;
       for j=1:12
           temp_s2 = temp_s2 + a(j,i)*s(n-j);
       end
       resinthesized_sentence1(n) = -temp_s2+modified_res(n);
   end
end
audiowrite('Re-synthesized_speech_20.wav',resinthesized_sentence1,10000);

figure;
subplot(3,1,1)
plot(t,modified_res);
ylim([-1 1]);
title('modified residual');

subplot(3,1,2)
plot(t,resinthesized_sentence1);
title('synthesized speech using modified residuals');

subplot(3,1,3)
plot(t,s);
title('original sentence');

