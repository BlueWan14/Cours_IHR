# include("install.jl")

#= 
Title: devoir1_lib
Authors: Erwan MAWART 
Date: 28/10/2024
Status: DONE 
Description:
Cette bibliothèque fournit des outils pour analyser les dynamiques fréquentielles et temporelles de signaux représentant 
des mouvements humains et des vibrations. 
Elle inclut des fonctions pour la segmentation, le filtrage, l'analyse statistique, 
et la représentation graphique de données dans le contexte de l'interaction humain-robot.
=#

using MAT
using Plots, Plots.PlotMeasures, StatsPlots, PrettyTables
using SignalAnalysis, DSP
using ControlSystemsBase
using Distributions

# Fonction d'initialisation : charge le signal et applique des filtres si nécessaire
function init(fs::Int, val_end::Array; filtered::Bool=false, fc_human::Float64=0.0, fc_vib::Float64=0.0, order::Int=2)
    file = matopen("/home/pacem/Documents/INGE/S9/IHR/Devoir_1/Cours_IHR/Devoir_1/answer_files/poignee1ddl_4.mat")
    opvar = read(file, "opvar_4")
    close(file)

    t = 0:1/fs:(length(opvar[3, :])-1)/fs
    parts_end = []
    i::Int = 1
    for sig = t
        if sig >= val_end[i]
            append!(parts_end, findall(j -> j == sig, t))
            if i < length(val_end)
                i += 1
            else
                break
            end
        end
    end

    if filtered
        if fc_human == 0.0 && fc_vib == 0.0
            return error("Les fréquences de coupure ne sont pas sélectionnées.")
        end
        HumanFilter = digitalfilter(Bandpass(.1/(fs/2), fc_human/(fs/2)), Butterworth(order))
        filtered_humansignal = filt(HumanFilter, opvar[3, :])
        VibFilter = digitalfilter(Bandpass(fc_human/(fs/2), fc_vib/(fs/2)), Butterworth(order))
        filtered_vibsignal = filt(VibFilter, opvar[3, :])
        
        return parts_end, t, filtered_humansignal, filtered_vibsignal
    else
        return parts_end, t, opvar[3, :]
    end
end

# Fonction pour afficher les catégories du signal dans le temps
function plotIndice(data::Array{Int}; t_max::Float64=length(data), colors::Array{Symbol}=[:blue, :yellow, :green, :red])
    global i_mem = 1
    t = 0:t_max/length(data):t_max

    p = plot(yrot=-40, size=(600, 400), top_margin=10mm)
    for i in 2:length(data)
        if data[i] != data[i-1]
            plot!(t[i_mem:i-1], data[i_mem:i-1], label=false, color=colors[data[i-1]+1], lw=3)
            global i_mem = i
        end
    end
    yticks!(minimum(data):maximum(data), ["Pas de signal", "Signal humain", "Signal vibratoire", "Signal humain\net vibratoire"])
    title!("Catégorisation du signal")

    return p
end

# Calcul et affichage de la bande passante occupée à 99 % d'énergie
function obw(signal::Array, fs::Int; t::StepRangeLen=0:1/fs:(length(signal)-1)/fs, p_title::String="", p_color::Symbol=:blue)
    periodgram = periodogram(signal, fs=fs)
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
    rect = Shape([f[p_index[1]], f[p_index[1]], f[p_index[end]], f[p_index[end]]], [maximum(y)+10, minimum(y)-10, minimum(y)-10, maximum(y)+10])
    obw_plot = plot(rect, opacity=.1, label=false)
    psd!(signal, fs=fs, nfft=10*fs)
    title!("99% Occupied Bandwidth : $(round(f[p_index[end]]-f[p_index[1]], digits=2)) Hz")

    sig = plot(t, signal, label=false, color=p_color)
    xaxis!("Time (s)")
    yaxis!("Displacement (m)")

    display(plot(sig, obw_plot, layout=(2, 1), size=(700, 600), plot_title=p_title))
end

