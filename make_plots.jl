# call as julia make_plots.jl dataset [size alpha]
include("utils.jl")

dataset = ARGS[1]
s = (length(ARGS) > 1) ? Int(Meta.parse(ARGS[2])) : 3
alpha = (length(ARGS) > 2) ? Float64(Meta.parse(ARGS[3])) : 1.0

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
	figure()
	scatter_2D(outpath; s = s, alpha = alpha)
	legend()
	f = joinpath(plotpath, string(_dataset, ".png"))
	mkpath(dirname(f))
	savefig(f)
end
show()