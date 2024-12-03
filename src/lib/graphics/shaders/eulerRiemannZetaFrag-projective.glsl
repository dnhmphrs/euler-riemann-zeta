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
        sum += term * tan(angle); // Tangent part
    }

    return sum;
}

void main() {
    float scale = 100.0;
    float half_scale = scale * 0.5;

    // Map mouse position to coefficients
    float a = 1.0 + mouse.y * 0.5;  // Controls scaling
    float b = mouse.x * 2.0;        // Controls translation
    float c = mouse.y * 2.0;        // Controls skewing
    float d = 1.0 - mouse.x * 0.5;  // Controls scaling and rotation

    // Map the fragment coordinates to the complex plane
    float sigma = vUv.y * scale - half_scale; // Real part of s (horizontal axis)
    float t = vUv.x * scale - half_scale;     // Imaginary part of s (vertical axis)

    // // Apply Möbius transformation
    // float denom = c * c * (sigma * sigma + t * t) + 2.0 * c * d * sigma + d * d;
    // float transformedSigma = (a * c * (sigma * sigma + t * t) + a * d * sigma + b * c * sigma + b * d) / denom;
    // float transformedT = (a * c * 2.0 * sigma * t + a * d * t + b * c * t) / denom;

    // // Compute the zeta function value
    // float zetaValue = zeta(transformedSigma, transformedT);

    float zetaValue = zeta(sigma, t);

    // Normalize zetaValue to map to color range
    float normalizedZeta = zetaValue; // Adjust scaling factor for better contrast

    // Create gradients for visualization
    vec3 gradient1 = mix(color1, color2, normalizedZeta);
    vec3 gradient2 = mix(color3, gradient1, 0.5 + 0.5 * sin(normalizedZeta));

    gl_FragColor = vec4(gradient2, 1.0);
}
