julia process_multiclass.jl glass 2 11 10
echo "created multiclass problems, doing one-hot encoding and labeling"
julia make_onehot_and_format.jl glass
echo "processed, computing tsne"
julia make_tsne.jl glass 2000