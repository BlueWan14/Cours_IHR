using MAT
using Plots, Plots.PlotMeasures
using DSP


function plotSFTF(data::Array, t::StepRangeLen, fs::Int)
    p_time_sig = plot(t, data, label=false, color=:blue)
    yaxis!("Displacement (m)")

    data_STFT = stft(data, fs; fs=fs, window=hamming)
    lgth, hght = size(data_STFT)
    ht_map = heatmap(0:t[end]/hght:t[end], 0:1:lgth, 10log10.(abs2.(data_STFT)), colorbar_title="Magnitude (dB)")
    plot!(ylims=(0, fs/2))
    xaxis!("Time (s)")
    yaxis!("Frequency (Hz)")

    plot(p_time_sig, ht_map, layout=@layout[a{.4h}; b])
    display(plot!(size=(800, 500), left_margin=3mm, right_margin=3mm))
end


fs = 500
fc_human = 3.91
fc_vib = 24.1
order = 2

file = matopen("poignee1ddl_4.mat")
opvar = read(file, "opvar_4")
close(file)

t = 0:1/fs:(length(opvar[3, :])-1)/fs

val_end = [35.4, 57, 70]
parts_end = []
i = 1
for sig = t
    if (sig >= val_end[i])
        append!(parts_end, findall(j -> j == sig, t))
        if i < length(val_end)
            global i += 1
        else
            break
        end
    end
end

HumanFilter = digitalfilter(Bandpass(.1/(fs/2), fc_human/(fs/2)), Butterworth(order))
filtered_humansignal = filt(HumanFilter, opvar[3, :])
VibFilter = digitalfilter(Bandpass(fc_human/(fs/2), fc_vib/(fs/2)), Butterworth(order))
filtered_vibsignal = filt(VibFilter, opvar[3, :])


plotSFTF(filtered_humansignal, t, fs)
