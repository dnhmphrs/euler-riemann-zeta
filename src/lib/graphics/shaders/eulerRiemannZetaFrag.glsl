precision highp float;
varying vec2 vUv;
uniform vec3 color1;
uniform vec3 color2;
uniform vec3 color3;
uniform vec2 mouse;

float zeta(float sigma, float t, float base, float power) {
    float sum = 0.0;
    const int N = 250;
    float logBase = log(base);

    for (int n = 1; n <= N; ++n) {
        float term = pow(float(n), -sigma * power);
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

    float base = pow(20.0, 20.0 * mouse.x);
    float power = 10.0 * mouse.y;

    float zetaValue = zeta(sigma, t, base, power);

    vec3 gradient1 = mix(color1, color2, zetaValue);
    vec3 gradient2 = mix(color3, gradient1, 0.5 + 0.5 * sin(zetaValue * 3.14159));

    gl_FragColor = vec4(gradient2, 1.0);
}