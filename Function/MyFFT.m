function      MyFFT(x,fs)
format short
n=length(x);%采样点个数
a=rms(x)
X = fftshift(fft(x./(n))); %用fft得出离散傅里叶变换
f=linspace(-fs/2,fs/2-1,n);%频域横坐标，注意奈奎斯特采样定理，最大原信号最大频率不超过采样频率的一半
plot(f,abs(X));%画双侧频谱幅度图
xlabel("f/Hz")
ylabel("幅度")
grid on
axis([0,n/2,0,max(abs(X))*1.3])
end