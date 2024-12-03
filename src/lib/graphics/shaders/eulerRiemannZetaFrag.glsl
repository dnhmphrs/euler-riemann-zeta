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

// Function to compute the Euler–Riemann zeta function
float zeta(float sigma, float t) {
    float sum = 0.0;
    const int N = 2; // Number of terms in the series for approximation

    for (int n = 1; n <= N; ++n) {
        float term = pow(float(n), -sigma);
        float angle = -t * log(float(n));
        // sum += term * tan(angle); // Tangent part
        float tangentValue = tan(angle);
        if (abs(tangentValue) <100.0) {
            sum += term * tangentValue;
        }
    }

    return sum;
}


void main() {
    float scale = 200.0;
    float half_scale = scale * 0.5;
    // Map the fragment coordinates to the complex plane
    float sigma = vUv.y * scale - half_scale; // Real part of s (horizontal axis)
    float t = vUv.x * scale - half_scale;    // Imaginary part of s (vertical axis)

    // Compute the zeta function value
    float zetaValue = zeta(sigma, t);

    // Normalize zetaValue to map to color range
    // float normalizedZeta = 0.5 + 0.1 * zetaValue; // Adjust scaling factor for better contrast

    // Create gradients for visualization
    vec3 gradient1 = mix(color1, color2, zetaValue);
    vec3 gradient2 = mix(color3, gradient1, 0.5 + 0.5 * sin(zetaValue * 3.14159));

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
