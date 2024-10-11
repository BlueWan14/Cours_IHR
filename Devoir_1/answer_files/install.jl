using Pkg


Pkg_tab = ["MAT",
           "Plots", "StatsPlots", "PrettyTables",
           "SignalAnalysis", "DSP",
           "ControlSystemsBase",
           "Distributions"
]

for name in Pkg_tab
    if !in(name, keys(Pkg.installed()))
        Pkg.add(name)
    end
end
