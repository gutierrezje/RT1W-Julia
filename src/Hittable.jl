include("Ray.jl")
include("Material.jl")

abstract type Hittable end

mutable struct HitRecord <: Record
    t::Float32
    p::Vec3
    normal::Vec3
    frontFace::Bool
    material::Material
    HitRecord() = new(0.0, Vec3(), Vec3(), false, Lambertian(Vec3()))
end

@inline function setFaceNormal(rec::HitRecord, r::Ray, outwardNormal::Vec3)
    rec.frontFace = (direction(r) ⋅ outwardNormal) < 0.0
    rec.normal = rec.frontFace ? outwardNormal : -outwardNormal
end
