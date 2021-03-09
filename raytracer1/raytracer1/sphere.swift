//
//  sphere.swift
//  raytracer1
//
//  Created by Anthony Clark on 3/6/21.
//

import Foundation

struct Sphere: Hittable {
    let center: Point
    let radius: Scalar
    
    func hit(ray: Ray, tmin: Scalar, tmax: Scalar) -> HitRecord? {
        let centerToOrigin = ray.origin - center
        let a = ray.direction.lengthSquared()
        let halfb = dot(a: centerToOrigin, b: ray.direction)
        let c = centerToOrigin.lengthSquared() - radius * radius
        
        let discriminant = halfb * halfb - a * c
        if discriminant < 0 {
            return nil
        }
        
        let sqrtd = discriminant.squareRoot()
        
        // Find the nearest root that lies in the acceptable range
        let root = (-halfb - sqrtd) / a
        if root < tmin || tmax < root {
            let root = (-halfb + sqrtd) / a
            if root < tmin || tmax < root {
                return nil
            }
        }
        
        let point = ray.at(t: root)
        let outwardNormal = (point - center) / radius
        let frontFace = dot(a: ray.direction, b: outwardNormal) < 0
        
        return HitRecord(
            point: point,
            normal: frontFace ? outwardNormal : -outwardNormal,
            frontFace: frontFace,
            tval: root
        )
    }
}
