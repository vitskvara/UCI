DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
#julia process_multiclass.jl blood-transfusion
echo "created multiclass problems, doing one-hot encoding and labeling"
julia $DIR/../make_format.jl abalone 3
echo "processed, computing umap"
julia $DIR/../make_umap.jl abalone 10000 30 0.3 correlation
