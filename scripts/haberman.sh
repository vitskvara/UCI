DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
julia $DIR/../make_onehot_and_format.jl haberman
echo "processed, computing umap"
#julia make_tsne.jl haberman 2000
julia $DIR/../make_umap.jl haberman 2000