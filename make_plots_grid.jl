# call as julia make_plots.jl [dataset]
include("utils.jl")

master_path = dirname(@__FILE__)

#dataset = (length(ARGS) > 0) ? ARGS[1] : ""

#dataset = "glass"

upath = joinpath(master_path, "umap")
if dataset != ""
	datasets = filter(x->x[1:length(dataset)] == dataset, 
		filter(x->length(x) >= length(dataset), readdir(upath)))
else
	datasets = ["abalone", "blood-transfusion", "breast-cancer-wisconsin", "gisette",
				"haberman", "ionosphere", "madelon", "magic-telescope", "miniboone",
				"musk-2", "parkinsons", "pima-indians", "sonar", "spect-heart", 
				"vertebral-column"]
end
plotpath = joinpath(upath, "grid_plots")

SR = 4 # size of row
N = length(datasets)
M = Int(ceil(N/SR)) # nr of rows

# plot ARGS
s = 2
alpha = 1.0

figure()
for (i,_dataset) in enumerate(datasets)
	inpath = joinpath(upath, _dataset)
	outpath = joinpath(master_path, "umap", _dataset)

	# also, plot it
	subplot(M,SR,i)
	if _dataset == "miniboone"
		scatter_2D(outpath; s = 0.1, alpha = 0.1)
	elseif  _dataset == "magic-telescope"
		scatter_2D(outpath; s = 0.1, alpha = 0.2)
	elseif _dataset == "abalone"
		scatter_2D(outpath; s = 0.1, alpha = 1.0)
	else
		scatter_2D(outpath; s = s, alpha = alpha)
	end
end
tight_layout(pad = 0.1, h_pad = 0.1, w_pad = 0.1)
show()
if dataset==""
	dataset = "no-class"
end
#f = joinpath(plotpath, string(dataset, ".png"))
#mkpath(dirname(f))
#savefig(f)
