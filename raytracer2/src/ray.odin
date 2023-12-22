package main

Ray :: struct {
	origin:    Point,
	direction: Vector,
}

at :: proc(r: Ray, t: Scalar) -> Point {

	return r.origin + Point(r.direction * t)

}
