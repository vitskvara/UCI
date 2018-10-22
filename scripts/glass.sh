DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
julia $DIR/../process_multiclass.jl glass 2 11 10
echo "created multiclass problems, doing one-hot encoding and labeling"
julia $DIR/../make_onehot_and_format.jl glass
echo "processed, computing umap"
#julia $DIR/../make_tsne.jl glass 2000
julia $DIR/../make_umap.jl glass 2000