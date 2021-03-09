//
//  hittable.swift
//  raytracer1
//
//  Created by Anthony Clark on 3/6/21.
//

import Foundation

struct HitRecord {
    let point: Point
    let normal: Vec3
    let frontFace: Bool
    let tval: Scalar
    
//    init(p: Point, n: Vec3, t: Scalar) {
//        point = p
//        normal = n
//        tval = t
//
//
//    }
}



protocol Hittable {
    func hit(ray: Ray, tmin: Scalar, tmax: Scalar) -> HitRecord?
}
