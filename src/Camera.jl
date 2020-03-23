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
end

function getRay(c::Camera, u, v) ::Ray
    return Ray(c.origin,
        c.lowerLeftCorner + u*c.horizontal + v*c.vertical - c.origin)
end
