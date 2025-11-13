import matplotlib.pyplot as plt
import numpy as np
from scipy import signal

cutoff = .1       # Desired passband bandwidth, Hz
trans_width = .1  # Width of transition from pass to stop, Hz
numtaps = 13      # Size of the FIR filter.
fs = 1            # normalized sampling rate

# floating point coefficients 
filter_coefs = signal.remez(numtaps, [0, cutoff, cutoff + trans_width, 0.5*fs],[1, 0], fs=fs)

# 8 bit integer coefficients 
filter_coefs_int = np.round(filter_coefs * (2**7-1))
nfft = 2000; 
print(filter_coefs_int)

x_fft = np.fft.fftshift(20*np.log10(np.abs(np.fft.fft(filter_coefs/np.sum(filter_coefs), nfft))))
xaxis = np.arange(-0.5, 0.5, 1/nfft)

x_fft_int = np.fft.fftshift(20*np.log10(np.abs(np.fft.fft(filter_coefs_int/np.sum(filter_coefs_int), nfft))))

plt.figure(3)
plt.plot(xaxis, x_fft)
plt.plot(xaxis, x_fft_int, linestyle='dashed')
plt.title('real portion of signal x')
plt.grid()
plt.xlabel('Normalized Frequency')
plt.ylabel('dB')
plt.title('Filter Response')
plt.xlim([-.5, .5])
plt.legend(['flating point coefs', '8 bit coefs'])
plt.show()