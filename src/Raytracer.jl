using FileIO
include("HittableList.jl")
include("Sphere.jl")
include("Camera.jl")

function rayColor(r::Ray, world::Hittable, depth,
        rec::HitRecord, tempRec::HitRecord) ::Vec3
    if depth <= 0
        return Vec3(0.0)
    end

    if hit(world, r, 0.001, typemax(Float32), rec, tempRec)
        scattered, attenuation, isScattered = scatter(rec.material, r, rec)
        if isScattered
            return attenuation * rayColor(scattered, world, depth-1, rec, tempRec)
        end
        return Vec3(0.0)
    end

    unitDirection = unitVector(direction(r))
    t = 0.5 * (y(unitDirection) + 1.0)
    return (1.0 - t) * Vec3(1.0, 1.0, 1.0) + t * Vec3(0.5, 0.7, 1.0)
end

function main()
    imageWidth, imageHeight = 200, 100
    ns = 100
    maxDepth = 50
    io = open("images/chapter11.ppm", "w")
    println(io, "P3\n", imageWidth, " ", imageHeight, "\n255\n")

    world = HittableList()
    push!(world, Sphere(Vec3(0, 0, -1), 0.5, Lambertian(Vec3(0.1, 0.2, 0.5))))
    push!(world, Sphere(Vec3(0, -100.5, -1), 100, Lambertian(Vec3(0.8, 0.8, 0.0))))
    push!(world, Sphere(Vec3(1, 0, -1), 0.5, Metal(Vec3(0.8, 0.6, 0.2), 0.0)))
    push!(world, Sphere(Vec3(-1, 0, -1), 0.5, Dielectric(1.5)))
    push!(world, Sphere(Vec3(-1, 0, -1), -0.45, Dielectric(1.5)))

    aspectRatio = imageWidth / imageHeight
    cam = Camera(Vec3(-2,2,1), Vec3(0,0,-1),Vec3(0,1,0), 20, aspectRatio)
    # Preallocating since mutable structs take a lot of memory
    rec = HitRecord()
    tempRec = HitRecord()
    for j = imageHeight:-1:1
        for i = 1:imageWidth
            col = Vec3(0.0)
            for _ = 1:ns
                u, v = (i + rand()) / imageWidth, (j + rand()) / imageHeight
                r = getRay(cam, u, v)
                col += rayColor(r, world, maxDepth, rec, tempRec)
            end

            writeColor(col, io, ns)
        end
    end
    close(io)
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
