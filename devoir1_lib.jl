using MAT
using Plots, Plots.PlotMeasures, StatsPlots
using SignalAnalysis, DSP


function init(fs::Int, val_end::Array; filtered::Bool=false, fc_human::Float64=0.0, fc_vib::Float64=0.0, order::Int=2)
    file = matopen("poignee1ddl_4.mat")
    opvar = read(file, "opvar_4")
    close(file)

    t = 0:1/fs:(length(opvar[3, :])-1)/fs

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

    if filtered
        if fc_human == 0.0 && fc_vib == 0.0
            return error("Cut frequency aren't select.")
        end

        HumanFilter = digitalfilter(Bandpass(.1/(fs/2), fc_human/(fs/2)), Butterworth(order))
        filtered_humansignal = filt(HumanFilter, opvar[3, :])
        VibFilter = digitalfilter(Bandpass(fc_human/(fs/2), fc_vib/(fs/2)), Butterworth(order))
        filtered_vibsignal = filt(VibFilter, opvar[3, :])
        
        return parts_end, t, filtered_humansignal, filtered_vibsignal
    else
        return parts_end, t
    end
end

function obw(var, fs)
    periodgram = periodogram(var, fs=fs)
    p = power(periodgram)
    f = freq(periodgram)

    p_density = []
    p_index = []
    p_sort = sort(p, rev=true)
    global i = 0
    global dens = 0.0
    pwr_sum = sum(p)
    while (dens <= 0.99) && (i < length(p))
        global i += 1
        append!(p_density, p_sort[i])
        append!(p_index, findall(j -> j == p_sort[i], p))
        global dens = sum(p_density) / pwr_sum
    end
    sort!(p_index)

    y = pow2db.(p)
    min = minimum(y)-10
    max = maximum(y)+10
    rect = Shape([f[p_index[1]], f[p_index[1]], f[p_index[end]], f[p_index[end]]], [max, min, min, max])
    fft = plot(rect, opacity=.1, label=false)
    psd!(var, fs=fs, nfft=10*fs, yrange=:y, color=RGB(0, .602, 0.973))
    title!("99% Occupied Bandwidth : $(round(f[p_index[end]]-f[p_index[1]], digits=2)) Hz")
    ylims!(minimum(y)-5, maximum(y)+5)

    return fft
end

function Butteranalyse(signal::Array, fc::Number, fs::Number, type; order::Int=2, fc2::Number=50)
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
    f3 = plot!(t, filt(ButterFilter, signal), label="Signal filtré", linewidth=2, top_margin = 5mm, right_margin = 5mm)

    display(plot(f1, f2, f3, layout=@layout([a b; c]), plot_title="Filter order $(order) with fc=$(fc) Hz", size = (1000, 800), left_margin = 5mm))
end

function statisticVar(data::Array; p_title::String="")
    feature = zeros(4)
    feature_names = ["Mean", "Standard Deviation", "Kurtosis", "Skewness"]

    feature[1] = mean(data)
    feature[2] = std(data)
    feature[3] = kurtosis(data)
    feature[4] = skewness(data)

    p_hist = histogram(data, color=:blue, label="Histogram", bottom_margin=8mm)
    xaxis!("Displacement (m)")
    yaxis!("Number of occurences")
    title!(p_title)
    plot!([], color=:green, label="Density Function")
    density!(twinx(), data, color=:green, lw=2, label=false, yaxis="Probability density")
    plot!([feature[1]], seriestype="vline", color=:red, ls=:dash, lw=2, label="Mean")
    plot!([feature[1]-feature[2]/2, feature[1]+feature[2]/2], seriestype="vline", color=:orange, ls=:dot, lw=2, label="Standard Deviation")

    p_txt = plot(grid=false, showaxis=false)
    it = 1 / length(feature)
    global j = 1.0
    for i in 1:1:length(feature)
        annotate!(.5, j, "$(feature_names[i]) : $(round(feature[i], digits=3))")
        global j -= it
    end

    p_stats_var = plot(p_hist, p_txt, layout=@layout[a; b{.3h}])
    return p_stats_var, feature
end

function plotStatVar(data1, data2, tps; beginning::Int=1, ending::Int=length(data1))
    data1 = data1[beginning:ending]
    data2 = data2[beginning:ending]
    tps = tps[beginning:ending]

    p_sig = plot(tps, data2, label="Vibration", color=:orange, lw=2)
    plot!(tps, data1, label="Human", color=:blue, lw=2)
    xaxis!("Time (s)")
    yaxis!("Displacement (m)")

    p_stats_var1, feature_var1 = statisticVar(data1; p_title="Human")
    p_stats_var2, feature_var2 = statisticVar(data2; p_title="Vibration")

    plot(p_sig, p_stats_var1, p_stats_var2, layout=@layout([a{.3h}; b c]))
    display(plot!(size=(1300, 700), left_margin=5mm, right_margin=5mm))
end

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
    p_crosscor = plot(corr, label=false, color=:red)
    xaxis!("Lag (s)")
    yaxis!("Correlation")

    display(plot(p_time_sig, p_cor, p_crosscor, layout=(3, 1), plot_title=p_title, size=(700, 700)))
end