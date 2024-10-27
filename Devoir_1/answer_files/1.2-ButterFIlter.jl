include("devoir1_lib.jl")


fs = 500
fc_0Hz = .1
fc_human = 6
fc_vib = 24.1

parts_end, t, signal = init(fs, [35.4, 57, 70])

## No 0Hz value ========================================================================
Butteranalyse(signal, fc_0Hz, fs, :highpass; p_title="Sans composante continue")

# ## No human signal ===================================================================
Butteranalyse(signal, fc_human, fs, :highpass; p_title="Sans signal humain")

# ## No sensor noise ===================================================================
Butteranalyse(signal, fc_vib, fs, :lowpass; p_title="Sans le bruit des capteurs")

# ## Lowpass Filter to reduce noise ====================================================
for ord in [1, 2, 3, 5, 10]
    Butteranalyse(signal, fc_0Hz, fc2=fc_human, fs, :bandpass, order=ord; p_title="Signal humain uniquement")
    Butteranalyse(signal, fc_human, fc2=fc_vib, fs, :bandpass, order=ord; p_title="Vibrations uniquement")
end
