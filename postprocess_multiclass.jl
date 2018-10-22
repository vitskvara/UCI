# run as julia postprocess_multiclass.jl dataset
# e.g. julia postprocess_multiclass.jl cardiotocography

include("utils.jl")

# settings
dataset = ARGS[1]
#master path where data will be stored
master_path = dirname(@__FILE__)
upath = joinpath(master_path, "umap")
datasets = filter(x->x[1:length(dataset)] == dataset, 
	filter(x->length(x) >= length(dataset), readdir(upath)))

for _dataset in datasets
	inpath = joinpath(upath, _dataset)
	split_multiclass(inpath, upath)
end