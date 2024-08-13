precision highp float;
varying vec2 vUv;
uniform vec3 color1;
uniform vec3 color2;
uniform vec3 color3;
uniform vec2 mouse;

// Approximate Gamma function using Stirling's approximation
float gamma(float s) {
    return sqrt(2.0 * 3.141592653589793 / s) * pow(s / 2.718281828459045, s);
}

// Compute the zeta function using a simple series expansion
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

// Compute the zeta function using the functional equation
float functionalZeta(float sigma, float t) {
    // Compute zeta(sigma, t)
    float zeta_s = zeta(sigma, t);
    
    // Compute zeta(1 - sigma, -t)
    float zeta_1_minus_s = zeta(1.0 - sigma, -t);
    
    // Compute the Gamma(1 - sigma)
    float gamma_value = gamma(1.0 - sigma);
    
    // Compute the sine factor sin(pi * sigma / 2)
    float sine_factor = sin(3.141592653589793 * sigma / 2.0);
    
    // Compute the functional equation
    return 2.0 * pow(3.141592653589793, sigma - 1.0) * sine_factor * gamma_value * zeta_1_minus_s + zeta_s;
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

    // Combine sigma and t into a complex number and apply the Möbius transformation
    float denom = c * c * (sigma * sigma + t * t) + 2.0 * c * d * sigma + d * d;
    float transformedSigma = (a * c * (sigma * sigma + t * t) + a * d * sigma + b * c * sigma + b * d) / denom;
    float transformedT = (a * c * 2.0 * sigma * t + a * d * t + b * c * t) / denom;

    // Compute the zeta function value using the functional equation
    float zetaValue = functionalZeta(transformedSigma, transformedT);

    // Normalize zetaValue to map to color range
    vec3 gradient1 = mix(color1, color2, zetaValue);
    vec3 gradient2 = mix(color3, gradient1, zetaValue);

    gl_FragColor = vec4(gradient2, 1.0);
}
