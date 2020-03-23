using FileIO
include("HittableList.jl")
include("Sphere.jl")
include("Camera.jl")

function rayColor(r::Ray, world::Hittable, rec::HitRecord, tempRec::HitRecord) ::Vec3
    #rec = HitRecord()
    if hit(world, r, 0.0, typemax(Float32), rec, tempRec)
        return 0.5 * Vec3(x(rec.normal) + 1.0, y(rec.normal) + 1.0, z(rec.normal) + 1.0)
    else
        unitDirection = unitVector(direction(r))
        t = 0.5 * (y(unitDirection) + 1.0)
        return (1.0 - t) * Vec3(1.0, 1.0, 1.0) + t * Vec3(0.5, 0.7, 1.0)
    end
end

function main()
    nx, ny, ns = 200, 100, 100
    io = open("image.ppm", "w")
    println(io, "P3\n", nx, " ", ny, "\n255\n")

    world = HittableList{2}()
    world[1] = Sphere(Vec3(0.0,0.0,-1.0), 0.5)
    world[2] = Sphere(Vec3(0.0,-100.5, -1.0), 100)

    cam = Camera()
    # Preallocating since mutable structs take a lot of memory
    rec = HitRecord()
    tempRec = HitRecord()

    for j in ny:-1:1
        for i in 1:nx
            col = Vec3(0.0)
            for _ in 1:ns
                u, v = (i + rand()) / nx, (j + rand()) / ny
                r = getRay(cam, u, v)
                col += rayColor(r, world, rec, tempRec)
            end
            col /= ns
            col *= 255.99

            ir = round(Int, col[1])
            ig = round(Int, col[2])
            ib = round(Int, col[3])
            println(io, ir, " ", ig, " ", ib)
        end
    end
    close(io)
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
