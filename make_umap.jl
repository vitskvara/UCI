# call as julia make_umap.jl dataset max_samples [n_neighbors min_dist metric]
include("utils.jl")

dataset = ARGS[1]
max_samples = Int(Meta.parse(ARGS[2]))
n_neighbors = (length(ARGS) > 2) ? Int(Meta.parse(ARGS[3])) : 15
min_dist = (length(ARGS) > 3) ? Float64(Meta.parse(ARGS[4])) : 0.1
metric = (length(ARGS) > 4) ? ARGS[5] : "euclidean"

host = gethostname()
#master path where data will be stored
master_path = dirname(@__FILE__)

ppath = joinpath(master_path, "processed")
datasets = filter(x->x[1:length(dataset)] == dataset, 
	filter(x->length(x) >= length(dataset), readdir(ppath)))

#println("Precompiling UMAP in Julia and Numba...")
#precompile_nDumap(n_neighbors = n_neighbors,
#		min_dist = min_dist,
#		metric = metric)
#println("Done.")
for _dataset in datasets
	inpath = joinpath(master_path, "processed", _dataset)
	outpath = joinpath(master_path, "umap", _dataset)

	# call tsne
	dataset2D(inpath, outpath, "umap", true, max_samples; 
		n_neighbors = n_neighbors,
		min_dist = min_dist,
		metric = metric)

	# also, plot it
	scatter_2D(outpath)
	f = joinpath(master_path, "umap/plots", string(_dataset, ".png"))
	mkpath(dirname(f))
	savefig(f)
end
show()