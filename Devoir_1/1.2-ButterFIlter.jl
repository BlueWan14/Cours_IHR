using MAT
using Plots, Plots.PlotMeasures
using DSP, ControlSystemsBase


function Butteranalyse(signal::Array, fc::Number, fs::Number, type; order::Int=2, p_title::String="", fc2::Number=50)
    t = 0:1/fs:(length(signal)-1)/fs

    if type == :lowpass
        filtertype = Lowpass(fc/(fs/2))
    elseif type == :bandpass
        filtertype = Bandpass(fc/(fs/2), fc2/(fs/2))
    elseif type == :bandstop
        filtertype = Bandstop(fc/(fs/2), fc2/(fs/2))
    elseif type == :highpass
        filtertype = Highpass(fc/(fs/2))
    else
        error("Filter type is not defined properly. Please use : `:lowpass`, `:bandpass`, `:bandstop` or `:highpass`.")
    end

    ButterFilter = digitalfilter(filtertype, Butterworth(order))
    filt_sys = tf(ButterFilter, 1/fs)
    mag, phase, w = bode(filt_sys)
    plot(w./(2pi), 20*log10.(mag[:][:][:]), label=false, color=:blue, y_guidefontcolor=:blue)
    plot!(twinx(), w./(2pi), phase[:][:][:], label=false, color=:red, y_guidefontcolor=:red)
    f1 = plot!(xlabel=["Frequency [Hz]" ""], ylabel=["Magnitude (dB)" "Phase (deg)"], right_margin = 10mm)

    pzmap(filt_sys, hz=true, title="")
    f2 = plot!(xlabel="Real", ylabel="Imaginary", right_margin = 5mm)
    
    plot(t, signal, label="Signal non filtré", linewidth=2)
    xaxis!("Time (s)")
    yaxis!("Displacement (m)")
    title!("Filter order $(order) with fc=$(fc) Hz")
    f3 = plot!(t, filt(ButterFilter, signal), label="Signal filtré", linewidth=2, top_margin = 5mm, right_margin = 5mm)

    display(plot(f1, f2, f3, layout=@layout([a b; c]), plot_title=p_title, size = (1000, 800), left_margin = 5mm))
end


fs = 500
fc_0Hz = .1
fc_human = 6
fc_vib = 24.1

file = matopen("poignee1ddl_4.mat")
opvar = read(file, "opvar_4")
close(file)

## No 0Hz value ========================================================================
Butteranalyse(opvar[3, :], fc_0Hz, fs, :highpass; p_title="Without 0Hz value")

# ## No human signal ===================================================================
Butteranalyse(opvar[3, :], fc_human, fs, :highpass; p_title="Without human signal")

# ## No sensor noise ===================================================================
Butteranalyse(opvar[3, :], fc_vib, fs, :lowpass; p_title="Without sensor noises")

# ## Lowpass Filter to reduce noise ====================================================
for ord in [1, 2, 3, 5, 10]
    Butteranalyse(opvar[3, :], fc_0Hz, fc2=fc_human, fs, :bandpass, order=ord; p_title="Human signal only")
    Butteranalyse(opvar[3, :], fc_human, fc2=fc_vib, fs, :bandpass, order=ord; p_title="Vibrations only")
end
