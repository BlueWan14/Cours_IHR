include("devoir1_lib.jl")


fs = 500
seg_l = 128

parts_end, t, signal = init(fs, [3.7, 23.7, 24.8, 35.1, 56.5, 70.1, 96.7])

fct = [kurtosis, rms, (x -> pow2db(energy(x, fs=fs)))]

p1 = plot_stats3D(fct, signal[parts_end[1]:parts_end[4]], seg_l; p_color=:yellow, p_label = "Mouvements humains")
plot_stats3D!(fct, signal[parts_end[4]:parts_end[5]], seg_l; p_color=:green, p_label = "Vibrations")
plot_stats3D!(fct, signal[parts_end[5]:parts_end[6]], seg_l, p_label = "Aucune activité")
plot_stats3D!(fct, signal[parts_end[6]:parts_end[7]], seg_l;
              p_color = :red,
              p_alpha = .4,
              p_title = "Répartition du signal",
              p_label = "Mouvements humains avec vibrations"
)
plot!(camera = (-50, 25))
xaxis!("Kurtosis")
yaxis!("RMS (m/s)")
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


display(plotIndice(cat_sig_temp; t_max=t[end]))


map!(x -> div(x, Int(seg_l/2)), parts_end, parts_end)
pushfirst!(parts_end, 1)
push!(parts_end, length(cat_sig_temp)+1)
plotConfMatrix(cat_sig_temp, parts_end, [0, 1, 0, 1, 2, 0, 3, 0])
