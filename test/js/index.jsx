import Renderer, { createElement } from "complate-stream";

let renderer = new Renderer("<!DOCTYPE html>");

renderer.registerView(function FrontPage({ text }) {
	return <div class="container">
		<span>{ text }</span>
	</div>;
});

export default renderer.renderView.bind(renderer);
