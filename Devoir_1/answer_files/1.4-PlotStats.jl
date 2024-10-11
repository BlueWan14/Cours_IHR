using Plots

include("devoir1_lib.jl")


fs = 500
seg_l = 128

parts_end, t, signal = init(fs, [35.4, 57, 70])

fct = [kurtosis, rms, (x -> energy(x, fs=fs))]

plot_stats3D(fct, signal[1:parts_end[1]], seg_l, p_color=:yellow)
plot_stats3D!(fct, signal[parts_end[1]:parts_end[2]], seg_l, p_color=:green)
plot_stats3D!(fct, signal[parts_end[2]:parts_end[3]], seg_l)
# plot_stats3D!(fct, signal[parts_end[3]:end], seg_l, p_title="Human signal's features", p_color=:red)
xaxis!("Kurtosis")
yaxis!("RMS")
zaxis!("Energy")
display(plot!(size = (600, 600)))

human = Dict(fct[2] => .04, fct[3] => .002)
scatter(isHuman(human, signal, seg_l))