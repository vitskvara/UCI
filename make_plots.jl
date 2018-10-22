# call as julia make_plots.jl dataset
include("utils.jl")

dataset = ARGS[1]
#master path where data will be stored
master_path = dirname(@__FILE__)

upath = joinpath(master_path, "umap")
datasets = filter(x->x[1:length(dataset)] == dataset, 
	filter(x->length(x) >= length(dataset), readdir(upath)))
plotpath = joinpath(upath, "plots")

for _dataset in datasets
	inpath = joinpath(upath, _dataset)
	outpath = joinpath(master_path, "umap", _dataset)

	# also, plot it
	scatter_2D(outpath)
	f = joinpath(plotpath, string(_dataset, ".png"))
	mkpath(dirname(f))
	savefig(f)
end
show()