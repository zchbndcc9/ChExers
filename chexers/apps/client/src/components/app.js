import { h, Component } from 'preact';
import { Router } from 'preact-router';
import Game from './game';
require("preact/debug");

export default class App extends Component {
	render() {
		return (
			<div class="container" id="app">
				<Game />
			</div>
		)
	}
}
