DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
julia $DIR/../process_multiclass.jl isolet 1 618 617
echo "created multiclass problems, doing one-hot encoding and labeling"
julia $DIR/../make_onehot_and_format.jl isolet
echo "processed, computing umap"
#julia $DIR/../make_tsne.jl isolet 3000
julia $DIR/../make_umap.jl isolet 10000