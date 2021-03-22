//
//  Hittable.swift
//  raytracer1
//
//  Created by Anthony Clark on 3/6/21.
//

import Foundation

struct HitRecord {
    let point: Point
    let normal: Vec
    let frontFace: Bool
    let tval: Scalar
    let material: Material
}

protocol Hittable {
    func hit(ray: Ray, tmin: Scalar, tmax: Scalar) -> HitRecord?
}
