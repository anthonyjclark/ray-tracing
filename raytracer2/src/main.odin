package main


main :: proc() {

	// World

	material_ground := Lambertian{Material{lambertian_scatter}, Color{0.8, 0.8, 0.0}}
	materail_center := Lambertian{Material{lambertian_scatter}, Color{0.7, 0.3, 0.3}}
	material_left := Metal{Material{metal_scatter}, Color{0.8, 0.8, 0.8}}
	material_right := Metal{Material{metal_scatter}, Color{0.8, 0.6, 0.2}}

	all_objects := Hittables{}

	append(&all_objects.spheres, Sphere{Point{0.0, -100.5, -1.0}, 100.0, material_ground})
	append(&all_objects.spheres, Sphere{Point{0.0, 0.0, -1.0}, 0.5, materail_center})
	append(&all_objects.spheres, Sphere{Point{-1.0, 0.0, -1.0}, 0.5, material_left})
	append(&all_objects.spheres, Sphere{Point{1.0, 0.0, -1.0}, 0.5, material_right})

	// Camera

	camera := create_default_camera()

	render(camera, all_objects)

}
