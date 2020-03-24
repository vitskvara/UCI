# run this script to get some knowledge of the available datasets
using UCI, DataFrames

println("Original Loda data overview:")
df = UCI.data_info(UCI.get_loda_datapath())
print(df)
println("")

println("Processed data overview:")
df = UCI.data_info(UCI.get_processed_datapath())
print(df)
println("")

println("UMAP data overview:")
df = UCI.data_info(UCI.get_umap_datapath())
print(df)
println("")
