echo "created multiclass problems, doing one-hot encoding and labeling"
julia make_onehot_and_format.jl madelon
echo "processed, computing tsne"
julia make_tsne.jl madelon 2600 1.0