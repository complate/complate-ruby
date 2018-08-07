module.exports = {
	js: [{
		source: "./index.jsx",
		target: "./dist/bundle.js",
		exports: "render",
		esnext: true,
		jsx: { pragma: "createElement" }
	}]
};
