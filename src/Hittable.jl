include("Ray.jl")

abstract type Hittable end

mutable struct HitRecord
    t::Float32
    p::Vec3
    normal::Vec3
    HitRecord() = new(0.0, Vec3(), Vec3())
end
