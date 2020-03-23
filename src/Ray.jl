include("Vec3.jl")

struct Ray
    orig::Vec3
    dir::Vec3
    Ray() = new(Vec3(), Vec3())
    Ray(orig::Vec3, dir::Vec3) = new(orig, dir)
end

origin(r::Ray) = r.orig
direction(r::Ray) = r.dir
pointAt(r::Ray, t) = r.orig + t * r.dir
