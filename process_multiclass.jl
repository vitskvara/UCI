# run as julia process_multiclass.jl dataset data_cols_start class_col [data_cols_end]
# e.g. julia process_multiclass.jl cardiotocography 4 39 28

include("utils.jl")

# settings
dataset = ARGS[1]
data_cols_start = Int(Meta.parse(ARGS[2]))
class_col = Int(Meta.parse(ARGS[3]))
data_cols_end = (length(ARGS)>3 ? Int(Meta.parse(ARGS[4])) : nothing)
host = gethostname()
#master path where data will be stored
master_path = dirname(@__FILE__)
inpath = joinpath(master_path, "raw", dataset)
outpath = joinpath(master_path, "processed")

#
multiclass_to_ad(inpath, outpath, data_cols_start, class_col, data_cols_end = data_cols_end)