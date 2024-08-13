<script>
	import Nav from './nav.svelte';
	import { page } from '$app/stores';
	import Matrix from './matrix.svelte';
	import { mouseOverHeader } from '$lib/store/store';
	// import { darkMode, screenType } from '$lib/store/store';

	function handleMouseOver() {
		mouseOverHeader.set(true);
	}

	function handleMouseOut() {
		mouseOverHeader.set(false);
	}

	// import { page } from '$app/stores';
	// import { goto } from '$app/navigation';

	// $: showMatrix = ['/', '/kp-equation', '/tangent-lattice'].includes($page.url.pathname);
	$: showMatrix = false;

	// stub data out
	const navItems = [
		{
			name: 'Euler-Riemann Zeta - Tangent',
			href: '/'
		},
		{
			name: 'Real Part - Simple',
			href: '/simple'
		},
		{
			name: 'Tangent - Mobius',
			href: '/projective'
		},
		{
			name: 'Functional Equation - Real Part - Mobius',
			href: '/functional'
		},
		{
			name: 'Real Part  - Mobius',
			href: '/real'
		},
		{
			name: 'Imangiary Part  - Mobius',
			href: '/imaginary'
		}
	];

	// let toggleDarkMode = () => {
	// 	darkMode.set(!$darkMode);
	// 	document.querySelector(':root').classList.toggle('dark-mode');
	// 	};
</script>

<header
	on:mouseover={handleMouseOver}
	on:mouseout={handleMouseOut}
	on:focus={handleMouseOver}
	on:blur={handleMouseOut}
>
	<main>
		<div />
		{#if showMatrix}
			<Matrix />
		{/if}
		<Nav {navItems} />
	</main>
</header>

<style>
	header {
		user-select: none;
		color: var(--primary);
	}

	main {
		margin: auto;
		max-width: 100vw;
		display: flex;
		flex-flow: row nowrap;
		justify-content: space-between;

		padding: 20px;
		font-size: 12px;
		height: calc(2 * var(--margin));
	}
</style>
