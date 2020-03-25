using StaticArrays, Distributions
import LinearAlgebra: (⋅), (×)
import Base: (-), (+), (*), (/), getindex, length, show
struct Vec3
    e::SVector{3, Float32}
    ## Constructors
    Vec3() = new(SVector{3, Float32}(0.0, 0.0, 0.0))
    Vec3(x, y, z) = new(SVector{3, Float32}(x, y, z))
    Vec3(n::Number) = new(SVector{3, Float32}(n, n, n))
    Vec3(v::SVector{3}) = new(v)
end

## Accessors
x(v::Vec3) = v.e[1]
y(v::Vec3) = v.e[2]
z(v::Vec3) = v.e[3]
getindex(v::Vec3, i::Int) = v.e[i]
getindex(v::Vec3, r::UnitRange{Int}) = v.e[r]

## Negation operator
(-)(v::Vec3) = Vec3(-v.e)
## Vector-vector operators
(-)(v1::Vec3, v2::Vec3) = Vec3(v1.e - v2.e)
(+)(v1::Vec3, v2::Vec3) = Vec3(v1.e + v2.e)
(*)(v1::Vec3, v2::Vec3) = Vec3(v1.e .* v2.e)
(/)(v1::Vec3, v2::Vec3) = Vec3(v1.e / v2.e)
(⋅)(v1::Vec3, v2::Vec3) = v1.e ⋅ v2.e
(×)(v1::Vec3, v2::Vec3) = Vec3(v1.e × v2.e)

## Scalar-vector operators
(*)(f, v::Vec3) = Vec3(f * v.e)
(*)(v::Vec3, f) = Vec3(v.e * f)
(/)(v::Vec3, f) = Vec3(v.e / f)

## Utility functions
length(v::Vec3) = √(v.e[1] * v.e[1] + v.e[2] * v.e[2] + v.e[3] * v.e[3])
squaredLength(v::Vec3) = v.e[1] * v.e[1] + v.e[2] * v.e[2] + v.e[3] * v.e[3]
normalize!(v::Vec3) = v.e / length(v)
unitVector(v::Vec3) = Vec3(v.e / length(v))

reflect!(v::Vec3, n::Vec3) = v - 2(v ⋅ n)*n
function refract(uv::Vec3, n::Vec3, etaOverEtap)
    cosθ = min((-uv) ⋅ n, 1.0)
    rPar = etaOverEtap * (uv + cosθ*n)
    rPerp = -√(1.0 - squaredLength(rPar)) * n
    return rPar + rPerp
end

randomVec() = Vec3(@SVector rand(3))
randomVec(l, h) = Vec3(@SVector [rangeRand(l,h), rangeRand(l,h), rangeRand(l,h)])
@inline rangeRand(l, h) = rand(Uniform(l, h))

# cos³(ϕ) distribution
function randomInUnitSphere()
    while true
        p = randomVec(-1, 1)
        if (squaredLength(p) >= 1) continue end
        return p
    end
end

# cos(ϕ) (Lambertian diffuse) distribution
function randomUnitVector()
    a = rangeRand(0, 2π)
    z = rangeRand(-1, 1)
    r = √(1 - z*z)
    return Vec3(r*cos(a), r*sin(a), z)
end

function randomInUnitDisk()
    while true
        p = Vec3(rangeRand(-1,1), rangeRand(-1,1), 0)
        if (squaredLength(p) >= 1) continue end
        return p
    end
end

## IO
function writeColor(v::Vec3, io::IOStream, samplesPerPixel)
    scale = 1.0 / samplesPerPixel

    r = √(scale * v[1])
    g = √(scale * v[2])
    b = √(scale * v[3])

    r = round(Int, 255.99 * r)
    g = round(Int, 255.99 * g)
    b = round(Int, 255.99 * b)
    println(io, r, " ", g, " ", b)
end
