using Plots

include("devoir1_lib.jl")


fs = 500
seg_l = 128

parts_end, t, signal = init(fs, [35.4, 57, 70])

fct = [kurtosis, rms, (x -> energy(x, fs=fs))]

plot_stats3D(fct, signal[1:parts_end[1]], seg_l, p_color=:yellow)
plot_stats3D!(fct, signal[parts_end[1]:parts_end[2]], seg_l, p_color=:green)
plot_stats3D!(fct, signal[parts_end[2]:parts_end[3]], seg_l)
plot_stats3D!(fct, signal[parts_end[3]:end], seg_l, p_title="Variable statistics", p_color=:red)
xaxis!("Kurtosis")
yaxis!("RMS")
zaxis!("Energy")
display(plot!(size = (600, 600)))
# display(plot!(camera = (90, 45)))

human = Dict(
    fct[1] => Dict(:supperiorTo => 13.0),
    fct[2] => Dict(:inferiorTo  => 0.001),
    fct[3] => Dict(:inferiorTo  => 5.0e-4)
)
vibration = Dict(
    fct[1] => Dict(:supperiorTo => 1.0),
    fct[2] => Dict(:supperiorTo => 0.4),
    fct[3] => Dict(:supperiorTo => 4.48e-3)
)
cat_signal = isOutOfRange(human, signal, seg_l) .+ 2 .* isOutOfRange(vibration, signal, seg_l)
for i in 21:1:length(cat_signal)-21
    comp = round(mean(cat_signal[i-20:i+20]))
    if (cat_signal[i] != cat_signal[i-1]) && (comp == cat_signal[i-1])
        cat_signal[i] = comp
    end
end

global i_mem = 1
t = 0:t[end]/length(cat_signal):t[end]
colors = [:blue, :yellow, :green, :red]

plot(yrot=-40, size=(600, 400), top_margin=10mm)
for i in 2:1:length(cat_signal)
    if (cat_signal[i] != cat_signal[i-1])
        plot!(t[i_mem:i-1], cat_signal[i_mem:i-1], label=false, color=colors[cat_signal[i-1]+1], lw=3)
        global i_mem = i
    end
end
yticks!(0:1:3, ["Pas de signal", "Signal humain", "Signal vibratoire", "Signal humain\net vibratoire"])
display(title!("Catégorisation du signal"))

# savefig("catSignal_temp.png")
