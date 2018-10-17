using DelimitedFiles, CSV, DataFrames

inpath = "mfeat"
files = filter(x-> !occursin(".",x),readdir(inpath))
global X = readdlm(joinpath(inpath, files[1]))

for file in files[2:end]
	X = cat(X, readdlm(joinpath(inpath, file)), dims = 2)
end

y = fill(0,200)
for i in 1:9
	y = cat(y, fill(i,200), dims = 1)
end

yX = cat(y,X,dims=2)

df = convert(DataFrame, yX)
df[:,:x1] = Int.(df[:,:x1])

df |> CSV.write("data.csv"; writeheader = false)