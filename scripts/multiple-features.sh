julia process_multiclass.jl multiple-features 2 1
echo "created multiclass problems, doing one-hot encoding and labeling"
julia make_onehot_and_format.jl multiple-features
echo "processed, computing tsne"
julia make_tsne.jl multiple-features 3000