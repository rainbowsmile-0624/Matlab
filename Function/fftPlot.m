function fren=fftPlot(data,fs)

n = length(data);   
y = fft(data); 
                      
fshift = (-n/2:n/2-1)*(fs/n);
yshift = fftshift(y);
plot(fshift,abs(yshift))
xlabel('Frequency (Hz)')
ylabel('Magnitude')

[pks,locs] = findpeaks(abs(yshift));
fren=fshift(max(abs(locs)));