julia process_multiclass.jl ecoli 2 9 8
echo "created multiclass problems, doing one-hot encoding and labeling"
julia make_onehot_and_format.jl ecoli
echo "processed, computing tsne"
julia make_tsne.jl ecoli 2000