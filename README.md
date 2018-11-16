# UCI
Collection of UCI datasets tranformed into anomaly detection benchmarks.

The `raw` directory contains the raw data downlaoded from the UCI website. In the `processed` directory, the anomaly detection benchmarks are saved. They are divided into up to 5 files according to their difficulty. Also, the `data_types.txt` file contains the information on feature types. Code `0` is for numerical features, integers `1,2,...` are used for different one-hot encoded categorical features. See `processed/abalone/data_types.txt` - abalone contains one categorical feature with 3 possible values which are in the first three columns of data.

A UMAP transform to 2D is done for all datasets. N-class classification problems are split into more problems after the transformation. The largest class is fixed as the normal one, and then N-1 datasets are created with each of the remaining classes as the anomalous one. Transformed data are in the `umap` directory. Reffer to 'umap_grid_plots' to see the individual transformed datasets.

Directory `scripts` containg bash scripts used to process the data.

Now, this is also a Julia package with data extraction tools. See example usage (this is also in the `examples` dir).

# Installation

Use 'Pkg.clone' with this repository adress.

# Example usage

```julia
using UCI

# single class problem
dataset = "abalone"
data, normal_labels, anomaly_labels = UCI.get_umap_data(dataset)

# this creates training dataset with no anomalies and testing dataset with all anomalies
# data are split randomly in a given ratio (here 0.8), but you can fix the seed
X_tr, y_tr, X_tst, y_tst = UCI.split_data(data, 0.8; seed = 123)
# this creates testing dataset with hard only anomalies
X_tr, y_tr, X_tst, y_tst = UCI.split_data(data, 0.8, difficulty = :hard)
# this creates testing dataset with easy and very_hard only anomalies
X_tr, y_tr, X_tst, y_tst = UCI.split_data(data, 0.8, difficulty = [:easy, :hard])

# multiclass problem
dataset = "yeast"
# you have two options: either get a subdataset directly by index or subclass name
data, normal_labels, anomaly_labels = UCI.get_umap_data(dataset, 1)
data, normal_labels, anomaly_labels = UCI.get_umap_data(dataset, "NUC")

# or you can get all the subproblems together and iterate over them afterwards
data, normal_labels, anomaly_labels = UCI.get_umap_data(dataset)
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
```