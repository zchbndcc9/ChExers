import { h, Component, render } from 'preact';
import { Router } from 'preact-router';
import Game from './game'
import Home from './home'
require("preact/debug");

const App = () =>  (
	<div class="container" id="app">
		<Router>
			<Home path="/" />
			<Game path="/game/:id" />
		</Router>
	</div>
)

export default App
