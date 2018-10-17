julia process_multiclass.jl breast-tissue 3 2
echo "created multiclass problems, doing one-hot encoding and labeling"
julia make_onehot_and_format.jl breast-tissue
echo "processed, computing tsne"
julia make_tsne.jl breast-tissue 2500