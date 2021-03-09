//
//  ray.swift
//  raytracer1
//
//  Created by Anthony Clark on 12/25/20.
//

struct Ray {
    let origin: Point
    let direction: Vec3
}

extension Ray {
    func at(t: Scalar) -> Point {
        return origin + t * direction
    }
}
