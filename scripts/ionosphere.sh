DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
julia $DIR/../make_onehot_and_format.jl ionosphere
echo "processed, computing umap"
#julia $DIR/../make_tsne.jl ionosphere 2500
julia $DIR/../make_umap.jl ionosphere 2500 15 0.05