package main


main :: proc() {

	// World

	all_objects := Hittables{}

	append(&all_objects.spheres, Sphere{Point{0.0, 0.0, -1.0}, 0.5})
	append(&all_objects.spheres, Sphere{Point{0.0, -100.5, -1.0}, 100.0})

	// Camera

	camera := create_default_camera()

	render(camera, all_objects)

}
