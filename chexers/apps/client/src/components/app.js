import { h, Component } from 'preact';
import { Router } from 'preact-router';

import Board from './board';
require("preact/debug");

export default class App extends Component {
	
	render() {
		return (
			<div id="app">
				<Board size={9}/>
			</div>
		)
	}
}
