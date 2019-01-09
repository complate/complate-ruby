import Renderer, { createElement } from "../dummy_app/node_modules/complate-stream";

let renderer = new Renderer("<!DOCTYPE html>");

renderer.registerView(function FrontPage({ text }) {
	return <div class="container">
		<span>{ text }</span>
	</div>;
});

export default renderer.renderView.bind(renderer);
