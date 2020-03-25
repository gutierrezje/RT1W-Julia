using FileIO, DelimitedFiles
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

function randomScene()
    world = HittableList()

    push!(world, Sphere(Vec3(0, -1000, 0), 1000, Lambertian(Vec3(0.5, 0.5, 0.5))))

    for a = -5:5
        for b = -5:5
            chooseMat = rand()
            center = Vec3(a + 0.9 * rand(), 0.2, b + 0.9*rand())
            if length(center - Vec3(4, 0.2, 0)) > 0.9
                if chooseMat < 0.8
                    # diffuse
                    albedo = randomVec() * randomVec()
                    push!(world, Sphere(center, 0.2, Lambertian(albedo)))
                elseif chooseMat < 0.95
                    # metal
                    albedo = randomVec(0.5, 1)
                    fuzz = rangeRand(0, 0.5)
                    push!(world, Sphere(center, 0.2, Metal(albedo, fuzz)))
                else
                    # glass
                    push!(world, Sphere(center, 0.2, Dielectric(1.5)))
                end
            end
        end
    end
    push!(world, Sphere(Vec3(0, 1, 0), 1.0, Dielectric(1.5)))
    push!(world, Sphere(Vec3(-4, 1, 0), 1.0, Lambertian(Vec3(0.4, 0.2, 0.1))))
    push!(world, Sphere(Vec3(4, 1, 0), 1.0, Metal(Vec3(0.7, 0.6, 0.5), 0.0)))

    return world
end

function main()
    imageWidth, imageHeight = 960, 720
    ns = 100
    maxDepth = 50
    io = IOBuffer()
    println(io, "P3\n", imageWidth, " ", imageHeight, "\n255\n")

    world = randomScene()
    aspectRatio = imageWidth / imageHeight
    lookFrom = Vec3(13,2,3)
    lookAt = Vec3(0,0,0)
    vUp = Vec3(0,1,0)
    distToFocus = 10.0
    aperture = 0.1
    cam = Camera(lookFrom, lookAt, vUp, 20, aspectRatio, aperture, distToFocus)
    # Preallocating since mutable structs take a lot of memory
    rec = HitRecord()
    tempRec = HitRecord()
    for j = imageHeight:-1:1
        rowPix = Array{Int}(undef, (imageWidth, 3))
        for i = 1:imageWidth
            col = Vec3(0.0)
            for _ = 1:ns
                u, v = (i + rand()) / imageWidth, (j + rand()) / imageHeight
                r = getRay(cam, u, v)
                col += rayColor(r, world, maxDepth, rec, tempRec)
            end

            addPix!(rowPix, i, col, ns)
        end
        writedlm(io, rowPix, " ")
    end
    open("images/test.ppm", "w") do f
        write(f, take!(io))
    end
    close(io)
end

function addPix!(row, idx, v::Vec3, samplesPerPixel)
    scale = 1.0 / samplesPerPixel

    r = √(scale * v[1])
    g = √(scale * v[2])
    b = √(scale * v[3])

    r = round(Int, 255.99 * r)
    g = round(Int, 255.99 * g)
    b = round(Int, 255.99 * b)
    row[idx, 1:3] .= r, g, b
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
