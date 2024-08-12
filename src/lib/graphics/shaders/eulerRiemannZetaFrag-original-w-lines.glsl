precision highp float;
varying vec2 vUv;
uniform vec3 color1;
uniform vec3 color2;
uniform vec3 color3;
uniform vec2 mouse;

const float CRITICAL_LINE = 0.5; // The real part of s on the critical line
const float ZERO_LINE = 0.0; // The real part of s at 0
const float ONE_LINE = 1.0; // The real part of s at 1

const float initial1 = 2.26658;
const float gap1 = 4.53316;

const float LINE_A = initial1; // The real part of s at 0
const float LINE_NEG_A = -initial1; // The real part of s at 0
const float LINE_B = initial1 + gap1; // The real part of s at 0
const float LINE_NEG_B = -initial1 - gap1; // The real part of s at 0
const float LINE_C = initial1 + 2.0 * gap1; // The real part of s at 0
const float LINE_NEG_C = -initial1 - 2.0 * gap1; // The real part of s at 0
const float LINE_D = initial1 + 3.0 * gap1; // The real part of s at 0
const float LINE_NEG_D = -initial1 - 3.0 * gap1; // The real part of s at 0
const float LINE_E = initial1 + 4.0 * gap1; // The real part of s at 0
const float LINE_NEG_E = -initial1 - 4.0 * gap1; // The real part of s at 0
const float LINE_F = initial1 + 5.0 * gap1; // The real part of s at 0
const float LINE_NEG_F = -initial1 - 5.0 * gap1; // The real part of s at 0

// const float initial2 = 1.468553;
// const float gap2 = 2.937106;

// const float LINE_A1 = initial2; // The real part of s at 0
// const float LINE_NEG_A1 = -initial2; // The real part of s at 0
// const float LINE_B1 = initial2 + gap2; // The real part of s at 0
// const float LINE_NEG_B1 = -initial2 - gap2; // The real part of s at 0


// Function to compute the Euler–Riemann zeta function
float zeta(float sigma, float t) {
    float sum = 0.0;
    const int N = 100; // Number of terms in the series for approximation

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
    // Map the fragment coordinates to the complex plane
    float sigma = vUv.y * scale - half_scale; // Real part of s (horizontal axis)
    float t = vUv.x * scale - half_scale;    // Imaginary part of s (vertical axis)

    // Compute the zeta function value
    float zetaValue = zeta(sigma, t);

    // Normalize zetaValue to map to color range
    float normalizedZeta = 0.5 + 0.1 * zetaValue; // Adjust scaling factor for better contrast

    // Create gradients for visualization
    vec3 gradient1 = mix(color1, color2, normalizedZeta);
    vec3 gradient2 = mix(color3, gradient1, 0.5 + 0.5 * sin(normalizedZeta * 3.14159));

    // Draw the critical strip
    float lineThickness = 0.0002; // Thickness of the line
    float criticalLinePosition = (CRITICAL_LINE + half_scale) / scale; // Normalize the critical line position
    float zeroLinePosition = (ZERO_LINE + half_scale) / scale; // Normalize the zero line position
    float oneLinePosition = (ONE_LINE + half_scale) / scale; // Normalize the one line position

    // Vertical lines positions
    float lineAPosition = (LINE_A + half_scale) / scale;
    float lineNegAPosition = (LINE_NEG_A + half_scale) / scale;
    float lineBPosition = (LINE_B + half_scale) / scale;
    float lineNegBPosition = (LINE_NEG_B + half_scale) / scale;
    float lineCPosition = (LINE_C + half_scale) / scale;
    float lineNegCPosition = (LINE_NEG_C + half_scale) / scale;
    float lineDPosition = (LINE_D + half_scale) / scale;
    float lineNegDPosition = (LINE_NEG_D + half_scale) / scale;
    float lineEPosition = (LINE_E + half_scale) / scale;
    float lineNegEPosition = (LINE_NEG_E + half_scale) / scale;
    float lineFPosition = (LINE_F + half_scale) / scale;
    float lineNegFPosition = (LINE_NEG_F + half_scale) / scale;

    // float lineA1Position = (LINE_A1 + half_scale) / scale;
    // float lineNegA1Position = (LINE_NEG_A1 + half_scale) / scale;
    // float lineB1Position = (LINE_B1 + half_scale) / scale;
    // float lineNegB1Position = (LINE_NEG_B1 + half_scale) / scale;

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

    // Highlight the vertical lines - 1
    if (abs(vUv.x - lineAPosition) < lineThickness) {
        gradient2 = mix(color3, vec3(0.0, 0.0, 0.0), 0.7);
    }

    if (abs(vUv.x - lineNegAPosition) < lineThickness) {
        gradient2 = mix(color3, vec3(0.0, 0.0, 0.0), 0.7);
    }

    if (abs(vUv.x - lineBPosition) < lineThickness) {
        gradient2 = mix(color3, vec3(0.0, 0.0, 0.0), 0.7);
    }

    if (abs(vUv.x - lineNegBPosition) < lineThickness) {
        gradient2 = mix(color3, vec3(0.0, 0.0, 0.0), 0.7);
    }

    if (abs(vUv.x - lineCPosition) < lineThickness) {
        gradient2 = mix(color3, vec3(0.0, 0.0, 0.0), 0.7);
    }

    if (abs(vUv.x - lineNegCPosition) < lineThickness) {
        gradient2 = mix(color3, vec3(0.0, 0.0, 0.0), 0.7);
    }

    if (abs(vUv.x - lineDPosition) < lineThickness) {
        gradient2 = mix(color3, vec3(0.0, 0.0, 0.0), 0.7);
    }

    if (abs(vUv.x - lineNegDPosition) < lineThickness) {
        gradient2 = mix(color3, vec3(0.0, 0.0, 0.0), 0.7);
    }

    if (abs(vUv.x - lineEPosition) < lineThickness) {
        gradient2 = mix(color3, vec3(0.0, 0.0, 0.0), 0.7);
    }

    if (abs(vUv.x - lineNegEPosition) < lineThickness) {
        gradient2 = mix(color3, vec3(0.0, 0.0, 0.0), 0.7);
    }

    if (abs(vUv.x - lineFPosition) < lineThickness) {
        gradient2 = mix(color3, vec3(0.0, 0.0, 0.0), 0.7);
    }

    if (abs(vUv.x - lineNegFPosition) < lineThickness) {
        gradient2 = mix(color3, vec3(0.0, 0.0, 0.0), 0.7);
    }

    // Highlight the vertical lines - 2

    // if (abs(vUv.x - lineA1Position) < lineThickness) {
    //     gradient2 = mix(color3, vec3(0.0, 0.0, 0.0), 0.7);
    // }

    // if (abs(vUv.x - lineNegA1Position) < lineThickness) {
    //     gradient2 = mix(color3, vec3(0.0, 0.0, 0.0), 0.7);
    // }

    // if (abs(vUv.x - lineB1Position) < lineThickness) {
    //     gradient2 = mix(color3, vec3(0.0, 0.0, 0.0), 0.7);
    // }

    // if (abs(vUv.x - lineNegB1Position) < lineThickness) {
    //     gradient2 = mix(color3, vec3(0.0, 0.0, 0.0), 0.7);
    // }

    gl_FragColor = vec4(gradient2, 1.0);
}
