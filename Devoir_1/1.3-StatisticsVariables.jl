using MAT
using Plots, Plots.PlotMeasures, StatsPlots, PrettyTables
using DSP
using Statistics, Distributions

include("devoir1_lib.jl")


fs = 500
fc_human = 3.91
fc_vib = 24.1
seg_l = 128

parts_end, t, filtered_humansignal, filtered_vibsignal = init(fs, [35.4, 57, 70]; filtered=true, fc_human=fc_human, fc_vib=fc_vib)


hl_human = [1 2 1; 5 1 2]
printStatisticTab(filtered_humansignal, parts_end; p_title="Human signal's features")

hl_vib = [2 2 2; 3 1 5]
printStatisticTab(filtered_vibsignal, parts_end; p_title="Vibration signal's features")

display(stats3D([var, kurtosis, skewness], filtered_humansignal, seg_l, p_title="Human signal's features"))
stats3D([std, kurtosis, var], filtered_vibsignal, seg_l, p_title="Vibration signal's features")
