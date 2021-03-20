//
//  Camera.swift
//  raytracer1
//
//  Created by Anthony Clark on 3/7/21.
//

import Foundation

struct Camera {
    let origin: Point
    let horizontal: Vec
    let vertical: Vec
    let lowerLeftCorner: Point

    init () {
        let ASPECT_RATIO = 16.0 / 9.0
        let VIEWPORT_HEIGHT = 2.0
        let VIEWPORT_WIDTH = ASPECT_RATIO * VIEWPORT_HEIGHT
        let FOCAL_LENGTH = 1.0

        origin = Point(x: 0, y: 0, z: 0)
        horizontal = Point(x: VIEWPORT_WIDTH, y: 0, z: 0)
        vertical = Point(x: 0, y: VIEWPORT_HEIGHT, z: 0)
        lowerLeftCorner = origin - horizontal/2 - vertical/2 - Point(x: 0, y: 0, z: FOCAL_LENGTH)
    }
    
    func getRay(u: Scalar, v: Scalar) -> Ray {
        let dir = lowerLeftCorner + u * horizontal + v * vertical - origin
        return Ray(origin: origin, direction: dir)
    }
}
