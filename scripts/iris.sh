DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
julia $DIR/../process_multiclass.jl iris 1 5 4
echo "created multiclass problems, doing one-hot encoding and labeling"
julia $DIR/../make_onehot_and_format.jl iris
echo "processed, computing umap"
#julia $DIR/../make_tsne.jl iris 2000
julia $DIR/../make_umap.jl iris 2000