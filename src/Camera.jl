include("Ray.jl")

struct Camera
    lowerLeftCorner::Vec3
    horizontal::Vec3
    vertical::Vec3
    origin::Vec3

    Camera() = new(
        Vec3(-2.0, -1.0, -1.0),
        Vec3( 4.0,  0.0,  0.0),
        Vec3( 0.0,  2.0,  0.0),
        Vec3( 0.0,  0.0,  0.0)
    )

    function Camera(lookFrom::Vec3, lookAt::Vec3, vUp::Vec3, vfov, aspect)
        θ = deg2rad(vfov)
        halfHeight = tan(θ/2)
        halfWidth = aspect * halfHeight
        w = unitVector(lookFrom - lookAt)
        u = unitVector(vUp × w)
        v = w × u

        return new(
            lookFrom - halfWidth*u - halfHeight*v - w,
            2*halfWidth*u,
            2*halfHeight*v,
            lookFrom
        )
    end
end

function getRay(c::Camera, u, v) ::Ray
    return Ray(c.origin,
        c.lowerLeftCorner + u*c.horizontal + v*c.vertical - c.origin)
end
