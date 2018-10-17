julia process_multiclass.jl libras 1 91 90
echo "created multiclass problems, doing one-hot encoding and labeling"
julia make_onehot_and_format.jl libras
echo "processed, computing tsne"
julia make_tsne.jl libras 2000