include("Hittable.jl")
import Base: getindex, size, setindex!, push!

struct HittableList <: Hittable
    objects::Vector{Hittable}
    HittableList() = new(Vector{Hittable}())
end

getindex(hl::HittableList, i::Int) = getindex(hl.objects, i)
setindex!(hl::HittableList, v::Hittable, i::Int) = setindex!(hl.objects, v, i)
size(hl::HittableList) = size(hl.objects)[1]
push!(hl::HittableList, v::Hittable) = push!(hl.objects, v)

function hit(hl::HittableList, r::Ray, tMin, tMax, rec::HitRecord, tempRec::HitRecord)
    hitAnything = false
    closestSoFar = tMax

    for i = 1:size(hl)
        if hit(hl[i], r, tMin, closestSoFar, tempRec)
            hitAnything = true
            closestSoFar = tempRec.t
            rec.t = tempRec.t
            rec.p = tempRec.p
            rec.normal = tempRec.normal
            rec.frontFace = tempRec.frontFace
            rec.material = tempRec.material
        end
    end
    return hitAnything
end
