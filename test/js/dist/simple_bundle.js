function render(stream, a, b, c) {
  if (a === 'add') {
    stream.write("Add: " + add(b, c));
  }
  else if (a === 'streaming') {
    for (var i = 0; i<3; i++) {
      stream.write('Block ' + i);
      stream.flush();
    }
  }
  else {
    var args = Array.prototype.slice.call(arguments, 1);
    stream.write("Arguments: " + args.join(', ') );
  }
}
