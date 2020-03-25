include("Hittable.jl")

struct Sphere <: Hittable
    center::Vec3
    radius::Float32
    material::Material
end

function hit(s::Sphere, r::Ray, tMin, tMax, rec::HitRecord) ::Bool
    oc = origin(r) - s.center
    a = squaredLength(direction(r))
    b  = (oc ⋅ direction(r))
    c = squaredLength(oc) - s.radius*s.radius
    discriminant = b*b - a*c
    if discriminant > 0.0
        root = sqrt(discriminant)
        temp = (-b - root) / a
        if temp < tMax && temp > tMin
            rec.t = temp
            rec.p = pointAt(r, rec.t)
            outwardNormal = (rec.p - s.center) / s.radius
            setFaceNormal(rec, r, outwardNormal)
            rec.material = s.material
            return true
        end
        temp = (-b + root) / a
        if (temp < tMax && temp > tMin)
            rec.t = temp
            rec.p = pointAt(r, rec.t)
            outwardNormal = (rec.p - s.center) / s.radius
            setFaceNormal(rec, r, outwardNormal)
            rec.material = s.material
            return true
        end
    end
    return false
end
