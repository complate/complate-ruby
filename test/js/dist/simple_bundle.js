function render(view, params, stream, opts) {
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
	}
}
