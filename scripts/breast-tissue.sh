DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
julia $DIR/../process_multiclass.jl breast-tissue 3 2
echo "created multiclass problems, doing one-hot encoding and labeling"
julia $DIR/../make_onehot_and_format.jl breast-tissue
echo "processed, computing umap"
#julia $DIR/../make_tsne.jl breast-tissue 2500
julia $DIR/../make_umap.jl breast-tissue 10000 2 0.01 correlation
