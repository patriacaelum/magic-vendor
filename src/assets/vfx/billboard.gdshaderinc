mat4 apply_billboarding(mat4 inv_view_matrix, mat4 model_view_matrix, mat4 view_matrix, mat4 model_matrix, vec4 instance_custom) {
// Create matrix to billboard particles
    mat4 mat_world = mat4(normalize(inv_view_matrix[0]), normalize(inv_view_matrix[1]), normalize(inv_view_matrix[2]), model_matrix[3]);
// Adjust matrix for rotating billboards along x-axis
    mat_world = mat_world * mat4(vec4(cos(instance_custom.x), -sin(instance_custom.x), 0.0, 0.0), vec4(sin(instance_custom.x), cos(instance_custom.x), 0.0, 0.0), vec4(0.0, 0.0, 1.0, 0.0), vec4(0.0, 0.0, 0.0, 1.0));
    model_view_matrix = view_matrix * mat_world;
// Preserve scaling
    model_view_matrix = model_view_matrix * mat4(vec4(length(model_matrix[0].xyz), 0.0, 0.0, 0.0), vec4(0.0, length(model_matrix[1].xyz), 0.0, 0.0), vec4(0.0, 0.0, length(model_matrix[2].xyz), 0.0), vec4(0.0, 0.0, 0.0, 1.0));
    
    return model_view_matrix;
}
