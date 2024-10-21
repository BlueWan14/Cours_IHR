include("devoir1_lib.jl")


fs = 500
seg_l = 128

parts_end, t, signal = init(fs, [35.4, 57, 70])

plotSFTF(signal, t, fs, seg_l;
         segment    = parts_end,
         p_colors   = [:yellow, :green, :blue, :red],
         p_title    = "STFT du signal non filtré"
)
