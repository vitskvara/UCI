DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
#julia process_multiclass.jl blood-transfusion
echo "created multiclass problems, doing one-hot encoding and labeling"
julia $DIR/../make_onehot_and_format.jl blood-transfusion
echo "processed, computing umap"
#julia $DIR/../make_tsne.jl blood-transfusion 2500
julia $DIR/../make_umap.jl blood-transfusion 2500