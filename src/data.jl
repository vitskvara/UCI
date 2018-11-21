"""
   ADDataset

A structure representing an anomaly detection dataset with one normal class and
multiple anomaly classes split according to their difficulty. 
"""
struct ADDataset
    normal::Array{Float, 2}
    easy::Array{Float, 2}
    medium::Array{Float, 2}
    hard::Array{Float, 2}
    very_hard::Array{Float, 2}
end

"""
   txt2array(file)

If the file does not exist, returns an empty 2D array. 
"""
txt2array(file::String) = isfile(file) ? readdlm(file) : Array{Float32,2}(undef,0,0)

""" 
    ADDataset(path)

Constructor for the Basicset struct using a folder in the Loda database.
Transposes the arrays so that instances are columns. If a file (anomaly class)
is missing, an empty array is in its place in the resulting structure.
"""
ADDataset(path::String) = (isdir(path)) ? ADDataset(
    txt2array(joinpath(path, "normal.txt"))',
    txt2array(joinpath(path, "easy.txt"))',
    txt2array(joinpath(path, "medium.txt"))',
    txt2array(joinpath(path, "hard.txt"))',
    txt2array(joinpath(path, "very_hard.txt"))',
    ) : error("No such path exists.")

"""
    normalize(Y)

Scales down a 2 dimensional array so it has approx. standard normal distribution. 
Instance = column. 
"""
function normalize(Y::Array{T,2} where T<:Real)
    M, N = size(Y)
    mu = Statistics.mean(Y,dims=2);
    sigma = Statistics.var(Y,dims=2);

    # if there are NaN present, then sigma is zero for a given column -> 
    # the scaled down column is also zero
    # but we treat this more economically by setting the denominator for a given column to one
    # also, we deal with numerical zeroes
    den = sigma
    den[abs.(den) .<= 1e-15] .= 1.0
    den[den .== 0.0] .= 1.0
    den = repeat(sqrt.(den), 1, N)
    nom = Y - repeat(mu, 1, N)
    nom[abs.(nom) .<= 1e-8] .= 0.0
    Y = nom./den
    return Y
end

"""
   normalize(x,y)

Concatenate x and y along the 2nd axis, normalize them and split them again. 
"""
function normalize(x,y)
    M,N = size(x)
    data = cat(x, y, dims = 2)
    data = normalize(data)
    return data[:, 1:N], data[:, N+1:end]
end

"""
    vec2int(x)

Convert Float labels read by readdlm to Ints for prettier dataset names.
"""
vec2int(x::Vector) = map(y-> (typeof(y)<:Real) ? Int(y) : y, x) 

"""
    load_class_labels(path)

Load class labels saved in path.    
"""
load_class_labels(path) = vec2int(vec(readdlm(joinpath(path,"normal_labels.txt")))), 
    vec2int(vec(readdlm(joinpath(path,"medium_labels.txt"))))

"""
    get_datapath()

Get the absolute path of UMAP data.
"""
get_datapath() = joinpath(dirname(@__FILE__), "../umap")

"""
    get_raw_datapath()

Get the absolute path the raw data.
"""
get_raw_datapath() = joinpath(dirname(@__FILE__), "../raw")

"""
    get_umap_data(dataset_name; path)

For a given dataset name, loads the data from given directory.  Returns a structure of
type ADDataset, normal and anomalous data class labels. If dataset is not a multiclass
problem, then the labels equal to nothing.
"""
function get_umap_data(dataset::String; path::String = "")
    path = (path=="" ? get_datapath() : path)
	# get just those dirs that match the dataset pattern
	dataset_dirs = filter(x->x[1:length(dataset)]==dataset,
			   	filter(x->length(x)>=length(dataset), 
				readdir(path)))
	# for multiclass problems, extract just data from the master directory
	dir_name_lengths = length.(split.(dataset_dirs, "-"))
	dataset_dir = joinpath(path, dataset_dirs[dir_name_lengths.==minimum(dir_name_lengths)][1])

	# load data and class labels if available
	data = ADDataset(dataset_dir)
	if isfile(joinpath(dataset_dir, "normal_labels.txt"))
		normal_class_labels, anomaly_class_labels = load_class_labels(dataset_dir)
	else
		normal_class_labels, anomaly_class_labels = nothing, nothing
	end

	return data, normal_class_labels, anomaly_class_labels
