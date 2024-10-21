include("devoir1_lib.jl")


fs = 500
fc_human = 3.91
fc_vib = 24.1
seg_l = 128

parts_end, t, filtered_humansignal, filtered_vibsignal = init(fs, [35.4, 57, 70]; filtered=true, fc_human=fc_human, fc_vib=fc_vib)


pE1 = plotEnergy(filtered_humansignal, seg_l;
                 ending    = Int(round(fc_vib)),
                 t_max     = t[end],
                 p_title   = "Energie signal humain"
)
pE2 = plotEnergy(filtered_vibsignal, seg_l;
                 beginning = Int(round(fc_human)),
                 ending    = Int(round(fc_vib)),
                 t_max     = t[end],
                 p_title   = "Energie signal vibratoire"
)
display(plot(pE1, pE2, layout=(2, 1)))


human = correspondTo(filtered_humansignal, seg_l, .1;
                     ending=Int(round(fc_human))
)
vibration = correspondTo(filtered_vibsignal, seg_l, .0157;
                         beginning=Int(round(fc_human)), ending=Int(round(fc_vib))
)
cat_sig = human .+ 2 .* vibration

plotIndice(cat_sig; t_max=t[end])
