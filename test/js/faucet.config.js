let config = {
	manifest: false,
	bundles: [{
		entryPoint: "index.jsx",
		target: "dist/bundle.js",
		moduleName: "render",
		transpiler: {
			features: ["es2015","jsx"],
			jsx: { pragma: "createElement" }
		}
	}]
};

module.exports = {
	js: config
};
