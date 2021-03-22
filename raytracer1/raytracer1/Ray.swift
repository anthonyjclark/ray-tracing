//
//  Ray.swift
//  raytracer1
//
//  Created by Anthony Clark on 12/25/20.
//

struct Ray {
    let origin: Point
    let direction: Vec
}

extension Ray {
    func at(_ t: Scalar) -> Point {
        return origin + t * direction
    }
}
