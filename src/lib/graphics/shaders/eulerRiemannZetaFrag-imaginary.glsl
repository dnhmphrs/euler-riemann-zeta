precision highp float;
varying vec2 vUv;
uniform vec3 color1;
uniform vec3 color2;
uniform vec3 color3;
uniform vec2 mouse;

float zeta(float sigma, float t) {
    float sum = 0.0;
    const int N = 25; // Number of terms in the series for approximation
    for (int n = 1; n <= N; ++n) {
        float term = pow(float(n), -sigma);
        float angle = -t * log(float(n));
        sum += term * sin(angle); // Tangent part
    }

    return sum;
}

void main() {
    float scale = 100.0;
    float half_scale = scale * 0.5;

    // Map mouse position to coefficients
    float a = 1.0 + mouse.x * 0.5;  // Controls scaling
    float b = mouse.y * 2.0;        // Controls translation
    float c = mouse.x * 2.0;        // Controls skewing
    float d = 1.0 - mouse.y * 0.5;  // Controls scaling and rotation

    // Map the fragment coordinates to the complex plane
    float sigma = vUv.y * scale - half_scale; // Real part of s (horizontal axis)
    float t = vUv.x * scale - half_scale;     // Imaginary part of s (vertical axis)

    // Apply Möbius transformation
    float denominator = (c * sigma + d) * (c * sigma + d) + (c * t) * (c * t);
    float transformedSigma = (a * sigma + b) / denominator;
    float transformedT = (a * t + b) / denominator;

    // Compute the zeta function value
    float zetaValue = zeta(transformedSigma, transformedT);

    // Normalize zetaValue to map to color range
    float normalizedZeta = zetaValue; // Adjust scaling factor for better contrast

    // Create gradients for visualization
    vec3 gradient1 = mix(color1, color2, normalizedZeta);
    vec3 gradient2 = mix(color3, gradient1, 0.5 + 0.5 * sin(normalizedZeta * 3.14159));

    gl_FragColor = vec4(gradient2, 1.0);
}