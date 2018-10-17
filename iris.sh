julia process_multiclass.jl iris 1 5 4
echo "created multiclass problems, doing one-hot encoding and labeling"
julia make_onehot_and_format.jl iris
echo "processed, computing tsne"
julia make_tsne.jl iris 2000