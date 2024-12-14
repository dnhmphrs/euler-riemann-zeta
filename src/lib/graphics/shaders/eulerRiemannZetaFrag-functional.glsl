precision highp float;
varying vec2 vUv;
uniform vec3 color1;
uniform vec3 color2;
uniform vec3 color3;
uniform vec2 mouse;

const float CRITICAL_LINE = 0.5; // The real part of s on the critical line
const float ZERO_LINE = 0.0; // The real part of s at 0
const float ONE_LINE = 1.0; // The real part of s at 1

// zeta zeros 
const float ZETA_ZERO_1 = 14.1347;
const float ZETA_ZERO_2 = 21.0220;
const float ZETA_ZERO_3 = 25.0109;
const float ZETA_ZERO_4 = 30.4249;
const float ZETA_ZERO_5 = 32.9351;
const float ZETA_ZERO_6 = 37.5862;
const float ZETA_ZERO_7 = 40.9187;
const float ZETA_ZERO_8 = 43.3271;
const float ZETA_ZERO_9 = 48.0052;
const float ZETA_ZERO_10 = 49.7738;


// Approximate Gamma function using Stirling's approximation
float gamma(float s) {
    return sqrt(2.0 * 3.141592653589793 / s) * pow(s / 2.718281828459045, s);
}

// Struct to handle complex numbers
struct Complex {
    float re; // Real part
    float im; // Imaginary part
};

// Complex multiplication: (a + bi) * (c + di)
Complex multiply(Complex a, Complex b) {
    return Complex(
        a.re * b.re - a.im * b.im, // Real part
        a.re * b.im + a.im * b.re  // Imaginary part
    );
}

// Complex addition: (a + bi) + (c + di)
Complex add(Complex a, Complex b) {
    return Complex(a.re + b.re, a.im + b.im);
}

// Scale a complex number by a scalar
Complex scale(Complex a, float scalar) {
    return Complex(a.re * scalar, a.im * scalar);
}

// Complex exponentiation: n^(-sigma) * e^(-it log(n))
// Equivalent to: exp(-sigma * log(n)) * exp(-it log(n))
Complex zetaTerm(float n, float sigma, float t) {
    float log_n = log(n);
    float magnitude = pow(n, -sigma); // exp(-sigma * log(n))
    float angle = -t * log_n;        // -t * log(n)
    return Complex(magnitude * tan(angle), magnitude * tan(angle));
}

// Approximate the Riemann zeta function for Re(s) > 1
Complex zeta(float sigma, float t) {
    Complex sum = Complex(0.0, 0.0);
    const int N = 2; // Increase for better accuracy
    for (int n = 1; n <= N; ++n) {
        sum = add(sum, zetaTerm(float(n), sigma, t));
    }
    return sum;
}

// Functional equation for the Riemann zeta function
float functionalZeta(float sigma, float t) {
    // Avoid the pole at s = 1
    if (abs(sigma - 1.0) < 0.01) {
        return 100.0; // Arbitrary large value to represent the pole
    }

    // Compute zeta(sigma, t) for Re(s) > 1
    Complex zeta_s = zeta(sigma, t);

    // Compute zeta(1 - sigma, -t) for Re(s) < 0
    Complex zeta_1_minus_s = zeta(1.0 - sigma, -t);

    // Compute Gamma(1 - sigma) using Stirling's approximation
    float gamma_value = gamma(1.0 - sigma);

    // Compute the sine factor sin(pi * sigma / 2)
    float sine_factor = sin(3.141592653589793 * sigma / 2.0);

    // Compute the multiplier
    float multiplier = pow(2.0, sigma) * pow(3.141592653589793, sigma - 1.0) * sine_factor * gamma_value;

    // Apply the functional equation by scaling zeta_1_minus_s
    zeta_1_minus_s = scale(zeta_1_minus_s, multiplier);

    // Combine zeta(s) and scaled zeta(1 - sigma, -t)
    Complex result = add(zeta_s, zeta_1_minus_s);

    // Return the magnitude of the result (|zeta(s)|)
    return sqrt(result.re * result.re + result.im * result.im);
}

