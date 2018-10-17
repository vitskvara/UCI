julia process_multiclass.jl isolet 1 618 617
echo "created multiclass problems, doing one-hot encoding and labeling"
julia make_onehot_and_format.jl isolet
echo "processed, computing tsne"
julia make_tsne.jl isolet 3000