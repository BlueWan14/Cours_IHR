include("devoir1_lib.jl")


fs = 500
fc_human = 3.91
fc_vib = 24.1
seg_l = 128

parts_end, t, filtered_humansignal, filtered_vibsignal = init(fs, [35.4, 57, 70]; filtered=true, fc_human=fc_human, fc_vib=fc_vib)

printStatisticTab(filtered_humansignal, parts_end; fs=fs, p_title="Human signal's features")
printStatisticTab(filtered_vibsignal, parts_end; fs=fs, p_title="Vibration signal's features")