// Functional equation for symmetric calculation
float symmetricZeta(float sigma, float t) {
    // Compute zeta(sigma, t) for Re(s) > 1
    Complex zeta_s = zeta(sigma, t);

    // Compute zeta(1 - sigma, -t) using the functional equation
    Complex zeta_1_minus_s = zeta(1.0 - sigma, -t);

    // Compute Gamma(1 - sigma) using Stirling's approximation
    float gamma_value = gamma(1.0 - sigma);

    // Compute the sine factor sin(pi * sigma / 2)
    float sine_factor = sin(3.141592653589793 * sigma / 2.0);

    // Compute the multiplier
    float multiplier = pow(2.0, sigma) * pow(3.141592653589793, sigma - 1.0) * sine_factor * gamma_value;

    // Apply the functional equation by scaling zeta_1_minus_s
    zeta_1_minus_s = scale(zeta_1_minus_s, multiplier);

    // Combine zeta(s) and zeta(1 - s) symmetrically
    Complex result = add(zeta_s, zeta_1_minus_s);

    // Return the magnitude of the result (|zeta(s)|)
    return sqrt(result.re * result.re + result.im * result.im);
}




void main() {
    float scale = 50.0;
    float half_scale = scale * 0.5;

    // Map mouse position to coefficients
    float a = 1.0 + mouse.y * 0.5;  // Controls scaling
    float b = mouse.x * 2.0;        // Controls translation
    float c = mouse.y * 2.0;        // Controls skewing
    float d = 1.0 - mouse.x * 0.5;  // Controls scaling and rotation

    // Map the fragment coordinates to the complex plane
    float sigma = vUv.y * scale - half_scale; // Real part of s (horizontal axis)
    float t = vUv.x * scale - half_scale;     // Imaginary part of s (vertical axis)

    // // Combine sigma and t into a complex number and apply the Möbius transformation
    // float denom = c * c * (sigma * sigma + t * t) + 2.0 * c * d * sigma + d * d;
    // float transformedSigma = (a * c * (sigma * sigma + t * t) + a * d * sigma + b * c * sigma + b * d) / denom;
    // float transformedT = (a * c * 2.0 * sigma * t + a * d * t + b * c * t) / denom;

    // // Compute the zeta function value using the functional equation
    // float zetaValue = functionalZeta(transformedSigma, transformedT);

    // Compute zeta values for both sides of the critical line
    float zetaValueNorth = functionalZeta(sigma, t);       // For Re(s) > 0.5
    float zetaValueSouth = symmetricZeta(1.0 - sigma, t);  // For Re(s) < 0.5

    // Blend values in the critical strip (0 < Re(s) < 1)
    float blendFactor = clamp((0.5 - abs(0.5 - sigma)) * 10.0, 0.0, 1.0); // Smoothstep blend in the strip
    float blendedZeta = mix(zetaValueNorth, zetaValueSouth, blendFactor);

    // Determine the final zeta value for rendering
    float zetaValue;
    if (sigma < 0.5) {
        zetaValue = zetaValueNorth; // Render zeta(s) above the critical strip
    } else if (sigma > 0.5) {
        zetaValue = zetaValueSouth; // Render zeta(1-s) below the critical strip
    } else {
        zetaValue = blendedZeta; // Blend in the critical strip
    }
    
    // Normalize zetaValue to map to color range, clamping to avoid extreme values
    // float normalizedZeta = log(1.0 + abs(zetaValue)); // Use logarithmic scaling

    // Normalize zetaValue to map to color range, clamping to avoid extreme values
    // float normalizedZeta = clamp(zetaValue, -100.0, 100.0);

    // Create gradients for visualization
    vec3 gradient1 = mix(color1, color2, zetaValue);
    vec3 gradient2 = mix(color3, gradient1, 0.5 + 0.5 * sin(zetaValue));

    // Draw the critical strip
    float lineThickness = 0.0002; // Thickness of the line
    float criticalLinePosition = (CRITICAL_LINE + half_scale) / scale; // Normalize the critical line position
    float zeroLinePosition = (ZERO_LINE + half_scale) / scale; // Normalize the zero line position
    float oneLinePosition = (ONE_LINE + half_scale) / scale; // Normalize the one line position

    // Highlight the critical strip
    if (abs(vUv.y - criticalLinePosition) < lineThickness) {
        gradient2 = mix(color3, vec3(1.0, 0.0, 0.0), 0.7); // Red line for the critical strip
    }

    // Highlight the zero line
    if (abs(vUv.y - zeroLinePosition) < lineThickness) {
        gradient2 = mix(color3, vec3(0.0, 0.0, 0.0), 0.7); // Black line for zero
    }

    // Highlight the one line
    if (abs(vUv.y - oneLinePosition) < lineThickness) {
        gradient2 = mix(color3, vec3(0.0, 0.0, 0.0), 0.7); // Black line for one
    }


    // zetazeros
    float zetaZero1Pos = (ZETA_ZERO_1 + half_scale) / scale;
    float zetaZero2Pos = (ZETA_ZERO_2 + half_scale) / scale;
    float zetaZero3Pos = (ZETA_ZERO_3 + half_scale) / scale;
    float zetaZero4Pos = (ZETA_ZERO_4 + half_scale) / scale;
    float zetaZero5Pos = (ZETA_ZERO_5 + half_scale) / scale;
    float zetaZero6Pos = (ZETA_ZERO_6 + half_scale) / scale;
    float zetaZero7Pos = (ZETA_ZERO_7 + half_scale) / scale;
    float zetaZero8Pos = (ZETA_ZERO_8 + half_scale) / scale;
    float zetaZero9Pos = (ZETA_ZERO_9 + half_scale) / scale;
    float zetaZero10Pos = (ZETA_ZERO_10 + half_scale) / scale;

    float zetaZero1Neg = (-ZETA_ZERO_1 + half_scale) / scale;
    float zetaZero2Neg = (-ZETA_ZERO_2 + half_scale) / scale;
    float zetaZero3Neg = (-ZETA_ZERO_3 + half_scale) / scale;
    float zetaZero4Neg = (-ZETA_ZERO_4 + half_scale) / scale;
    float zetaZero5Neg = (-ZETA_ZERO_5 + half_scale) / scale;
    float zetaZero6Neg = (-ZETA_ZERO_6 + half_scale) / scale;
    float zetaZero7Neg = (-ZETA_ZERO_7 + half_scale) / scale;
    float zetaZero8Neg = (-ZETA_ZERO_8 + half_scale) / scale;
    float zetaZero9Neg = (-ZETA_ZERO_9 + half_scale) / scale;
    float zetaZero10Neg = (-ZETA_ZERO_10 + half_scale) / scale;

    if (abs(vUv.x - zetaZero1Pos) < lineThickness || abs(vUv.x - zetaZero1Neg) < lineThickness) {
        gradient2 = mix(color3, vec3(1.0, 0.0, 0.0), 0.7); // Red line for zero
    }
    if (abs(vUv.x - zetaZero2Pos) < lineThickness || abs(vUv.x - zetaZero2Neg) < lineThickness) {
        gradient2 = mix(color3, vec3(1.0, 0.0, 0.0), 0.7);
    }
    if (abs(vUv.x - zetaZero3Pos) < lineThickness || abs(vUv.x - zetaZero3Neg) < lineThickness) {
        gradient2 = mix(color3, vec3(1.0, 0.0, 0.0), 0.7);
    }
    if (abs(vUv.x - zetaZero4Pos) < lineThickness || abs(vUv.x - zetaZero4Neg) < lineThickness) {
        gradient2 = mix(color3, vec3(1.0, 0.0, 0.0), 0.7);
    }
    if (abs(vUv.x - zetaZero5Pos) < lineThickness || abs(vUv.x - zetaZero5Neg) < lineThickness) {
        gradient2 = mix(color3, vec3(1.0, 0.0, 0.0), 0.7);
    }
    if (abs(vUv.x - zetaZero6Pos) < lineThickness || abs(vUv.x - zetaZero6Neg) < lineThickness) {
        gradient2 = mix(color3, vec3(1.0, 0.0, 0.0), 0.7);
    }
    if (abs(vUv.x - zetaZero7Pos) < lineThickness || abs(vUv.x - zetaZero7Neg) < lineThickness) {
        gradient2 = mix(color3, vec3(1.0, 0.0, 0.0), 0.7);
    }
    if (abs(vUv.x - zetaZero8Pos) < lineThickness || abs(vUv.x - zetaZero8Neg) < lineThickness) {
        gradient2 = mix(color3, vec3(1.0, 0.0, 0.0), 0.7);
    }
    if (abs(vUv.x - zetaZero9Pos) < lineThickness || abs(vUv.x - zetaZero9Neg) < lineThickness) {
        gradient2 = mix(color3, vec3(1.0, 0.0, 0.0), 0.7);
    }
    if (abs(vUv.x - zetaZero10Pos) < lineThickness || abs(vUv.x - zetaZero10Neg) < lineThickness) {
        gradient2 = mix(color3, vec3(1.0, 0.0, 0.0), 0.7);
    }

    gl_FragColor = vec4(gradient2, 1.0);
}
