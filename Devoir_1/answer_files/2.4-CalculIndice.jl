include("devoir1_lib.jl")


fs = 500
fc_human = 6
fc_vib = 24.1
seg_l = 128
lim_e_human = -19
lim_e_vib = -50

parts_end, t, filtered_humansignal, filtered_vibsignal = init(fs, [35.4, 57, 70]; filtered=true, fc_human=fc_human, fc_vib=fc_vib)

pE1 = plotEnergy(filtered_humansignal, seg_l;
                 ending    = Int(round(fc_vib)),
                 t_max     = t[end],
                 p_title   = "Energie signal humain"
)
plot!([t[1], t[end]], fill(lim_e_human, 2), ls=:dash, lw=2, label=false)
pE2 = plotEnergy(filtered_vibsignal, seg_l;
                 beginning = Int(round(fc_human)),
                 ending    = Int(round(fc_vib)),
                 t_max     = t[end],
                 p_title   = "Energie signal vibratoire"
)
plot!([t[1], t[end]], fill(lim_e_vib, 2), ls=:dash, lw=2, label=false)
display(plot(pE1, pE2, layout=(2, 1)))


human = correspondTo(filtered_humansignal, seg_l, lim_e_human;
                     ending=Int(round(fc_human))
)
vibration = correspondTo(filtered_vibsignal, seg_l, lim_e_vib;
                         beginning=Int(round(fc_human)), ending=Int(round(fc_vib))
)
cat_sig_freq = human .+ 2 .* vibration

plotIndice(cat_sig_freq; t_max=t[end])
