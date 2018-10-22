DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
julia $DIR/../make_onehot_and_format.jl gisette
echo "processed, computing umap"
#julia $DIR/../make_tsne.jl gisette 3000 1.0
julia $DIR/../make_umap.jl gisette 10000