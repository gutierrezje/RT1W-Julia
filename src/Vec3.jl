using StaticArrays
import LinearAlgebra: (⋅), (×)
import Base: (-), (+), (*), (/), getindex, show
struct Vec3
    e::SVector{3, Float32}
    ## Constructors
    Vec3() = new(SVector{3, Float32}(0.0, 0.0, 0.0))
    Vec3(x, y, z) = new(SVector{3, Float32}(x, y, z))
    Vec3(n::AbstractFloat) = new(SVector{3, Float32}(n, n, n))
    Vec3(v::SVector{3}) = new(v)
end

## Accessors
x(v::Vec3) = v.e[1]
y(v::Vec3) = v.e[2]
z(v::Vec3) = v.e[3]
getindex(v::Vec3, i::Int) = v.e[i]

## Negation operator
(-)(v::Vec3) = Vec3(-v.e)
## Vector-vector operators
(-)(v1::Vec3, v2::Vec3) = Vec3(v1.e - v2.e)
(+)(v1::Vec3, v2::Vec3) = Vec3(v1.e + v2.e)
(*)(v1::Vec3, v2::Vec3) = Vec3(v1.e * v2.e)
(/)(v1::Vec3, v2::Vec3) = Vec3(v1.e / v2.e)
(⋅)(v1::Vec3, v2::Vec3) = v1.e ⋅ v2.e
(×)(v1::Vec3, v2::Vec3) = Vec3(v1.e × v2.e)

## Scalar-vector operators
(*)(f, v::Vec3) = Vec3(f * v.e)
(*)(v::Vec3, f) = Vec3(v.e * f)
(/)(v::Vec3, f) = Vec3(v.e / f)

## Utility functions
length(v::Vec3) = sqrt(v.e[1] * v.e[1] + v.e[2] * v.e[2] + v.e[3] * v.e[3])
squaredLength(v::Vec3) = v.e[1] * v.e[1] + v.e[2] * v.e[2] + v.e[3] * v.e[3]
normalize(v::Vec3) = v.e / length(v)
unitVector(v::Vec3) = Vec3(v.e / length(v))
randomVec() = Vec3(@SVector rand(3))

show(io::IO, v::Vec3) = print(io, "$(v[1]) $(v[2]) $(v[3])")
