using MAT
using Plots
using SignalAnalysis, DSP


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


fs = 500

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

plot(t[begin:parts_end[1]], opvar[3, begin:parts_end[1]], label=false, color=:orange)
plot!(t[parts_end[1]:parts_end[2]], opvar[3, parts_end[1]:parts_end[2]], label=false, color=:green)
plot!(t[parts_end[2]:parts_end[3]], opvar[3, parts_end[2]:parts_end[3]], label=false, color=:blue)
plot!(t[parts_end[3]:end], opvar[3, parts_end[3]:end], label=false, color=:red)
xaxis!("Time (s)")
display(yaxis!("Displacement (m)"))

in1 = plot(t[begin:parts_end[1]], opvar[3, begin:parts_end[1]], label=false, color=:orange)
title!("Human mouvements with vibration")
xaxis!("Time (s)")
yaxis!("Displacement (m)")
in2 = plot(t[parts_end[1]:parts_end[2]], opvar[3, parts_end[1]:parts_end[2]], label=false, color=:green)
title!("No human mouvements with vibration")
xaxis!("Time (s)")
yaxis!("Displacement (m)")
in3 = plot(t[parts_end[2]:parts_end[3]], opvar[3, parts_end[2]:parts_end[3]], label=false, color=:blue)
title!("No human mouvements without vibration")
xaxis!("Time (s)")
yaxis!("Displacement (m)")
in4 = plot(t[parts_end[3]:end], opvar[3, parts_end[3]:end], label=false, color=:red)
title!("Human mouvements without vibration")
xaxis!("Time (s)")
yaxis!("Displacement (m)")

obw1 = obw(opvar[3, begin:parts_end[1]], fs)
obw2 = obw(opvar[3, parts_end[1]:parts_end[2]], fs)
obw3 = obw(opvar[3, parts_end[2]:parts_end[3]], fs)
obw4 = obw(opvar[3, parts_end[3]:end], fs)

display(plot(in1, obw1, layout=(2, 1), size=(700, 600)))
display(plot(in2, obw2, layout=(2, 1), size=(700, 600)))
display(plot(in3, obw3, layout=(2, 1), size=(700, 600)))
display(plot(in4, obw4, layout=(2, 1), size=(700, 600)))
