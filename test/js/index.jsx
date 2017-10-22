import Renderer, { createElement } from "complate-stream";

let renderer = new Renderer("<!DOCTYPE html>");

renderer.registerView(function FrontPage(params) {
	return <div class="container">
		<span>lorem ipsum</span>
	</div>;
});

export default (stream, view, params, callback) => {
	let fragment = params && params._fragment === true;
	return renderer.renderView(view, params, stream, { fragment }, callback);
};