# Fonction pour analyser un signal avec un filtre Butterworth
function Butteranalyse(signal::Array, fc::Number, fs::Number, type::Symbol; order::Int=2, p_title::String="", fc2::Number=50)
    t = 0:1/fs:(length(signal)-1)/fs
    filtertype = if type == :lowpass
        Lowpass(fc/(fs/2))
    elseif type == :bandpass
        Bandpass(fc/(fs/2), fc2/(fs/2))
    elseif type == :bandstop
        Bandstop(fc/(fs/2), fc2/(fs/2))
    elseif type == :highpass
        Highpass(fc/(fs/2))
    else
        error("Type de filtre non défini.")
    end

    ButterFilter = digitalfilter(filtertype, Butterworth(order))
    filt_sys = tf(ButterFilter, 1/fs)
    mag, phase, w = bode(filt_sys)
    plot(w./(2pi), 20*log10.(mag[:][:][:]), label=false)
    plot!(twinx(), w./(2pi), phase[:][:][:], label=false)
    f1 = plot!(xlabel=["Frequency [Hz]" ""], ylabel=["Magnitude (dB)" "Phase (deg)"])

    pzmap(filt_sys, hz=true, title="")
    f2 = plot!(xlabel="Real", ylabel="Imaginary")
    
    plot(t, signal, label="Signal non filtré", linewidth=2)
    xaxis!("Time (s)")
    yaxis!("Displacement (m)")
    f3 = plot!(t, filt(ButterFilter, signal), label="Signal filtré")

    display(plot(f1, f2, f3, layout=@layout([a b; c]), plot_title=p_title, size=(1000, 800)))
end

# Génération d'un tableau de statistiques
function statisticTab(data::Array, fs::Real)
    feature = Dict(
        "Mean"               => mean(data),
        "Variance"           => var(data),
        "Standard Deviation" => std(data),
        "Kurtosis"           => kurtosis(data),
        "Skewness"           => skewness(data),
        "Energy"             => energy(data, fs=fs),
        "RMS"                => rms(data)
    )
    return feature
end

# Affichage d'un tableau de statistiques pour les segments du signal
function printStatisticTab(signal::Vector, segment::Vector; p_title::String="", fs::Real=1/length(data))
    feature = statisticTab(signal[1:segment[1]], fs)
    tab_features = permutedims(collect(keys(feature)))
    tab_temp = []
    foreach(x -> push!(tab_temp, get(feature, x, 0.0)), tab_features[1, :])
    tab_features = vcat(tab_features, permutedims(tab_temp))
    hl_p1 = Highlighter((data, i, j) -> (i == 1), crayon"yellow")

    feature = statisticTab(signal[segment[1]:segment[2]], fs)
    tab_temp = []
    foreach(x -> push!(tab_temp, get(feature, x, 0.0)), tab_features[1, :])
    tab_features = vcat(tab_features, permutedims(tab_temp))
    hl_p2 = Highlighter((data, i, j) -> (i == 2), crayon"green")

    feature = statisticTab(signal[segment[2]:segment[3]], fs)
    tab_temp = []
    foreach(x -> push!(tab_temp, get(feature, x, 0.0)), tab_features[1, :])
    tab_features = vcat(tab_features, permutedims(tab_temp))
    hl_p3 = Highlighter((data, i, j) -> (i == 3), crayon"blue")

    feature = statisticTab(signal[segment[3]:end], fs)
    tab_temp = []
    foreach(x -> push!(tab_temp, get(feature, x, 0.0)), tab_features[1, :])
    tab_features = vcat(tab_features, permutedims(tab_temp))
    hl_p3 = Highlighter((data, i, j) -> (i == 4), crayon"red")

    pretty_table(
        tab_features[2:end, :],
        header          = tab_features[1, :],
        header_crayon   = crayon"white bg:dark_gray bold",
        highlighters    = (hl_p1, hl_p2, hl_p3),
        title           = p_title
    )
end

## Question 1.4 =====================================================================================================
# Fonction pour calculer trois statistiques 3D sur un signal en segments glissants
function stats3D(f_apply::Array{Function}, signal::Vector, l_seg::Int)
    if length(f_apply) != 3
        error("Vous devez choisir trois fonctions statistiques")
    end

    stats_var = fill(undef, (3, 1))
    mid_l_seg = l_seg / 2

    for i in 0:Int(round((length(signal) - l_seg) / mid_l_seg) - 1)
        sig = signal[Int(1+i*mid_l_seg) : Int(l_seg+i*mid_l_seg)]
        stats_tab = [fct(sig) for fct in f_apply]
        stats_var = hcat(stats_var, stats_tab)
    end
    return stats_var[:, 2:end]
end

# Fonction pour afficher les statistiques en 3D
function plot_stats3D(f_apply::Array{Function}, signal::Vector, l_seg::Int; p_title::String="", p_color::Symbol=:blue)
    stats_var = stats3D(f_apply, signal, l_seg)
    scatter3d(stats_var[1, :], stats_var[2, :], stats_var[3, :], title=p_title, color=p_color, label=false)
end

# Fonction pour ajouter des statistiques 3D à un graphique existant
function plot_stats3D!(f_apply::Array{Function}, signal::Vector, l_seg::Int; p_title::String="", p_color::Symbol=:blue)
    stats_var = stats3D(f_apply, signal, l_seg)
    scatter3d!(stats_var[1, :], stats_var[2, :], stats_var[3, :], title=p_title, color=p_color, label=false)
