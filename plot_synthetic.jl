using PyPlot
using UCI

datasets = readdir(UCI.get_synthetic_datapath())
Nd = length(datasets)
outpath = "synthetic_plots"

f=figure(figsize=(10,10))
for (i,dataset) in enumerate(datasets)
	subplot(3,Int(Nd/3),i)
	data = UCI.get_synthetic_data(dataset)
	title(dataset)
	scatter(data.normal[1,:], data.normal[2,:], s=2, label="normal")
	scatter(data.medium[1,:], data.medium[2,:], s=2, label="medium")
	if i==1
		legend()
	end
end
savefig(joinpath(outpath, "all_grid.png"))
show()