<script>
	import { trigMode, seriesN } from '$lib/store/store';

	const modes = ['tan', 'sin', 'cos'];

	function setMode(index) {
		trigMode.set(index);
	}

	function handleSlider(e) {
		seriesN.set(parseInt(e.target.value));
	}
</script>

<div class="controls">
	<div class="trig-toggle">
		{#each modes as mode, i}
			<button
				class:active={$trigMode === i}
				on:click={() => setMode(i)}
			>{mode}</button>
		{/each}
	</div>
	<div class="slider-row">
		<label>log(N)-Waves<span class="value">{$seriesN}</span></label>
		<input
			type="range"
			min="1"
			max="250"
			step="1"
			value={$seriesN}
			on:input={handleSlider}
		/>
	</div>
</div>

<style>
	.controls {
		position: fixed;
		top: 16px;
		right: 16px;
		z-index: 100;
		display: flex;
		flex-direction: column;
		gap: 0;
		border: 1px solid rgba(208, 208, 208, 0.3);
		background: rgba(35, 35, 35, 0.85);
		backdrop-filter: blur(4px);
	}

	.trig-toggle {
		display: flex;
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

	.slider-row {
		display: flex;
		align-items: center;
		gap: 8px;
		padding: 6px 12px;
		border-top: 1px solid rgba(208, 208, 208, 0.15);
	}

	label {
		font-size: 11px;
		letter-spacing: 0.12em;
		color: rgba(208, 208, 208, 0.5);
		white-space: nowrap;
		min-width: 42px;
	}

	.value {
		color: #d0d0d0;
		font-weight: 700;
		margin-left: 4px;
	}

	input[type="range"] {
		-webkit-appearance: none;
		appearance: none;
		width: 80px;
		height: 2px;
		background: rgba(208, 208, 208, 0.25);
		outline: none;
		cursor: pointer;
	}

	input[type="range"]::-webkit-slider-thumb {
		-webkit-appearance: none;
		appearance: none;
		width: 10px;
		height: 10px;
		background: #d0d0d0;
		border-radius: 0;
		cursor: pointer;
	}

	input[type="range"]::-moz-range-thumb {
		width: 10px;
		height: 10px;
		background: #d0d0d0;
		border: none;
		border-radius: 0;
		cursor: pointer;
	}
</style>