end

## Question 2.1 =====================================================================================================
# Fonction pour afficher la Transformée de Fourier à Court Terme (STFT) d'un signal avec des segments colorés
function plotSFTF(data::Array, t::StepRangeLen, fs::Int; segment::Vector=[], p_colors::Vector{Symbol}=[])
    if !isempty(segment)
        p_time_sig = plot(t[begin:segment[1]], data[begin:segment[1]], label=false, color=p_colors[1])
        for i in 2:length(segment)
            plot!(t[segment[i-1]:segment[i]], data[segment[i-1]:segment[i]], label=false, color=p_colors[i])
        end
    else
        p_time_sig = plot(t, data, label=false, color=:blue)
    end
    yaxis!("Déplacement (m)")
    xlims!(0, t[end])

    data_STFT = stft(data, fs=fs, window=hamming)
    ht_map = heatmap(0:t[end]/size(data_STFT, 2):t[end], 0:1:size(data_STFT, 1), 10log10.(abs2.(data_STFT)), colorbar_title="Magnitude (dB)")
    plot!(ylims=(0, fs/2))
    xaxis!("Temps (s)")
    yaxis!("Fréquence (Hz)")

    plot(p_time_sig, plot(grid=false, axis=false), ht_map, layout=@layout[[a b{.02w}]; b{.65h}])
    display(plot!(size=(800, 500), left_margin=3mm, right_margin=3mm))
end

# Fonction pour vérifier si les valeurs d'un segment sont hors des seuils définis
function isOutOfRange(f_apply::Dict{Function, Dict{Symbol, Float64}}, signal::Vector, l_seg::Int)
    cat = []
    mid_l_seg = l_seg / 2

    for i in 0:Int(round((length(signal) - l_seg) / mid_l_seg) - 1)
        sig = signal[Int(1+i*mid_l_seg) : Int(l_seg+i*mid_l_seg)]
        answer = all([(get(lim, :inferiorTo, -Inf) <= fct(sig) <= get(lim, :supperiorTo, Inf)) for (fct, lim) in f_apply])
        push!(cat, Int(answer))
    end
    return cat
end

## Question 2.X =====================================================================================================
# Variante de la fonction `plotSFTF` avec un titre et un choix de couleurs pour chaque segment
function plotSFTF(data::Array, t::StepRangeLen, fs::Int, l_seg::Int; segment::Vector=[], p_colors::Vector{Symbol}=[], p_title::String="")
    if !isempty(segment)
        p_time_sig = plot(t[begin:segment[1]], data[begin:segment[1]], label=false, color=p_colors[1])
        for i in 2:length(segment)
            plot!(t[segment[i-1]:segment[i]], data[segment[i-1]:segment[i]], label=false, color=p_colors[i])
        end
    else
        p_time_sig = plot(t, data, label=false, color=:blue)
    end
    yaxis!("Déplacement (m)")
    xlims!(0, t[end])

    data_STFT = stft(data, l_seg, div(l_seg, 2); fs=fs, window=hamming)
    mag = 10log10.(abs2.(data_STFT))
    ht_map = heatmap(0:t[end]/size(data_STFT, 2):t[end], 0:1:size(data_STFT, 1)-1, mag, colorbar_title="Magnitude (dB)", c=:viridis, clim=(-(size(data_STFT, 1)-1), maximum(mag)))
    xaxis!("Temps (s)")
    yaxis!("Fréquence (Hz)")

    plot(p_time_sig, plot(grid=false, axis=false), ht_map, layout=@layout[[a b{.02w}]; c{.65h}], plot_title=p_title)
    return plot!(size=(800, 500), left_margin=3mm, right_margin=3mm)
end

## Question 2.4 =====================================================================================================
# Fonction pour tracer l'énergie calculée sur chaque segment de la STFT
function plotEnergy(data::Array, l_seg::Int; beginning::Int=1, ending::Int=length(data), t_max::Float64=length(data), p_title::String="")
    data_STFT = stft(data, l_seg, div(l_seg, 2); fs=fs, window=hamming)
    sig_e = [energy(data_STFT[beginning:ending, i]) for i in 1:size(data_STFT, 2)]
    return plot(0:t_max/(length(sig_e)-1):t_max, sig_e, label=false, title=p_title, lw=2)
end

# Fonction pour vérifier si l'énergie d'un segment dépasse une limite
function correspondTo(data::Array, l_seg::Int, lim::Float64; beginning::Int=1, ending::Int=length(data))
    data_STFT = stft(data, l_seg, div(l_seg, 2); fs=fs, window=hamming)
    sig_e = [energy(data_STFT[beginning:ending, i]) > lim for i in 1:size(data_STFT, 2)]
    return sig_e
end
