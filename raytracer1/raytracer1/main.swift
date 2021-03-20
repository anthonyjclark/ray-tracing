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
// Get the color for a given ray
//

func rayColor(ray: Ray, world: Hittable, depth: Int) -> Color {
    
    // No  light is gathered if we hit the bounce limit
    if depth <= 0 {
        return Color(r: 0, g: 0, b: 0)
    }
    
    // Use tmin=0.001 to solve "Acne" problem
    if let hitRecord = world.hit(ray: ray, tmin: 0.001, tmax: .infinity) {
        
        if let (attenuation, scattered) = hitRecord.material.scatter(rayIn: ray, rec: hitRecord) {
            return attenuation * rayColor(ray: scattered, world: world, depth: depth - 1)
        } else {
            return Color(r: 0, g: 0, b: 0)
        }
        
//        //
//        // Three different methods for computing the target
//        //
//        //let target = hitRecord.point + hitRecord.normal + Vec.getRandomInUnitSphere()
//        let target = hitRecord.point + hitRecord.normal + Vec.getRandomUnitVector()
//        //let target = hitRecord.point + Vec.getRandomInHemisphere(normal: hitRecord.normal)
//
//        let newRay = Ray(origin: hitRecord.point, direction: target - hitRecord.point)
//        return 0.5 * rayColor(ray: newRay, world: world, depth: depth - 1)
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
let IMAGE_WIDTH = 400
let IMAGE_HEIGHT = Int(Scalar(IMAGE_WIDTH) / ASPECT_RATIO)

let SAMPLES_PER_PIXEL = samplesPerPixelCL ?? 100
let MAX_BOUNCE_DEPTH = maxBounceDepthCL ?? 50


//
// Camera Settings
//

let camera = Camera()

//
// World Settings
//

let materialGround = Lambertian(albedo: Color(r: 0.8, g: 0.8, b: 0.0))
let materialCenter = Lambertian(albedo: Color(r: 0.1, g: 0.2, b: 0.5))
let materialLeft = Dielectric(indexOfRefraction: 1.1)
let materialRight = Metal(albedo: Color(r: 0.8, g: 0.6, b: 0.2), fuzz: 0.0)

var world = HittableList()
world.add(hittableItem: Sphere(center: Point(x: 0, y: -100.5, z: -1), radius: 100, material: materialGround))
world.add(hittableItem: Sphere(center: Point(x: 0, y: 0, z: -1), radius: 0.5, material: materialCenter))
world.add(hittableItem: Sphere(center: Point(x: -1, y: 0, z: -1), radius: 0.5, material: materialLeft))
//world.add(hittableItem: Sphere(center: Point(x: -1, y: 0, z: -1), radius: -0.4, material: materialLeft))
world.add(hittableItem: Sphere(center: Point(x: 1, y: 0, z: -1), radius: 0.5, material: materialRight))

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
            let ray = camera.getRay(u: u, v: v)
            pixelColor += rayColor(ray: ray, world: world, depth: MAX_BOUNCE_DEPTH)
        }

        // Average colors over samples and then gammar-correct wih gamma=2
        let correctedColor = Color(
            r: (pixelColor.r / Scalar(SAMPLES_PER_PIXEL)).squareRoot(),
            g: (pixelColor.g / Scalar(SAMPLES_PER_PIXEL)).squareRoot(),
            b: (pixelColor.b / Scalar(SAMPLES_PER_PIXEL)).squareRoot()
        )
        print(correctedColor.toString255())
    }
}

print("\nDone.", to: &stdErr)
