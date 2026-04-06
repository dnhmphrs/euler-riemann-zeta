<script>
	import { trigMode } from '$lib/store/store';

	const modes = ['tan', 'sin', 'cos'];

	function setMode(index) {
		trigMode.set(index);
	}
</script>

<div class="trig-toggle">
	{#each modes as mode, i}
		<button
			class:active={$trigMode === i}
			on:click={() => setMode(i)}
		>{mode}</button>
	{/each}
</div>

<style>
	.trig-toggle {
		position: fixed;
		top: 16px;
		right: 16px;
		z-index: 100;
		display: flex;
		gap: 0;
		border: 1px solid rgba(208, 208, 208, 0.3);
		background: rgba(35, 35, 35, 0.85);
		backdrop-filter: blur(4px);
	}

	button {
		all: unset;
		padding: 6px 12px;
		font-family: inherit;
		font-size: 11px;
		letter-spacing: 0.12em;
		color: rgba(208, 208, 208, 0.4);
		cursor: pointer;
		text-transform: uppercase;
		transition: color 0.15s, background 0.15s;
		border-right: 1px solid rgba(208, 208, 208, 0.15);
	}

	button:last-child {
		border-right: none;
	}

	button:hover {
		color: rgba(208, 208, 208, 0.7);
	}

	button.active {
		color: #d0d0d0;
		font-weight: 700;
		background: rgba(208, 208, 208, 0.08);
	}
</style>