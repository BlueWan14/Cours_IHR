include("devoir1_lib.jl")


fs = 500

parts_end, t, signal = init(fs, [35.4, 57, 70])

display(plotSFTF(signal, t, fs;
                 segment    = parts_end,
                 p_colors   = [:yellow, :green, :blue, :red],
                 p_title    = "STFT du signal non filtré"
))

# savefig("STFT.png")
