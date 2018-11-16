using UCI

# single class problem
dataset = "abalone"
data, normal_labels, anomaly_labels = UCI.get_umap_data(dataset)
println(dataset)
for field in fieldnames(typeof(data))
	println(field, ": ", size(getfield(data, field)))
end
# this creates training dataset with no anomalies and testing dataset with all anomalies
# data are split randomly, but you can fix the seed
X_tr, y_tr, X_tst, y_tst = UCI.split_data(data, 0.8; seed = 123)
# this creates testing dataset with hard only anomalies
X_tr, y_tr, X_tst, y_tst = UCI.split_data(data, 0.8, difficulty = :hard)
# this creates testing dataset with easy an very_hard only anomalies
X_tr, y_tr, X_tst, y_tst = UCI.split_data(data, 0.8, difficulty = [:easy, :hard])
println("")

# multiclass problem
dataset = "yeast"
# you have two options: either get a subdataset directly by index or subclass name
data, normal_labels, anomaly_labels = UCI.get_umap_data(dataset, 1)
# in multiclass problems, all anomalies are medium difficulty
println(dataset*" "*normal_labels[1]*"-"*anomaly_labels[1])
for field in [:normal, :medium]
	println(field, ": ", size(getfield(data, field)))
end
println("")

data, normal_labels, anomaly_labels = UCI.get_umap_data(dataset, "NUC")
println(dataset*" "*normal_labels[1]*"-"*anomaly_labels[1])
for field in [:normal, :medium]
	println(field, ": ", size(getfield(data, field)))
end
println("")

# ar you can get all the subproblems together and iterate over them afterwards
data, normal_labels, anomaly_labels = UCI.get_umap_data(dataset)
println(dataset)
for field in fieldnames(typeof(data))
	println(field, ": ", size(getfield(data, field)))
end
println("")

# this will give you an iterable over all subproblems
subdatasets = UCI.create_multiclass(data, normal_labels, anomaly_labels)
for (subdata, class_label) in subdatasets
	println(dataset*" "*class_label)
	# in multiclass problems, all anomalies are medium difficulty
	for field in [:normal, :medium]
		println(field, ": ", size(getfield(subdata, field)))
	end
	_X_tr, _y_tr, _X_tst, _y_tst = UCI.split_data(subdata, 0.8)
	println("")
end

# create_multiclass works on non-multiclass problems as well
# class label is and empty string
dataset = "madelon"
data, normal_labels, anomaly_labels = UCI.get_umap_data(dataset)
subdatasets = UCI.create_multiclass(data, normal_labels, anomaly_labels)
for (subdata, class_label) in subdatasets
	println(dataset*" "*class_label)
	for field in [:normal, :medium]
		println(field, ": ", size(getfield(subdata, field)))
	end
	_X_tr, _y_tr, _X_tst, _y_tst = UCI.split_data(subdata, 0.8)
	println("")
end

