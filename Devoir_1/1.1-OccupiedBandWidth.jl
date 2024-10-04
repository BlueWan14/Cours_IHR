using Plots
using .devoir1_lib, .devoir1_lib.Enonce1_lib


fs = 500

parts_end, t, signal = init(fs, [35.4, 57, 70])

plot(t[begin:parts_end[1]], signal[begin:parts_end[1]], label=false, color=:orange)
plot!(t[parts_end[1]:parts_end[2]], signal[parts_end[1]:parts_end[2]], label=false, color=:green)
plot!(t[parts_end[2]:parts_end[3]], signal[parts_end[2]:parts_end[3]], label=false, color=:blue)
plot!(t[parts_end[3]:end], signal[parts_end[3]:end], label=false, color=:red)
xaxis!("Time (s)")
display(yaxis!("Displacement (m)"))

obw(signal[begin:parts_end[1]], fs; t=t[begin:parts_end[1]], p_title="Human mouvements without vibrations", p_color=:orange)
obw(signal[parts_end[1]:parts_end[2]], fs; t=t[parts_end[1]:parts_end[2]], p_title="Vibrations without human mouvements", p_color=:green)
obw(signal[parts_end[3]:end], fs; t=t[parts_end[3]:end], p_title="Human mouvements with vibrations", p_color=:red)
