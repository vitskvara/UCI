using UCI

# single class problem
dataset = "abalone"
data, normal_labels, anomaly_labels = UCI.get_umap_data(dataset)
println(dataset)
for field in fieldnames(typeof(data))
	println(field, ": ", size(getfield(data, field)))
end
# this creates training dataset with no anomalies and testing dataset with all anomalies
X_tr, y_tr, X_tst, y_tst = UCI.split_data(data, 0.8)
# this creates testing dataset with hard only anomalies
X_tr, y_tr, X_tst, y_tst = UCI.split_data(data, 0.8, difficulty = :hard)
# this creates testing dataset with easy an very_hard only anomalies
X_tr, y_tr, X_tst, y_tst = UCI.split_data(data, 0.8, difficulty = [:easy, :hard])
println("")

# multiclass problem
# in multiclass problems, all anomalies are medium difficulty
dataset = "yeast"
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
	for field in [:normal, :medium]
		println(field, ": ", size(getfield(subdata, field)))
	end
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
	println("")
end

