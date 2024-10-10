using Plots

include("devoir1_lib.jl")


fs = 500
seg_l = 128

parts_end, t, signal = init(fs, [35.4, 57, 70])

plot_stats3D([std, var, kurtosis], signal[1:parts_end[1]], seg_l, p_color=:yellow)
plot_stats3D!([std, var, kurtosis], signal[parts_end[1]:parts_end[2]], seg_l, p_color=:green)
plot_stats3D!([std, var, kurtosis], signal[parts_end[2]:parts_end[3]], seg_l)
plot_stats3D!([std, var, kurtosis], signal[parts_end[3]:end], seg_l, p_title="Human signal's features", p_color=:red)
xaxis!("Standard Deviation")
yaxis!("Variance")
zaxis!("Kurtosis")
plot!(size = (600, 600))
