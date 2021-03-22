//
//  Material.swift
//  raytracer1
//
//  Created by Anthony Clark on 3/19/21.
//

import Foundation

protocol Material {
    func scatter(ray: Ray, hit: HitRecord) -> (Color, Ray)?
}

struct Lambertian: Material {
    let albedo: Color
    
    func scatter(ray: Ray, hit: HitRecord) -> (Color, Ray)? {
        let scatterDirection = hit.normal + Vec.getRandomUnitVector()
        let scattered = scatterDirection.nearZero()
            ? Ray(origin: hit.point, direction: hit.normal)
            : Ray(origin: hit.point, direction: scatterDirection)
        
        return (albedo, scattered)
    }
    
    
}

struct Metal: Material {
    let albedo: Color
    let fuzz: Scalar // Should be less than 1

    func scatter(ray: Ray, hit: HitRecord) -> (Color, Ray)? {
        let reflected = reflect(v: ray.direction.getUnit(), n: hit.normal)
        let scattered = Ray(origin: hit.point, direction: reflected + fuzz * Vec.getRandomInUnitSphere())
        
        return dot(scattered.direction, hit.normal) > 0
            ? (albedo, scattered)
            : nil
    }
}

struct Dielectric: Material {
    let indexOfRefraction: Scalar

    func scatter(ray: Ray, hit: HitRecord) -> (Color, Ray)? {

        let attenuation = Color(r: 1, g: 1, b: 1)
        let refractionRatio = hit.frontFace ? (1.0 / indexOfRefraction) : indexOfRefraction
        
        let unitDirection = ray.direction.getUnit()
        let cosTheta = min(dot(-unitDirection, hit.normal), 1)
        let sinTheta = sqrt(1 - cosTheta * cosTheta)
  
        let cannotRefract = refractionRatio * sinTheta > 1
        let schlickNumber = Dielectric.reflectance(cosine: cosTheta, refIndex: refractionRatio)
        let direction = cannotRefract || (schlickNumber > Scalar.random(in: 0 ... 1))
            ? reflect(v: unitDirection, n: hit.normal)
            : refract(uv: unitDirection, n: hit.normal, etaiOverEtat: refractionRatio)
        
        let scattered = Ray(origin: hit.point, direction: direction)
        
        return (attenuation, scattered)
    }
    
    static func reflectance(cosine: Scalar, refIndex: Scalar) -> Scalar {
        var r0 = (1 - refIndex) / (1 + refIndex)
        r0 = r0 * r0
        return r0 + (1 - r0) * pow(1 - cosine, 5)
    }
}
