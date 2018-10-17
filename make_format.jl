# run as julia make_format.jl path [ends of cat cols]
# eg. julia make_format.jl processed/abalone 3
include("utils.jl")

path = ARGS[1]
if length(ARGS) > 1
	cat_cols = []
	for arg in ARGS[2:end]
		arg = Int(Meta.parse(arg))
		if length(cat_cols) == 0
			push!(cat_cols, 1:arg)
		else
			push!(cat_cols, cat_cols[end][end]+1:arg)
		end
	end
else
	cat_cols = nothing
end
save_format(path, cat_cols)