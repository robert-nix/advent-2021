using Statistics

line = open("input") do f read(f, String) end
xs = map(s -> parse(Int, s), split(line, ","))

print_sums(coll) = println(Integer(reduce(+, coll)))

# part 1: minimize sum of absolute errors, i.e. median
med = median(xs)
print_sums(map(x -> abs(x - med), xs))

# part 2: minimize sum of errors (x-xi)*((x-xi)+1)/2
# d/dx = sum[x - xi + 1/2] = 0
#     -> sum[x + 1/2] = sum[xi]
#     -> Nx + N/2 = sum[xi]
#     -> x = sum[xi]/N - 1/2
# and round to the nearest integer
triangle(n) = n*(n+1)/2
m = round(mean(xs)-0.5)
print_sums(map(x -> triangle(abs(x - m)), xs))