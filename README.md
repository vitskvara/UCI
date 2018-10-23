# UCI
Collection of UCI datasets tranformed into anomaly detection benchmarks.

The `raw` directory contains the raw data downlaoded from the USI website. In the `processed` directory, the anomaly detection benchmarks are saved. They are divided into up to 5 files according to their difficulty. Also, the `data_types.txt` file contains the information on feature types. Code `0` is for numerical features, integers `1,2,...` are used for different one-hot encoded categorical features. See `processed/abalone/data_types.txt` - abalone contains one categorical feature with 3 possible values which are in the first three columns of data.

A UMAP transform to 2D is done for all datasets. N-class classification problems are split into more problems after the transformation. The largest class is fixed as the normal one, and then N-1 datasets are created with each of the remaining classes as the anomalous one. Transformed data are in the `umap` directory together with some plots.

Directory `scripts` containg bash scripts used to process the data.