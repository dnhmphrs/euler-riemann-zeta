precision highp float;
varying vec2 vUv;
uniform vec3 color1;
uniform vec3 color2;
uniform vec3 color3;
uniform vec2 mouse;

// const float LINE_THICKNESS = 0.0002;
// const float CRITICAL_LINE = 0.5;
// const float ZERO_LINE = 0.0;
// const float ONE_LINE = 1.0;

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

    // Apply a projective transformation (spherical) to map to the projective plane
    float projectedSigma = sigma / (1.0 + sigma * sigma + t * t);
    float projectedT = t / (1.0 + sigma * sigma + t * t);

    // Compute the zeta function value
    float zetaValue = zeta(projectedSigma, projectedT);

    // Normalize zetaValue to map to color range
    float normalizedZeta = 0.5 + 0.1 * zetaValue; // Adjust scaling factor for better contrast

    // Create gradients for visualization
    vec3 gradient1 = mix(color1, color2, normalizedZeta);
    vec3 gradient2 = mix(color3, gradient1, sin(normalizedZeta));

    // // Project the critical strip
    // float projectedCriticalLine = CRITICAL_LINE / (1.0 + CRITICAL_LINE * CRITICAL_LINE + projectedT * projectedT);
    // float criticalLinePosition = (projectedCriticalLine + half_scale) / scale;
    // if (abs(vUv.y - criticalLinePosition) < LINE_THICKNESS) {
    //     gradient2 = mix(color3, vec3(1.0, 0.0, 0.0), 0.7); // Red line for the critical strip
    // }

    // // Project the zero line
    // float projectedZeroLine = ZERO_LINE / (1.0 + ZERO_LINE * ZERO_LINE + projectedT * projectedT);
    // float zeroLinePosition = (projectedZeroLine + half_scale) / scale;
    // if (abs(vUv.y - zeroLinePosition) < LINE_THICKNESS) {
    //     gradient2 = mix(color3, vec3(0.0, 0.0, 0.0), 0.7); // Black line for zero
    // }

    // // Project the one line
    // float projectedOneLine = ONE_LINE / (1.0 + ONE_LINE * ONE_LINE + projectedT * projectedT);
    // float oneLinePosition = (projectedOneLine + half_scale) / scale;
    // if (abs(vUv.y - oneLinePosition) < LINE_THICKNESS) {
    //     gradient2 = mix(color3, vec3(0.0, 0.0, 0.0), 0.7); // Black line for one
    // }

    // // Highlight the vertical lines
    // for (int i = 0; i < numVerticalLines; i++) {
    //     float projectedVerticalLine = verticalLines[i] / (1.0 + verticalLines[i] * verticalLines[i] + projectedT * projectedT);
    //     float linePosition = (projectedVerticalLine + half_scale) / scale;
    //     if (abs(vUv.x - linePosition) < LINE_THICKNESS) {
    //         gradient2 = mix(color3, vec3(0.0, 0.0, 0.0), 0.7);
    //     }
    // }

    gl_FragColor = vec4(gradient2, 1.0);
}
