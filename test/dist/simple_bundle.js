function render(stream, a, b, c) {
  if (a === 'add') {
    stream.write("Add: " + add(b, c));
  }
  else {
    var args = Array.prototype.slice.call(arguments, 1);
    stream.write("Arguments: " + args.join(', ') );
  }
}
