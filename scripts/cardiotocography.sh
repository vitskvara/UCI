DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
julia $DIR/../process_multiclass.jl cardiotocography 4 39 28
echo "created multiclass problems, doing one-hot encoding and labeling"
julia $DIR/../make_onehot_and_format.jl cardiotocography 25
echo "processed, computing umap"
#julia $DIR/../make_tsne.jl cardiotocography 2500
julia $DIR/../make_umap.jl cardiotocography 10000