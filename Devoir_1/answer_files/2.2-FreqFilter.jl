include("devoir1_lib.jl")


fs = 500
fc_human = 6
fc_vib = 24.1
seg_l = 128

parts_end, t, filtered_humansignal, filtered_vibsignal = init(fs, [35.4, 57, 70]; filtered=true, fc_human=fc_human, fc_vib=fc_vib)

htm1 = plotSFTF(filtered_humansignal, t, fs, seg_l;
                segment    = parts_end,
                p_colors   = [:yellow, :green, :blue, :red],
                p_title    = "STFT du signal humain"
)

htm2 = plotSFTF(filtered_vibsignal, t, fs, seg_l;
                segment    = parts_end,
                p_colors   = [:yellow, :green, :blue, :red],
                p_title    = "STFT du signal vibratoire"
)

plot(htm1, htm2, size=(900, 500), left_margin=5mm, right_margin=5mm, top_margin=0mm, bottom_margin=5mm)
