using MAT
using Plots, Plots.PlotMeasures, StatsPlots
using DSP
using Statistics, Distributions


function statisticTab(data::Array; p_title::String="")
    feature = zeros(5)
    feature_names = ["Mean", "Variance", "Standard Deviation", "Kurtosis", "Skewness"]

    feature[1] = mean(data)
    feature[2] = var(data)
    feature[3] = std(data)
    feature[4] = kurtosis(data)
    feature[5] = skewness(data)


    p_sig = plot(data, label=false)
    xaxis!("Time (s)")
    yaxis!("Displacement (m)")

    p_txt = plot(grid=false, showaxis=false)
    it = 1 / length(feature)
    global j = 1.0
    for i in 1:1:length(feature)
        annotate!(.5, j, "$(feature_names[i]) : $(round(feature[i], digits=3))")
        global j -= it
    end

    p_stats_var = plot(p_sig, p_txt, layout=@layout[a{.3h}; b])
    return feature
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
    display(plot!(sleft_margin=5mm, right_margin=5mm))
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

features_human = []
p_stat, feature = statisticVar(filtered_humansignal[begin:parts_end[1]], p_title="Human")
append!(features_human, [feature])
p_stat, feature = statisticVar(filtered_humansignal[parts_end[1]:parts_end[2]], p_title="Human")
append!(features_human, [feature])
p_stat, feature = statisticVar(filtered_humansignal[parts_end[3]:end], p_title="Human")
append!(features_human, [feature])

features_vib = []
p_stat, feature = statisticVar(filtered_vibsignal[begin:parts_end[1]], p_title="Vibration")
append!(features_vib, [feature])
p_stat, feature = statisticVar(filtered_vibsignal[parts_end[1]:parts_end[2]], p_title="Vibration")
append!(features_vib, [feature])
p_stat, feature = statisticVar(filtered_vibsignal[parts_end[3]:end], p_title="Vibration")
append!(features_vib, [feature])

display(features_human)
display(features_vib)
