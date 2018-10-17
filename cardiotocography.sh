julia process_multiclass.jl cardiotocography 4 39 28
echo "created multiclass problems, doing one-hot encoding and labeling"
julia make_onehot_and_format.jl cardiotocography 25
echo "processed, computing tsne"
julia make_tsne.jl cardiotocography 2500