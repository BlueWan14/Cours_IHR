using MAT
using Plots, Plots.PlotMeasures
using DSP


function crosscorr(data, tps, lims1::Array, lims2::Array; p_title::String="")
    if (lims1[2]-lims1[1]) != (lims2[2]-lims2[1])
        if (lims1[2]-lims1[1]) > (lims2[2]-lims2[1])
            diff = round(((lims1[2]-lims1[1]) - (lims2[2]-lims2[1])) / 2)
            lims1 = [Int(lims1[1]+diff), Int(lims1[2]-diff)]
        else
            diff = round(((lims2[2]-lims2[1]) - (lims1[2]-lims1[1])) / 2)
            lims2 = [Int(lims2[1]+diff), Int(lims2[2]-diff)]
        end
    end
    
    p_time_sig = plot(tps[lims1[1]:lims1[2]], data[lims1[1]:lims1[2]], label="Data 1", color=:blue)
    plot!(tps[lims2[1]:lims2[2]], data[lims2[1]:lims2[2]], label="Data 2", color=:orange)
    xaxis!("Time (s)")
    yaxis!("Displacement (m)")

    p_cor = plot(xcorr(data[lims1[1]:lims1[2]], data[lims1[1]:lims1[2]]), label="Data 1", color=:blue, lw=2)
    plot!(xcorr(data[lims2[1]:lims2[2]], data[lims2[1]:lims2[2]]), label="Data 2", color=:orange, lw=2)
    xaxis!("Lag (s)")
    yaxis!("Autocorrelation")

    corr = xcorr(data[lims1[1]:lims1[2]], data[lims2[1]:lims2[2]])
    p_crosscor = plot(corr, label=false, color=:green)
    xaxis!("Lag (s)")
    yaxis!("Correlation")

    display(plot(p_time_sig, p_cor, p_crosscor, layout=(3, 1), plot_title=p_title, size=(700, 700)))
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

crosscorr(filtered_humansignal, t, [1, parts_end[1]], [parts_end[3], length(filtered_humansignal)], p_title="Human Signal")
crosscorr(filtered_vibsignal, t, [parts_end[1], parts_end[2]], [parts_end[3], length(filtered_humansignal)], p_title="Vibration Signal")
