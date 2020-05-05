myVoice = audiorecorder(10000,16,1);
disp('Start speaking.');
recordblocking(myVoice, 2);
disp('End of recording. Playing back ...');

play(myVoice)
doubleArray = getaudiodata(myVoice);

figure(1)
plot(doubleArray);
title('Audio Signal (double)');
grid

audiowrite('MyVowel.wav', doubleArray,10000);

[Y,FS] = audioread('MyVowel.wav',[3000,6000]);
figure(2)
plot(3000:6000,Y)
audiowrite('MyVowel_3000samples.wav', Y,10000);
title('300ms of audio Signal');
grid






