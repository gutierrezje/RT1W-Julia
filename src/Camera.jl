include("Ray.jl")

struct Camera
    lowerLeftCorner::Vec3
    horizontal::Vec3
    vertical::Vec3
    origin::Vec3
    u::Vec3
    v::Vec3
    w::Vec3
    lensRadius::Float32

    function Camera(lookFrom::Vec3, lookAt::Vec3, vUp::Vec3,
            vfov, aspect, aperture, focusDist)
        θ = deg2rad(vfov)
        halfHeight = tan(θ/2)
        halfWidth = aspect * halfHeight

        w = unitVector(lookFrom - lookAt)
        u = unitVector(vUp × w)
        v = w × u

        return new(lookFrom
            - halfWidth * focusDist * u
            - halfHeight * focusDist *v
            - focusDist * w,
            2 * halfWidth * focusDist * u,
            2 * halfHeight * focusDist * v,
            lookFrom, u, v, w, aperture/2)
    end
end

function getRay(c::Camera, s, t) ::Ray
    rd = c.lensRadius * randomInUnitDisk()
    offset = c.u * x(rd) + c.v * y(rd)

    return Ray(c.origin + offset,
        c.lowerLeftCorner + s*c.horizontal + t*c.vertical - c.origin - offset)
end
