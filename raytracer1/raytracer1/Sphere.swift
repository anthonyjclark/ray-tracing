//
//  Sphere.swift
//  raytracer1
//
//  Created by Anthony Clark on 3/6/21.
//

import Foundation

struct Sphere: Hittable {
    let center: Point
    let radius: Scalar
    let material: Material
    
    func hit(ray: Ray, tmin: Scalar, tmax: Scalar) -> HitRecord? {
                
        let centerToOrigin = ray.origin - center
        let a = ray.direction.lengthSquared()
        let halfb = dot(centerToOrigin, ray.direction)
        let c = centerToOrigin.lengthSquared() - radius * radius
        
        let discriminant = halfb * halfb - a * c
        if discriminant < 0 {
            return nil
        }
        
        let sqrtd = sqrt(discriminant)
                
        // Find the nearest root that lies in the acceptable range
        var root = (-halfb - sqrtd) / a
        if root < tmin || tmax < root {
            root = (-halfb + sqrtd) / a
            if root < tmin || tmax < root {
                return nil
            }
        }
        
        let point = ray.at(root)
        let outwardNormal = (point - center) / radius
        let frontFace = dot(ray.direction, outwardNormal) < 0
        
        return HitRecord(
            point: point,
            normal: frontFace ? outwardNormal : -outwardNormal,
            frontFace: frontFace,
            tval: root,
            material: material
        )
    }
}
