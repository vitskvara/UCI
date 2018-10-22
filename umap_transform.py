import umap
#from sklearn.datasets import load_digits

#digits = load_digits()

#embedding = umap.UMAP().fit_transform(digits.data)
import numpy
data = numpy.random.normal(0,1,(10000,30))
embedding = umap.UMAP().fit_transform(data)