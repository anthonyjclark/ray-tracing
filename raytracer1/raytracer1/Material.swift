//
//  Material.swift
//  raytracer1
//
//  Created by Anthony Clark on 3/19/21.
//

import Foundation

protocol Material {
    func scatter(rayIn: Ray, rec: HitRecord) -> (Color, Ray)?
}

struct Lambertian: Material {
    let albedo: Color
    
    func scatter(rayIn: Ray, rec: HitRecord) -> (Color, Ray)? {
        let scatterDirection = rec.normal + Vec.getRandomUnitVector()
        let scattered = scatterDirection.nearZero()
            ? Ray(origin: rec.point, direction: rec.normal)
            : Ray(origin: rec.point, direction: scatterDirection)
        
        return (albedo, scattered)
    }
    
    
}

struct Metal: Material {
    let albedo: Color
    let fuzz: Scalar // Should be less than 1

    func scatter(rayIn: Ray, rec: HitRecord) -> (Color, Ray)? {
        let reflected = reflect(v: rayIn.direction.getUnit(), n: rec.normal)
        let scattered = Ray(origin: rec.point, direction: reflected + fuzz * Vec.getRandomInUnitSphere())
        
        return dot(a: scattered.direction, b: rec.normal) > 0
            ? (albedo, scattered)
            : nil
    }
}

struct Dielectric: Material {
    let indexOfRefraction: Scalar

    func scatter(rayIn: Ray, rec: HitRecord) -> (Color, Ray)? {
        let attenuation = Color(r: 1, g: 1, b: 1)
        let refractionRatio = rec.frontFace ? (1.0 / indexOfRefraction) : indexOfRefraction
        
        let unitDirection = rayIn.direction.getUnit()
        let cosTheta = min(dot(a: -unitDirection, b: rec.normal), 1)
        let sinTheta = (1 - cosTheta * cosTheta).squareRoot()
        
        // Commenting out the Schlick approximation until I fix the bug here
        let cannotRefract = refractionRatio * sinTheta > 1
        let direction = cannotRefract //|| Dielectric.reflectance(cosine: cosTheta, refIndex: refractionRatio) > Scalar.random(in: 0 ... 1)
            ? reflect(v: unitDirection, n: rec.normal)
            : refract(uv: unitDirection, n: rec.normal, etaiOverEtat: refractionRatio)
        
        let scattered = Ray(origin: rec.point, direction: direction)

        return (attenuation, scattered)
    }
    
    static func reflectance(cosine: Scalar, refIndex: Scalar) -> Scalar {
        var r0 = (1 - refIndex) / (1 + refIndex)
        r0 = r0 * r0
        return r0 + (1 - r0) * pow(1 - cosine, 5)
    }
}
