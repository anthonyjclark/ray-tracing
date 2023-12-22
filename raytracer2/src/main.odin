package main

import "core:fmt"
import "core:math"


ray_color :: proc(r: Ray, all_objects: Hittables) -> Color {

	// TODO: would be better to use Scalar.INF
	rec, ok := hit(all_objects, r, 0.0, math.INF_F64).?

	if ok {

		return 0.5 * (Color(rec.normal) + Color{1.0, 1.0, 1.0})

	}

	unit_direction := unit(r.direction)
	a := 0.5 * (unit_direction.y + 1.0)

	return (1.0 - a) * Color{1.0, 1.0, 1.0} + a * Color{0.5, 0.7, 1.0}

}

main :: proc() {

	// Image

	aspect_ration :: 16.0 / 9.0

	image_width :: 400
	image_height :: int(image_width / aspect_ration)

	// World

	all_objects := Hittables{}
	append(&all_objects.spheres, Sphere{Point{0.0, 0.0, -1.0}, 0.5})
	append(&all_objects.spheres, Sphere{Point{0.0, -100.5, -1.0}, 100.0})

	// Camera

	focal_length :: 1.0

	viewpoint_height :: 2.0
	viewpoint_width :: viewpoint_height * Scalar(image_width) / Scalar(image_height)

	camera_center :: Point{0.0, 0.0, 0.0}

	viewport_u :: Vector{viewpoint_width, 0.0, 0.0}
	viewport_v :: Vector{0.0, -viewpoint_height, 0.0}

	pixel_delta_u := viewport_u / Scalar(image_width)
	pixel_delta_v := viewport_v / Scalar(image_height)

	focal_length_vector := Vector{0.0, 0.0, focal_length}
	mean_viewpoint_vector := 0.5 * (viewport_u + viewport_v)

	viewport_upper_left := camera_center - Point(focal_length_vector + mean_viewpoint_vector)

	pixel00_loc := viewport_upper_left + Point(0.5 * (pixel_delta_u + pixel_delta_v))

	// fmt.eprintf("Image size: {0}x{1}\n", image_width, image_height)
	// fmt.eprintln("Focal length: ", focal_length)
	// fmt.eprintf("Viewport: {0}x{1}\n", viewpoint_width, viewpoint_height)
	// fmt.eprintln("Camera center: ", camera_center)
	// fmt.eprintln("Viewport u: ", viewport_u)
	// fmt.eprintln("Viewport v: ", viewport_v)
	// fmt.eprintln("Pixel delta u: ", pixel_delta_u)
	// fmt.eprintln("Pixel delta v: ", pixel_delta_v)
	// fmt.eprintln("Viewport upper left: ", viewport_upper_left)
	// fmt.eprintln("Pixel 00 location: ", pixel00_loc)

	fmt.printf("P3\n{} {}\n255\n", image_width, image_height)

	for j := 0; j < image_height; j += 1 {

		fmt.eprintf("\rScanlines remaining: {0: 3d}", image_height - j)

		sj := Scalar(j)

		for i := 0; i < image_width; i += 1 {

			si := Scalar(i)

			pixel_center := pixel00_loc + Point(si * pixel_delta_u + sj * pixel_delta_v)

			ray_direction := Vector(pixel_center - camera_center)

			r := Ray{camera_center, ray_direction}

			pixel_color := ray_color(r, all_objects)

			writeColor(pixel_color)

		}
	}

	fmt.eprintln("\rDone.                       ")

}
