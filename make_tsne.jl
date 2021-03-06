# call as julia make_tsne.jl dataset max_samples [perplexity]
include("utils.jl")

dataset = ARGS[1]
max_samples = Int(Meta.parse(ARGS[2]))
if length(ARGS) > 2
	perplexity = Float64(Meta.parse(ARGS[3]))
else
	perplexity = 15.0
end

host = gethostname()
#master path where data will be stored
master_path = dirname(@__FILE__)

ppath = joinpath(master_path, "processed")
datasets = filter(x->x[1:length(dataset)] == dataset, 
	filter(x->length(x) >= length(dataset), readdir(ppath)))

for _dataset in datasets
	inpath = joinpath(master_path, "processed", _dataset)
	outpath = joinpath(master_path, "tsne", _dataset)

	# call tsne
	dataset2D(inpath, outpath, "tsne", true, max_samples, perplexity = perplexity)

	# also, plot it
	scatter_2D(outpath)
	f = joinpath(master_path, "tsne/plots", string(_dataset, ".png"))
	mkpath(dirname(f))
	savefig(f)
end
show()