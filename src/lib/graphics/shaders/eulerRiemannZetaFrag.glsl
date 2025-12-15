precision highp float;
varying vec2 vUv;
uniform vec3 color1;
uniform vec3 color2;
uniform vec3 color3;
uniform vec2 mouse;

float zeta(float sigma, float t, float base) {
    float sum = 0.0;
    const int N = 100;
    float logBase = log(base);

    for (int n = 1; n <= N; ++n) {
        // Change base here too — affects peak amplitudes
        float term = pow(base, -sigma * log(float(n)) / logBase);
        float angle = -t * log(float(n)) / logBase;
        float tangentValue = tan(angle);
        if (abs(tangentValue) < 100.0) {
            sum += term * tangentValue;
        }
    }

    return sum;
}

void main() {
    float scale = 100.0;
    float half_scale = scale * 0.5;
    float sigma = vUv.y * scale - half_scale;
    float t = vUv.x * scale - half_scale;

    float base = pow(10.0, 10.0 * mouse.x);

    float zetaValue = zeta(sigma, t, base);

    vec3 gradient1 = mix(color1, color2, zetaValue);
    vec3 gradient2 = mix(color3, gradient1, 0.5 + 0.5 * sin(zetaValue * 3.14159));

    gl_FragColor = vec4(gradient2, 1.0);
}