end

"""
    get_umap_data(dataset_name, subclass; path)

For a given dataset name, loads the data from given directory.  Returns a structure of
type ADDataset, normal and anomalous data class labels. If dataset is not a multiclass
problem, then the labels equal to nothing.
"""
function get_umap_data(dataset::String, subclass::Union{Int, String}; path::String = "")
    data, normal_class_labels, anomaly_class_labels = get_umap_data(dataset; path=path)
    subsets = create_multiclass(data, normal_class_labels, anomaly_class_labels)
    Ns = length(subsets)
    if Ns == 1
        return data, normal_class_labels, anomaly_class_labels
    end
    if typeof(subclass) == Int
        subclass = min(Ns,subclass)
        nlabel = normal_class_labels[1]
        alabel = split(subsets[subclass][2], nlabel)[2][2:end]
        return subsets[subclass][1], normal_class_labels, fill(alabel, sum(anomaly_class_labels.==alabel))
    elseif typeof(subclass) == String
        inds = occursin.(subclass, [x[2] for x in subsets])
        if sum(inds)==0 error("no subclass $subclass in dataset $dataset") end
        return subsets[inds][1][1], normal_class_labels, fill(subclass,  sum(anomaly_class_labels.==subclass))
    end
end

"""
    create_multiclass(data::ADDataset, normal_labels, anomaly_labels)

From given labels, return an iterable over all multiclass subproblems and the subproblem names. 
Works even if the problem is not multiclass.
"""
create_multiclass(data::ADDataset, normal_labels, anomaly_labels) = 
    (normal_labels==nothing) ? [(data, "")] : [(ADDataset(data.normal, 
                                                Array{Float32,2}(undef,0,0),
                                                data.medium[:,anomaly_labels.==class],
                                                Array{Float32,2}(undef,0,0),
                                                Array{Float32,2}(undef,0,0)), "$(normal_labels[1])-$(class)"
                                                ) for class in unique(anomaly_labels)]
                        
"""
    split_data(data::ADDataset, p::Real=0.8; seed = nothing, difficulty = nothing,
        standardize=false)

Creates training and testing data fro ma given ADDataset struct.
"""
function split_data(data::ADDataset, p::Real=0.8; seed = nothing, difficulty = nothing, 
    standardize=false)
    @assert 0 <= p <= 1
    normal = data.normal
    if difficulty == nothing # sample all anomaly classes into the test dataset
        anomalous = Array{Float,2}(undef,size(data.normal,1),0)
        for diff in filter(y-> y!= :normal, [a for a in fieldnames(typeof(data))])
            x = getfield(data,diff)
            if prod(size(x)) != 0
                anomalous = hcat(anomalous, x)
            end
        end
    elseif typeof(difficulty) == Array{Symbol,1}
        anomalous = Array{Float,2}(undef,size(data.normal,1),0)
        for diff in intersect(difficulty, fieldnames(typeof(data)))
            x = getfield(data,diff)
            if prod(size(x)) != 0
                anomalous = hcat(anomalous, x)
            end
        end
    else
        anomalous = getfield(data, difficulty)
        if prod(size(anomalous)) == 0
            error("no data of given difficulty level!")
        end
    end

    # shuffle the data
    (seed == nothing) ? nothing : Random.seed!(seed)
    N = size(normal,2)
    normal = normal[:,StatsBase.sample(1:N, N, replace = false)]
    Random.seed!() # reset the seed

    # normalize the data if necessary (so that they have 0 mean and unit variance)
    if standardize
        normal, anomalous = normalize(normal, anomalous)
    end

    # split the data
    Ntr = Int(floor(p*N))
    return normal[:,1:Ntr], fill(0,Ntr), # training data and labels
        hcat(normal[:,Ntr+1:end], anomalous), vcat(fill(0,N-Ntr), fill(1,size(anomalous,2))) # testing data and labels
end