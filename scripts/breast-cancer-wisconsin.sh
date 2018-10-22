DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
#julia process_multiclass.jl breast-cancer-wisconsin
echo "created multiclass problems, doing one-hot encoding and labeling"
julia $DIR/../make_onehot_and_format.jl breast-cancer-wisconsin
echo "processed, computing umap"
#julia $DIR/../make_tsne.jl breast-cancer-wisconsin 2500
julia $DIR/../make_umap.jl breast-cancer-wisconsin 5000