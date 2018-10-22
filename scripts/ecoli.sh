DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
julia $DIR/../process_multiclass.jl ecoli 2 9 8
echo "created multiclass problems, doing one-hot encoding and labeling"
julia $DIR/../make_onehot_and_format.jl ecoli
echo "processed, computing umap"
#julia $DIR/../make_tsne.jl ecoli 2000
julia $DIR/../make_umap.jl ecoli 2000