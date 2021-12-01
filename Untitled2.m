function fftPlot(data,fs)


plot(1:length(data),data)

y = fft(data); 

f = (0:length(y)-1)*fs/length(y);

n = length(x);                         
fshift = (-n/2:n/2-1)*(fs/n);
yshift = fftshift(y);
plot(fshift,abs(yshift))
xlabel('Frequency (Hz)')
ylabel('Magnitude')

[pks,locs] = findpeaks(abs(yshift))
fshift(locs)