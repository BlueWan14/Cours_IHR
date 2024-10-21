using Plots

include("devoir1_lib.jl")


fs = 500
seg_l = 128

parts_end, t, signal = init(fs, [35.4, 57, 70])

fct = [kurtosis, rms, (x -> energy(x, fs=fs))]
fctVib = [std, (x -> energy(x, fs=fs)), kurtosis]

p1 = plot_stats3D(fct, signal[1:parts_end[1]], seg_l, p_color=:yellow)
plot_stats3D!(fct, signal[parts_end[1]:parts_end[2]], seg_l, p_color=:green)
plot_stats3D!(fct, signal[parts_end[2]:parts_end[3]], seg_l)
plot_stats3D!(fct, signal[parts_end[3]:end], seg_l, p_title="Variable statistics", p_color=:red)
plot!(camera = (-60, 30))
xaxis!("Kurtosis")
yaxis!("RMS")
zaxis!("Energie")
display(plot!(size = (600, 600)))

human = Dict(
    fct[1] => Dict(:supperiorTo => 13.0),
    fct[2] => Dict(:inferiorTo  => 0.001),
    fct[3] => Dict(:inferiorTo  => 4.8e-4)
)
vibration = Dict(
    fct[1] => Dict(:supperiorTo => 1.0),
    fct[2] => Dict(:supperiorTo => 0.4),
    fct[3] => Dict(:supperiorTo => 4.48e-3)
)
cat_signal = isOutOfRange(human, signal, seg_l) .+ 2 .* isOutOfRange(vibration, signal, seg_l)

plotIndice(cat_signal; t_max=t[end])
