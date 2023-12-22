package main

import "core:math"

HitRecord :: struct {
	point:      Point,
	normal:     Vector,
	t:          Scalar,
	front_face: bool,
}

create_hit_record :: proc(p: Point, n: Vector, t: Scalar, front_face: bool) -> HitRecord {

	return HitRecord{p, front_face ? n : -n, t, front_face}

}

Sphere :: struct {
	center: Point,
	radius: Scalar,
}

hit :: proc(s: Sphere, r: Ray, t_min, t_max: Scalar) -> Maybe(HitRecord) {

	oc := Vector(r.origin - s.center)

	a := length_squared(r.direction)
	half_b := dot(oc, r.direction)
	c := length_squared(oc) - s.radius * s.radius

	discriminant := half_b * half_b - a * c

	if discriminant < 0 do return nil

	sqrtd := math.sqrt(discriminant)

	root := (-half_b - sqrtd) / a

	if root <= t_min || t_max <= root {

		root := (-half_b + sqrtd) / a

		if root <= t_min || t_max <= root do return nil

	}

	hit_loc := at(r, root)
	outward_normal := Vector((hit_loc - s.center) / s.radius)
	front_face := dot(r.direction, outward_normal) < 0

	return create_hit_record(hit_loc, outward_normal, root, front_face)

}
