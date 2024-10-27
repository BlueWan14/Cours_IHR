include("devoir1_lib.jl")


fs = 500
seg_l = 128

parts_end, t, signal = init(fs, [35.4, 57, 70])

fct = [kurtosis, rms, (x -> pow2db(energy(x, fs=fs)))]

p1 = plot_stats3D(fct, signal[1:parts_end[1]], seg_l; p_color=:yellow)
plot_stats3D!(fct, signal[parts_end[1]:parts_end[2]], seg_l; p_color=:green)
plot_stats3D!(fct, signal[parts_end[2]:parts_end[3]], seg_l)
plot_stats3D!(fct, signal[parts_end[3]:end], seg_l;
              p_color=:red,
              p_title="Répartition du signal"
)
plot!(camera = (-50, 25))
xaxis!("Kurtosis")
yaxis!("RMS (m)")
zaxis!("Energie (dB)")
zlims!(-200, 0)
display(plot!(size = (500, 500)))

human = Dict(
    fct[1] => Dict(:supperiorTo => 1.0),
    fct[2] => Dict(:inferiorTo  => 0.045),
    fct[3] => Dict(:inferiorTo  => -40.0)
)
vibration = Dict(
    fct[1] => Dict(:supperiorTo => 1.0),
    fct[2] => Dict(:supperiorTo => 0.12),
    fct[3] => Dict(:inferiorTo  => -55.0)
)
cat_sig_temp = isOutOfRange(human, signal, seg_l) .+ 2 .* isOutOfRange(vibration, signal, seg_l)

plotIndice(cat_sig_temp; t_max=t[end])
