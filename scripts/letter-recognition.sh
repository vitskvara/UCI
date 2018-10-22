julia process_multiclass.jl letter-recognition 2 1
echo "created multiclass problems, doing one-hot encoding and labeling"
julia make_onehot_and_format.jl letter-recognition
echo "processed, computing tsne"
julia make_tsne.jl isolet 3000