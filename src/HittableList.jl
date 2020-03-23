include("Hittable.jl")
import Base: getindex, size, setindex!

struct HittableList{N} <: Hittable where N
    objects::Vector{Hittable}
    HittableList{N}() where N = new(Vector{Hittable}(undef, N))
    #HittableList{N}(objs) where N = new(objs)
    #HittableList{N}(obj...) where N = new(Vector{Hittable}(obj..., N))
end

getindex(hl::HittableList, i::Int) = getindex(hl.objects, i)
setindex!(hl::HittableList, v::Hittable, i::Int) = setindex!(hl.objects, v, i)
size(hl::HittableList) = size(hl.objects)[1]

function hit(hl::HittableList, r::Ray, tMin, tMax, rec::HitRecord, tempRec::HitRecord)
    #tempRec = HitRecord()
    hitAnything = false
    closestSoFar = tMax

    for i in 1:size(hl)
        if hit(hl[i], r, tMin, closestSoFar, tempRec)
            hitAnything = true
            closestSoFar = tempRec.t
            rec.t = tempRec.t
            rec.p = tempRec.p
            rec.normal = tempRec.normal
        end
    end
    return hitAnything
end
