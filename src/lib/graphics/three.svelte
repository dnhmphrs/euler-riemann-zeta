<script>
	import { onMount, onDestroy  } from 'svelte';
	import { screenType, mousePosition, mouseOverHeader, trigMode, seriesN } from '$lib/store/store';
	import { page } from '$app/stores';
	import { afterNavigate } from '$app/navigation';

	import * as THREE from 'three';
	import Stats from 'stats.js'

	import vertexShader from './shaders/vertexShader-three.glsl';
	import fragmentShader_euler_riemann_zeta from './shaders/eulerRiemannZetaFrag.glsl';
	import fragmentShader_euler_riemann_zeta_simple from './shaders/eulerRiemannZetaFrag-simple.glsl';
	import fragmentShader_euler_riemann_zeta_functional from './shaders/eulerRiemannZetaFrag-functional.glsl';
	import fragmentShader_euler_riemann_zeta_real from './shaders/eulerRiemannZetaFrag-real.glsl';
	import fragmentShader_euler_riemann_zeta_imaginary from './shaders/eulerRiemannZetaFrag-imaginary.glsl';
	import fragmentShader_euler_riemann_zeta_projective from './shaders/eulerRiemannZetaFrag-projective.glsl';
	import fragmentShader_xi from './shaders/xiFrag.glsl';


	let shaderMaterial_euler_riemann_zeta, shaderMaterial_euler_riemann_zeta_simple, shaderMaterial_euler_riemann_zeta_functional, shaderMaterial_euler_riemann_zeta_real, shaderMaterial_euler_riemann_zeta_imaginary, shaderMaterial_euler_riemann_zeta_projective, shaderMaterial_xi;

	let allMaterials = [];

	let container;
	let stats;

	let camera, scene, renderer;

	let width = window.innerWidth;
	let height = window.innerHeight;

	let mouse = new THREE.Vector2();
	const clock = new THREE.Clock();

	stats = new Stats()
	stats.showPanel(0)
	
	init();
	animate();

	// React to trigMode changes — all materials
	$: {
		const mode = $trigMode;
		allMaterials.forEach(mat => {
			if (mat && mat.uniforms && mat.uniforms.trigMode) {
				mat.uniforms.trigMode.value = mode;
			}
		});
	}

	// React to seriesN changes — only the home shader
	$: {
		const n = $seriesN;
		if (shaderMaterial_euler_riemann_zeta && shaderMaterial_euler_riemann_zeta.uniforms.seriesN) {
			shaderMaterial_euler_riemann_zeta.uniforms.seriesN.value = n;
		}
	}

	function setupShaderMaterials() {
		const uniformsBase = {
			time: { value: 0 },
			mouse: { value: mouse },
			trigMode: { value: $trigMode }
		};

		const colors = {
			color1: new THREE.Color(0xd0d0d0),
			color2: new THREE.Color(0xbb4500),
			color3: new THREE.Color(0xdaaa55),
			color4: new THREE.Color(0x006994 ),
			color5: new THREE.Color(0x5099b4 ),
			color6: new THREE.Color(0x0000ff),
			color7: new THREE.Color(0x00ff00),
			color8: new THREE.Color(0xA020F0),
			color9: new THREE.Color(0x8fbd5a),
			color0: new THREE.Color(0x232323),
		}

		// Home shader gets the extra seriesN uniform
		shaderMaterial_euler_riemann_zeta = new THREE.ShaderMaterial({
			vertexShader: vertexShader,
			fragmentShader: fragmentShader_euler_riemann_zeta,
			uniforms: {
				...uniformsBase,
				seriesN: { value: $seriesN },
				color1: { value: colors.color1 },
				color2: { value: colors.color5 },
				color3: { value: colors.color9 },
			}
		});

		shaderMaterial_euler_riemann_zeta_simple = new THREE.ShaderMaterial({
			vertexShader: vertexShader,
			fragmentShader: fragmentShader_euler_riemann_zeta_simple,
			uniforms: {
				...uniformsBase,
				color1: { value: colors.color1 },
				color2: { value: colors.color5 },
				color3: { value: colors.color9 },
			}
		});

		shaderMaterial_euler_riemann_zeta_functional = new THREE.ShaderMaterial({
			vertexShader: vertexShader,
			fragmentShader: fragmentShader_euler_riemann_zeta_functional,
			uniforms: {
				...uniformsBase,
				color1: { value: colors.color1 },
				color2: { value: colors.color5 },
				color3: { value: colors.color9 },
			}
		});

		shaderMaterial_euler_riemann_zeta_real = new THREE.ShaderMaterial({
			vertexShader: vertexShader,
			fragmentShader: fragmentShader_euler_riemann_zeta_real,
			uniforms: {
				...uniformsBase,
				color1: { value: colors.color1 },
				color2: { value: colors.color5 },
				color3: { value: colors.color9 },
			}
		});

		shaderMaterial_euler_riemann_zeta_imaginary = new THREE.ShaderMaterial({
			vertexShader: vertexShader,
			fragmentShader: fragmentShader_euler_riemann_zeta_imaginary,
			uniforms: {
				...uniformsBase,
				color1: { value: colors.color1 },
				color2: { value: colors.color5 },
				color3: { value: colors.color9 },
			}
		});

		shaderMaterial_euler_riemann_zeta_projective = new THREE.ShaderMaterial({
			vertexShader: vertexShader,
			fragmentShader: fragmentShader_euler_riemann_zeta_projective,
			uniforms: {
				...uniformsBase,
				color1: { value: colors.color1 },
				color2: { value: colors.color5 },
				color3: { value: colors.color9 },
			}
		});
		
		shaderMaterial_xi = new THREE.ShaderMaterial({
			vertexShader: vertexShader,
			fragmentShader: fragmentShader_xi,
			uniforms: {
				...uniformsBase,
				color1: { value: colors.color1 },
				color2: { value: colors.color5 },
				color3: { value: colors.color9 },
			}
		});

		allMaterials = [
			shaderMaterial_euler_riemann_zeta,
			shaderMaterial_euler_riemann_zeta_simple,
			shaderMaterial_euler_riemann_zeta_functional,
			shaderMaterial_euler_riemann_zeta_real,
			shaderMaterial_euler_riemann_zeta_imaginary,
			shaderMaterial_euler_riemann_zeta_projective,
			shaderMaterial_xi
		];
	}

	function updateShaderUniforms() {
	}

	function init() {
		camera = new THREE.PerspectiveCamera(20, width / height, 1, 800);
		camera.position.z = 400;

		scene = new THREE.Scene();
		scene.background = new THREE.Color(0x232323);

		setupShaderMaterials();
		setScene();

		renderer = new THREE.WebGLRenderer({ antialias: false });
		renderer.setPixelRatio(window.devicePixelRatio);
		renderer.setSize(width, height);

		onMount(() => {
			container.appendChild(renderer.domElement);
		});

		window.addEventListener('mousemove', onDocumentMouseMove);
		window.addEventListener('resize', onWindowResize);
	}

	function setHome () {
		let plane4 = new THREE.Mesh(new THREE.PlaneGeometry(1000, 1000), shaderMaterial_euler_riemann_zeta);
		scene.add(plane4);
	}

	function setEulerRiemannZetaSimple() {
		let plane4 = new THREE.Mesh(new THREE.PlaneGeometry(1000, 1000), shaderMaterial_euler_riemann_zeta_simple);
		scene.add(plane4);
	}

	function setEulerRiemannZetaFunctional() {
		let plane4 = new THREE.Mesh(new THREE.PlaneGeometry(1000, 1000), shaderMaterial_euler_riemann_zeta_functional);
		scene.add(plane4);
	}

	function setEulerRiemannZetaReal() {
		let plane4 = new THREE.Mesh(new THREE.PlaneGeometry(1000, 1000), shaderMaterial_euler_riemann_zeta_real);
		scene.add(plane4);
	}

	function setEulerRiemannZetaImaginary() {
		let plane4 = new THREE.Mesh(new THREE.PlaneGeometry(1000, 1000), shaderMaterial_euler_riemann_zeta_imaginary);
		scene.add(plane4);
	}

	function setEulerRiemannZetaProjective() {
		let plane4 = new THREE.Mesh(new THREE.PlaneGeometry(1000, 1000), shaderMaterial_euler_riemann_zeta_projective);
		scene.add(plane4);
	}

	function setXi() {
		let plane4 = new THREE.Mesh(new THREE.PlaneGeometry(1000, 1000), shaderMaterial_xi);
		scene.add(plane4);
	}

	function setScene () {
		if ($page.url.pathname == '/') {
			setHome();
		}
		if ($page.url.pathname == '/simple') {
			setEulerRiemannZetaSimple();
		}
		if ($page.url.pathname == '/functional') {
			setEulerRiemannZetaFunctional();
		}
		if ($page.url.pathname == '/projective') {
			setEulerRiemannZetaProjective();
		}
		if ($page.url.pathname == '/real') {
			setEulerRiemannZetaReal();
		}
		if ($page.url.pathname == '/imaginary') {
			setEulerRiemannZetaImaginary();
		}
		if ($page.url.pathname == '/xi') {
			setXi();
		}
	}

	afterNavigate (onNavigate);
	function onNavigate() {
		for( var i = scene.children.length - 1; i >= 0; i--) { 
				let obj = scene.children[i];
				scene.remove(obj); 
		}
		setScene();
	}

	function onWindowResize() {
		let width = window.innerWidth;
		let height = window.innerHeight;

		camera.aspect = width / height;
		camera.updateProjectionMatrix();

		renderer.setSize(width, height);
	}

	function onDocumentMouseMove(event) {
		var clientX = event.clientX;
		var clientY = event.clientY;

		mouse.x = (clientX / window.innerWidth) * 2 - 1;
		mouse.y = -(clientY / window.innerHeight) * 2 + 1;

		if ($mouseOverHeader) {
			mouse.x = 0;
			mouse.y = 0;
		}
		
		mousePosition.set(mouse);
	};

	function animate() {
		requestAnimationFrame(animate);
		stats.begin()
		render();
		stats.end()
	}

	function render() {
		updateShaderUniforms();
		renderer.render(scene, camera);
	}

	onDestroy(() => {
		window.removeEventListener('mousemove', onDocumentMouseMove);
		window.removeEventListener('resize', onWindowResize);
		scene.traverse(object => {
			if (object instanceof THREE.Mesh) {
				object.geometry.dispose();
				object.material.dispose();
			}
		});
		renderer.dispose();
	});

</script>

<div bind:this={container} class:geometry={true} />

<style>
	.geometry {
		position: absolute;
		overflow: hidden;
		z-index: -1;
	}
</style>