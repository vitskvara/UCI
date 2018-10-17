echo "created multiclass problems, doing one-hot encoding and labeling"
julia make_onehot_and_format.jl magic-telescope
echo "processed, computing tsne"
julia make_tsne.jl magic-telescope 3000