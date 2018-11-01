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

Outer constructor for the Basicset struct using a folder in the Loda database.
Transposes the arrays so that instances are columns.
"""
ADDataset(path::String) = (isdir(path)) ? ADDataset(
    txt2array(joinpath(path, "normal.txt"))',
    txt2array(joinpath(path, "easy.txt"))',
    txt2array(joinpath(path, "medium.txt"))',
    txt2array(joinpath(path, "hard.txt"))',
    txt2array(joinpath(path, "very_hard.txt"))',
    ) : error("No such path exists.")

vec2int(x::Vector) = map(y-> (typeof(y)<:Real) ? Int(y) : y, x) 
load_class_labels(path) = vec2int(vec(readdlm(joinpath(path,"normal_labels.txt")))), 
    vec2int(vec(readdlm(joinpath(path,"medium_labels.txt"))))

function  get_umap_data(dataset::String, path::String)
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

create_multiclass(data::ADDataset, normal_labels, anomaly_labels) = 
    (normal_labels==nothing) ? [(data, "")] : [(ADDataset(data.normal, 
                                                Array{Float32,2}(undef,0,0),
                                                data.medium[:,anomaly_labels.==class],
                                                Array{Float32,2}(undef,0,0),
                                                Array{Float32,2}(undef,0,0)), "$(normal_labels[1])-$(class)"
                                                ) for class in unique(anomaly_labels)]
                        
function split_data(data::ADDataset, p::Real=0.8; seed = nothing, difficulty = nothing)
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

    # split the data
    Ntr = Int(floor(p*N))
    return normal[:,1:Ntr], fill(0,Ntr), # training data and labels
        hcat(normal[:,Ntr+1:end], anomalous), vcat(fill(0,N-Ntr), fill(1,size(anomalous,2))) # testing data and labels
end