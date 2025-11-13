# Simple tests for an fir_filter module
import cocotb
import random
from cocotb.clock import Clock
from cocotb.triggers import Timer
from cocotb.triggers import RisingEdge
from scipy.signal import lfilter
import numpy as np
import matplotlib.pyplot as plt

# as a non-generator
def wave(amp, f, fs, clks): 
    clks = np.arange(0, clks)
    sample = np.rint(amp*np.sin(2.0*np.pi*f/fs*clks))
    return sample

def predictor(signal,coefs):
    output = lfilter(coefs,1.0,signal)
    return output

@cocotb.test()
async def filter_test(dut):
    #initialize
    dut.data_in.value = 0
    fs       = 1
    amp0     = 80
    num_clks = 512
    nfft     = num_clks; 
    f0       = 50*(1.0/nfft)
    coefs    = np.array([-1., -7., -4.,  4., 18., 32., 38., 32., 18.,  4., -4., -7., -1.])
    cnt      = 0

    # input data
    input_signal = wave(amp0, f0, fs,num_clks) + wave(amp0/2, 200.5*(1.0/nfft), fs, num_clks)

    # bit accurate predictor values
    data_out_pred = predictor(input_signal, coefs)

    # start simulator clock
    cocotb.start_soon(Clock(dut.clk, 1, units="ms").start())

    # Reset DUT
    dut.reset.value = 1
    await RisingEdge(dut.clk)
    dut.reset.value = 0

    output_signal = np.zeros(num_clks)

    # run through each clock
    for samp in range(num_clks):
        await RisingEdge(dut.clk)
        # get the output at rising edge
        dut_data_out = dut.data_out.value.signed_integer

        # feed a new input in
        dut.data_in.value  = int(input_signal[samp])

        output_signal[samp] = dut_data_out

        # wait until reset is over, then start the assertion checking
        if(cnt>=2):
            assert dut_data_out == data_out_pred[cnt-2], "filter result is incorrect: %d != %d" % (dut_data_out, data_out_pred[cnt-2])
        cnt = cnt + 1
    
    in_fft    = np.fft.fftshift(20*np.log10(np.abs(np.fft.fft(input_signal, nfft))))

    out_fft   = np.fft.fftshift(20*np.log10(np.abs(np.fft.fft(output_signal[2:], nfft))))
    pred_fft  = np.fft.fftshift(20*np.log10(np.abs(np.fft.fft(data_out_pred[:-2], nfft))))
    filt_fft  = np.fft.fftshift(20*np.log10(np.abs(np.fft.fft(coefs/sum(coefs), nfft))))

    # normalize FFTs lazy style
    in_fft   = in_fft   - np.max(in_fft)
    out_fft  = out_fft  - np.max(out_fft)
    pred_fft = pred_fft - np.max(pred_fft)
    xaxis    = np.arange(-0.5, 0.5, 1/nfft)

    plt.figure(1)
    plt.subplot(1,2,1)
    plt.plot(output_signal[2:], marker='x')
    plt.plot(data_out_pred[:-2], marker='o')
    plt.legend(['DUT', 'Theory'])
    plt.title('time domain')
    plt.subplot(1,2,2)
    plt.stem(output_signal[2:]-data_out_pred[:-2])
    plt.title('error : DUT - Golden Reference')

    plt.figure(2)
    plt.subplot(2,1,1)
    plt.plot( xaxis, in_fft)
    plt.plot(xaxis, filt_fft)
    plt.title('Input to DUT: Frequency Domain Response')
    plt.subplot(2,1,2)
    plt.plot(xaxis, out_fft, marker='x')
    plt.plot(xaxis, pred_fft, marker='o')
    plt.title('Output of DUT: Frequency Domain Response')
    plt.plot(xaxis, filt_fft)
    plt.grid()
    plt.xlabel('Normalized Frequency')
    plt.ylabel('dB')
    plt.title('Filter Response')
    plt.xlim([-.5, .5])
    plt.legend(['output', 'pred', 'filter'])
    plt.show()
    