using MAT
using Plots, Plots.PlotMeasures
using DSP

include("devoir1_lib.jl")


fs = 500

parts_end, t, signal = init(fs, [35.4, 57, 70])

plotSFTF(signal, t, fs)
