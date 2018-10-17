echo "created multiclass problems, doing one-hot encoding and labeling"
julia make_onehot_and_format.jl miniboone
echo "processed, computing tsne"
julia make_tsne.jl miniboone 3000