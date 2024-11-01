using Plots, MAT


file = matopen("poignee1ddl_4.mat")
var = read(file, "opvar_4")
close(file)

fs = 500
t = 0:1/fs:(length(var[1,:])-1)/fs
(h, l) = size(var)

for i = 1:1:h
    display(plot(t, var[i, :], linewidth=2, label=false))
end
