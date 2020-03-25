abstract type Material end

abstract type Record end

struct Lambertian <: Material
    albedo::Vec3
end

function scatter(m::Lambertian, rIn::Ray, rec::Record)
    scatterDirection = rec.normal + randomUnitVector()
    scattered = Ray(rec.p, scatterDirection)
    attenuation = m.albedo
    return (scattered, attenuation, true)
end

struct Metal <: Material
    albedo::Vec3
    fuzz::Float32
end

function scatter(m::Metal, rIn::Ray, rec::Record)
    reflected = reflect!(unitVector(direction(rIn)), rec.normal)
    scattered = Ray(rec.p, reflected + m.fuzz*randomInUnitSphere())
    attenuation = m.albedo
    isScattered = (direction(scattered) ⋅ rec.normal) > 0
    return (scattered, attenuation, isScattered)
end

struct Dielectric <: Material
    refractIdx::Float32
end

function scatter(m::Dielectric, rIn::Ray, rec::Record)
    attenuation = Vec3(1.0)
    etaOverEtap = rec.frontFace ? 1.0 / m.refractIdx : m.refractIdx

    unitDirection = unitVector(direction(rIn))
    cosθ = min(-unitDirection ⋅ rec.normal, 1.0)
    sinθ = √(1.0 - cosθ*cosθ)
    if etaOverEtap * sinθ > 1.0
        # Must reflect
        reflected = reflect!(unitDirection, rec.normal)
        scattered = Ray(rec.p, reflected)
        return (scattered, attenuation, true)
    end
    reflectProb = schlick(cosθ, etaOverEtap)
    if rand() < reflectProb
        reflected = reflect!(unitDirection, rec.normal)
        scattered = Ray(rec.p, reflected)
        return (scattered, attenuation, true)
    end

    # Can refract
    refracted = refract(unitDirection, rec.normal, etaOverEtap)
    scattered = Ray(rec.p, refracted)
    return (scattered, attenuation, true)
end

function schlick(cosine, refractIdx)
    r₀ = (1.0 - refractIdx) / (1.0 + refractIdx)
    r₀ *= r₀
    return r₀ + (1.0 - r₀) * (1.0 - cosine)^5
end
