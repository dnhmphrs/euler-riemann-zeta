precision highp float;
varying vec2 vUv;
uniform vec3 color1;
uniform vec3 color2;
uniform vec3 color3;
uniform vec2 mouse;

// Function to compute the Euler–Riemann zeta function
float zeta(float sigma, float t) {
    float sum = 0.0;
    const int N = 1000; // Number of terms in the series for approximation

    for (int n = 1; n <= N; ++n) {
        float term = pow(float(n), -sigma);
        float angle = -t * log(float(n));
        sum += term * tan(angle); // Tangent part
    }

    return sum;
}

void main() {
    // Map the fragment coordinates to the complex plane
    float sigma = vUv.x * 20.0 - 10.0; // Real part of s
    float t = vUv.y * 20.0 - 10.0;     // Imaginary part of s

    // Compute the zeta function value
    float zetaValue = zeta(sigma, t);

    // Normalize zetaValue to map to color range
    float normalizedZeta = 0.5 + 0.5 * zetaValue;

    // Create gradients for visualization
    vec3 gradient1 = mix(color1, color2, normalizedZeta);
    vec3 gradient2 = mix(color3, gradient1, 0.25 + 0.25 * sin(normalizedZeta));

    gl_FragColor = vec4(gradient2, 1.0);
}
