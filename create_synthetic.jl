using StatsBase
using DelimitedFiles
using PyPlot

outpath = "synthetic"
mkpath(outpath)

polar(R::Real, θ::Real) = [R*cos(θ), R*sin(θ)]
circular_section(μ::Vector, R::Real, N::Int, θ1::Real, θ2::Real) = μ .+ hcat(map(x->polar(R, x),range(θ1,stop=θ2,length=N))...)
circle(μ::Vector, R::Real, N::Int) = circular_section(μ, R, N, 0, 2*pi)
rand_ring(μ::Vector, R::Real, N::Int, sd) = circle(μ, R, N) .+ randn(2, N).*sd
rand_rings(μs, Rs::Vector, Ns::Vector, sds) = map(rand_ring, μs, Rs, Ns, sds)
rand_rings(Rs::Vector, Ns::Vector, sds) = rand_rings([zeros(2) for i in 1:length(Rs)], Rs, Ns, sds)
function save_data(normal, anomalous, savepath)
	mkpath(savepath)
	writedlm(joinpath(savepath, "normal.txt"), normal')
	writedlm(joinpath(savepath, "medium.txt"), anomalous')
end

# first, create two rings
normal, anomalous = rand_rings([5,10], [500,500], [0.7,1])

#save them
save_data(normal, anomalous, joinpath(outpath, "two-rings-1"))

# swap the labels
save_data(anomalous, normal, joinpath(outpath, "two-rings-2"))

# create three rings
r1, r2, r3 = rand_rings([5,15,25], [500,500,500], [1,1.5,2])
normal = r2
anomalous = hcat(r1, r3)

# save the data
save_data(anomalous, normal, joinpath(outpath, "three-rings-1"))
save_data(normal, anomalous, joinpath(outpath, "three-rings-2"))

# create two close clusters
normal = randn(2,500).*[1,3].+[2,2]
anomalous = reshape([1,0.5,0.5,1],2,2)*randn(2,500).+[-3,-1]
save_data(normal, anomalous, joinpath(outpath, "two-gaussians"))

# create three close clusters
normal = randn(2,500).*[1,3].+[2,2]
anomalous = reshape([1,0.5,0.5,1],2,2)*randn(2,500).+[-3,-1]
anomalous = hcat(anomalous, reshape([0.7,0,0,1],2,2)*randn(2,500).+[6,4])
save_data(normal, anomalous, joinpath(outpath, "three-gaussians-1"))
save_data(anomalous, normal, joinpath(outpath, "three-gaussians-2"))

# now also create two moons/bananas
moon(μ::Vector, R::Real, N::Int, θ1::Real, θ2::Real, maxsd::Real) = 
	circular_section(μ, R, N, θ1, θ2) .+ randn(2, N).*(vcat(range(0,stop=maxsd,length=Int(floor(N/2))), 
		range(maxsd,stop=0,length=Int(ceil(N/2)))))'
banana(μ::Vector, R::Real, N::Int, θ1::Real, θ2::Real, maxsd::Real) = 
	circular_section(μ, R, N, θ1, θ2) .+ randn(2, N).*(vcat(range(maxsd/2,stop=maxsd,length=Int(floor(N/2))), 
		range(maxsd,stop=maxsd/2,length=Int(ceil(N/2)))))'

# generate two moons
normal = moon([-1,-0.4], 2, 500, 0, pi, 0.2)
anomalous = moon([1,0.4], 2, 500, pi, 2*pi, 0.2)
save_data(normal, anomalous, joinpath(outpath, "two-moons"))

# generate the bananas
normal = banana([-1,-0.4], 2, 500, 0, pi, 0.2)
anomalous = banana([1,0.4], 2, 500, pi, 2*pi, 0.2)
save_data(normal, anomalous, joinpath(outpath, "two-bananas"))

figure()
scatter(normal[1,:], normal[2,:], label="normal")
scatter(anomalous[1,:], anomalous[2,:], label="anomalous")
legend()
show()

