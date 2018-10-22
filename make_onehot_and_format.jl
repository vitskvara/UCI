# call as julia make_onehot.jl dataset [cid1 cid2 cid3 cid4 ...]
include("utils.jl")

global dataset = ARGS[1]
#master path where data will be stored
master_path = dirname(@__FILE__)

ppath = joinpath(master_path, "processed") 
datasets = filter(x->x[1:length(dataset)] == dataset, 
	filter(x->length(x) >= length(dataset), readdir(ppath)))

for _dataset in datasets
	path = joinpath(master_path, "processed", _dataset)
	if length(ARGS) > 1
		cat_cols = []
		for (i,arg) in enumerate(ARGS[2:end])
			arg = Int(Meta.parse(arg))
			_, n_new = onehot(path, arg)
			if length(cat_cols) == 0
				push!(cat_cols, 1:n_new+1)
			else
				push!(cat_cols, cat_cols[end]+1:cat_cols[end]+n_new+1)
			end
		end
	else
		cat_cols = nothing
	end

	save_format(path, cat_cols)
end