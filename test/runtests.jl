using UCI
using Test 

@testset "DATA" begin
	# class labels only in case of a multiclass dataset
	dataset = "abalone"
	xa = UCI.get_data(dataset)
	@test size(xa[1].normal) != (0,0)
	@test size(xa[1].easy) != (0,0)
	@test xa[2] == xa[3] == nothing	

	dataset = "breast-tissue"
	xa = UCI.get_data(dataset)
	@test size(xa[1].normal) != (0,0)
	@test size(xa[1].easy) == (0,0)
	@test xa[2] != xa[3] != nothing	

	# loda data have no class labels
	dataset = "abalone"
	xa = UCI.get_loda_data(dataset)
	@test size(xa[1].normal) != (0,0)
	@test size(xa[1].easy) != (0,0)
	@test xa[2] == xa[3] == nothing	

	dataset = "breast-tissue"
	xa = UCI.get_loda_data(dataset)
	@test size(xa[1].normal) != (0,0)
	@test size(xa[1].easy) != (0,0)
	@test xa[2] == xa[3] == nothing	
	
	dataset = "abalone"
	xa = UCI.get_umap_data(dataset)
	ya = UCI.create_multiclass(xa...)

	dataset = "cardiotocography"
	xc = UCI.get_umap_data(dataset)
	yc = UCI.create_multiclass(xc...)
		
	data_path = joinpath(dirname(@__FILE__), "../umap")
	@test abspath(UCI.get_umap_datapath()) == abspath(data_path)

	dataset = "yeast"
	xy = UCI.get_umap_data(dataset)
	yy = UCI.create_multiclass(xy...)

	zaa = UCI.split_data(ya[1][1], 0.8)
	zae = UCI.split_data(ya[1][1], 0.8, difficulty = :easy)
	zaem = UCI.split_data(ya[1][1], 0.8, difficulty = [:easy, :medium])

	zya = UCI.split_data(yy[1][1], 0.8)
	#zye = UCI.split_data(yy[1][1], 0.8, difficulty = :easy)
	zyem = UCI.split_data(yy[1][1], 0.8, difficulty = [:easy, :medium])

	@test typeof(xa[1]) == UCI.ADDataset
	@test length(ya) == 1

	@test typeof(xc[1]) == UCI.ADDataset
	@test length(yc) > 1
	@test yc[1][2] == "2-9"

	@test yy[1][2] == "CYT-MIT"

	@test size(zaa[1],2) == size(zaem[1],2) == size(zae[1],2)
	@test sum(zaa[2]) == sum(zae[2]) == sum(zaem[2]) == 0 
	@test size(zaa[3],2) > size(zaem[3],2) > size(zae[3],2)
	@test sum(zaa[4]) > sum(zaem[4]) > sum(zae[4]) > 0

	try
		zye = UCI.split_data(yy[1][1], 0.8, difficulty = :easy)
	catch e
		@test isa(e, ErrorException)
	end
	@test size(zya[1],2) == size(zyem[1],2)
	@test sum(zya[2])  == sum(zyem[2]) == 0 
	@test size(zya[3],2) == size(zyem[3],2)
	@test sum(zya[4]) == sum(zyem[4]) > 0

	dataset = "two-moons"
	data = UCI.get_synthetic_data(dataset)
	@test size(data.normal) == (2,500)
	@test size(data.medium) == (2,500)
	X_tr, y_tr, X_tst, Y_tst = UCI.split_data(data, 0.8)
	@test size(X_tr) == (2,400)
	@test size(X_tst) == (2,600)

	x_val, y_val, x_tst, y_tst = UCI.split_val_test(X_tst,Y_tst)
	m, n = size(X_tst)
	@test (m, floor(Int, n/2)) == size(x_val) == size(x_tst)
	@test floor(Int, n/2) == length(y_val) == length(y_tst)
	@test sum(y_val) + sum(y_tst) in [sum(Y_tst), sum(Y_tst)-1]
end
