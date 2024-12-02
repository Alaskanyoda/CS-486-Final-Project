shader_type spatial;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float sub = dot(TANGENT, vec3(1.0, 1.0, 0.0)) / length(TANGENT);
	float reduce = 3.0;
	ALBEDO = vec3(reduce*sub - 1.0, reduce*sub - 1.0, 1);
	//ALPHA = 0.5;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
