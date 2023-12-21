//
//  main.swift
//  raytracer1
//
//  Created by Anthony Clark on 12/24/20.
//

import Foundation


//
// A utility to print to STDERR
//

public struct StandardErrorOutputStream: TextOutputStream {
    public mutating func write(_ string: String) { fputs(string, stderr) }
}
public var stdErr = StandardErrorOutputStream()

//
// Generate the default scene from the book
//

func generateRandomScene() -> HittableList {
    let world = HittableList()
    
    let groundMaterial = Lambertian(albedo: Color(r: 0.5, g: 0.5, b: 0.5))
    world.add(Sphere(center: Point(x: 0, y: -1000, z: 0), radius: 1000, material: groundMaterial))

    for a in -11 ... 11 {
        for b in -11 ... 11 {
            let center = Vec(
                x: Scalar(a) + 0.9*Scalar.random(in: 0...1),
                y: 0.2,
                z: Scalar(b) + 0.9*Scalar.random(in: 0...1))

            if (center - Vec(x: 4, y: 0.2, z: 0)).length() < 0.9 {
                continue
            }

            var material: Material
            switch Scalar.random(in: 0...1) {
            case 0...0.8:
                let albedo = Color.getRandom()
                material = Lambertian(albedo: albedo)
            case 0.8...0.95:
                let albedo = Color.getRandom(lo: 0.5, hi: 1)
                let fuzz = Scalar.random(in: 0...0.5)
                material = Metal(albedo: albedo, fuzz: fuzz)
            default:
                material = Dielectric(indexOfRefraction: 1.5)
            }

            world.add(Sphere(center: center, radius: 0.2, material: material))
        }
    }
    
    world.add(Sphere(center: Point(x: 0, y: 1, z: 0), radius: 1.0, material: Dielectric(indexOfRefraction: 1.5)))
    
    world.add(Sphere(center: Point(x: -4, y: 1, z: 0), radius: 1.0, material: Lambertian(albedo: Color(r: 0.4, g: 0.2, b: 0.1))))

    world.add(Sphere(center: Point(x: 4, y: 1, z: 0), radius: 1.0, material: Metal(albedo: Color(r: 0.7, g: 0.6, b: 0.5), fuzz: 0)))
    
    return world
}

//
// Get the color for a given ray
//

func rayColor(ray: Ray, world: Hittable, depth: Int) -> Color {
    
    // No  light is gathered if we hit the bounce limit
    if depth <= 0 {
        return Color(r: 0, g: 0, b: 0)
    }

    // Use tmin=0.001 to solve "Acne" problem
    if let hit = world.hit(ray: ray, tmin: 0.001, tmax: .infinity) {
        
        if let (attenuation, scattered) = hit.material.scatter(ray: ray, hit: hit) {
            return attenuation * rayColor(ray: scattered, world: world, depth: depth - 1)
        } else {
            return Color(r: 0, g: 0, b: 0)
        }
    }
    
    let unitDirection = ray.direction.getUnit()
    let t = 0.5 * (unitDirection.y + 1)
    return (1 - t) * Color(r: 1, g: 1, b: 1) + t * Color(r: 0.5, g: 0.7, b: 1)
}

//
// Program Arguments
//

let samplesPerPixelCL = CommandLine.argc > 1 ? Int(CommandLine.arguments[1]) : nil
let maxBounceDepthCL = CommandLine.argc > 2 ? Int(CommandLine.arguments[2]) : nil

//
// Image Settings
//

let ASPECT_RATIO = 16.0 / 9.0
let IMAGE_WIDTH = 400//800
let IMAGE_HEIGHT = Int(Scalar(IMAGE_WIDTH) / ASPECT_RATIO)

let SAMPLES_PER_PIXEL = samplesPerPixelCL ?? 500
let MAX_BOUNCE_DEPTH = maxBounceDepthCL ?? 50


//
// Camera Settings
//

let lookfrom = Vec(x: 13, y: 2, z: 3)
let lookat = Vec(x: 0, y: 0, z: 0)
let vup = Vec(i: 0, j: 1, k: 0)
let vfov = 20.0
let distToFocus = 10.0
let aperture = 0.1

let camera = Camera(lookfrom: lookfrom, lookat: lookat, vup: vup, vfov: vfov, aspectRatio: ASPECT_RATIO, aperture: aperture, focusDist: distToFocus)

//
// World Settings
//

var world = generateRandomScene()

//
// Render Image
//

print("P3\n\(IMAGE_WIDTH) \(IMAGE_HEIGHT)\n255")

for j in stride(from: IMAGE_HEIGHT-1, through: 0, by: -1) {

    print("\rScanlines remaining: \(j)   ", terminator: "", to: &stdErr)

    for i in 0 ..< IMAGE_WIDTH {

        var pixelColor = Color(r: 0, g: 0, b: 0)

        for _ in 0 ..< SAMPLES_PER_PIXEL {
            let r1 = Scalar.random(in: 0 ..< 1)
            let r2 = Scalar.random(in: 0 ..< 1)
            let u = (Scalar(i) + r1) / Scalar(IMAGE_WIDTH - 1)
            let v = (Scalar(j) + r2) / Scalar(IMAGE_HEIGHT - 1)
            let ray = camera.getRay(u, v)
            pixelColor += rayColor(ray: ray, world: world, depth: MAX_BOUNCE_DEPTH)
        }

        // Average colors over samples and then gammar-correct wih gamma=2
        let correctedColor = Color(
            r: sqrt(pixelColor.r / Scalar(SAMPLES_PER_PIXEL)),
            g: sqrt(pixelColor.g / Scalar(SAMPLES_PER_PIXEL)),
            b: sqrt(pixelColor.b / Scalar(SAMPLES_PER_PIXEL))
        )
        print(correctedColor.toString255())
//        exit(0)
    }
}

print("\nDone.", to: &stdErr)
