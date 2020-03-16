function render(view, params, stream, opts, callback) {
	if (view === 'add') {
		stream.write("Add: " + add(params));
	} else if (view === 'streaming') {
		for (var i = 0; i<3; i++) {
			stream.write('Block ' + i);
			stream.flush();
		}
	} else if (view === 'hello') {
		console.log('hello', 'world');
		stream.write('hello');
	} else if (view === 'list') {
		stream.write("Arguments: " + params.a + ", " + params.b + ", " + params.c);
	} else if (view === 'performance') {
		for (var i = 0; i < params.objs.length; i++) {
			stream.write(params.objs[i].propOrMeth);
		}
	} else {
		stream.write("View not found: " + view);
	}
	callback();
}
