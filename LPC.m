[Y,FS] = audioread('MyVowel.wav',[3000,6000]);
[a,g] = lpc(Y,12)
samples = 1:length(Y);   
t = samples/Fs; 
   
for i=13:3000
    s = 0;
for j=1:12
    s = s + a(j)*Y(i-j);
end
e(i) = Y(i)+s;
end




for i=13:3000
    x = 0;
    for j=1:12
       x=x+ a(j)*Y(i-j);
    end
    resynthesized_speech(i) = -x+e(i-12);
end;
audiowrite('resynthesizedSpeech.wav', resynthesized_speech,10000);




figure;
subplot(2,1,1)
plot(3001:6000,e);
title("residual sequence");

subplot(2,1,2)
plot(3000:6000,Y);
title("original speech signal");
xlabel("sample number");

figure;
subplot(2,1,1)
plot(3001:6000,resynthesized_speech);
title("resynthesized signal");

subplot(2,1,2)
plot(3000:6000,Y);
title("original speech signal");
xlabel("sample number");
