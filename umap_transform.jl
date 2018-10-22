using PyCall
@pyimport umap
#@pyimport sklearn.datasets as sd

#digits = sd.load_digits()

#embedding = umap.UMAP()[:fit_transform](digits["data"])

data = randn(1000,30)
embedding = umap.UMAP(n_neighbors=5,
					  min_dist=0.4,
					  metric="correlation")[:fit_transform](data)
