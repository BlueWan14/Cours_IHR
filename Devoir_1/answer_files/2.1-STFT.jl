include("devoir1_lib.jl")


fs = 500

parts_end, t, signal = init(fs, [35.4, 57, 70])

plotSFTF(signal, t, fs;
         segment    = parts_end,
         p_colors   = [:yellow, :green, :blue, :red]
)
