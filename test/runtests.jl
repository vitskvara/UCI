using UCI
using Test 

@testset "DATA" begin
	dataset = "abalone"
	xa = UCI.get_umap_data(dataset)
	ya = UCI.create_multiclass(xa...)

	dataset = "cardiotocography"
	xc = UCI.get_umap_data(dataset)
	yc = UCI.create_multiclass(xc...)
		
	data_path = joinpath(dirname(@__FILE__), "../umap")
	@test abspath(UCI.get_datapath()) == abspath(data_path)

	dataset = "yeast"
	xy = UCI.get_umap_data(dataset, data_path)
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
end
