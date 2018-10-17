#julia process_multiclass.jl breast-cancer-wisconsin
echo "created multiclass problems, doing one-hot encoding and labeling"
julia make_onehot_and_format.jl breast-cancer-wisconsin
echo "processed, computing tsne"
julia make_tsne.jl breast-cancer-wisconsin 2500