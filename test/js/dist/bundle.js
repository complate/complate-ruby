var render = (function () {
'use strict';

if(typeof global === "undefined" && typeof window !== "undefined") {
	window.global = window;
}

var BLANKS = [undefined, null, false];

// returns a function that invokes `callback` only after having itself been
// invoked `total` times
function awaitAll(total, callback) {
	var i = 0;
	return function (_) {
		i++;
		if (i === total) {
			callback();
		}
	};
}

// flattens array while discarding blank values
function flatCompact(items) {
	return items.reduce(function (memo, item) {
		/* eslint-disable indent */
		return BLANKS.indexOf(item) !== -1 ? memo : memo.concat(item.pop ? flatCompact(item) : item);
		/* eslint-enable indent */
	}, []);
}

function noop() {}

var asyncGenerator = function () {
  function AwaitValue(value) {
    this.value = value;
  }

  function AsyncGenerator(gen) {
    var front, back;

    function send(key, arg) {
      return new Promise(function (resolve, reject) {
        var request = {
          key: key,
          arg: arg,
          resolve: resolve,
          reject: reject,
          next: null
        };

        if (back) {
          back = back.next = request;
        } else {
          front = back = request;
          resume(key, arg);
        }
      });
    }

    function resume(key, arg) {
      try {
        var result = gen[key](arg);
        var value = result.value;

        if (value instanceof AwaitValue) {
          Promise.resolve(value.value).then(function (arg) {
            resume("next", arg);
          }, function (arg) {
            resume("throw", arg);
          });
        } else {
          settle(result.done ? "return" : "normal", result.value);
        }
      } catch (err) {
        settle("throw", err);
      }
    }

    function settle(type, value) {
      switch (type) {
        case "return":
          front.resolve({
            value: value,
            done: true
          });
          break;

        case "throw":
          front.reject(value);
          break;

        default:
          front.resolve({
            value: value,
            done: false
          });
          break;
      }

      front = front.next;

      if (front) {
        resume(front.key, front.arg);
      } else {
        back = null;
      }
    }

    this._invoke = send;

    if (typeof gen.return !== "function") {
      this.return = undefined;
    }
  }

  if (typeof Symbol === "function" && Symbol.asyncIterator) {
    AsyncGenerator.prototype[Symbol.asyncIterator] = function () {
      return this;
    };
  }

  AsyncGenerator.prototype.next = function (arg) {
    return this._invoke("next", arg);
  };

  AsyncGenerator.prototype.throw = function (arg) {
    return this._invoke("throw", arg);
  };

  AsyncGenerator.prototype.return = function (arg) {
    return this._invoke("return", arg);
  };

  return {
    wrap: function (fn) {
      return function () {
        return new AsyncGenerator(fn.apply(this, arguments));
      };
    },
    await: function (value) {
      return new AwaitValue(value);
    }
  };
}();





var classCallCheck = function (instance, Constructor) {
  if (!(instance instanceof Constructor)) {
    throw new TypeError("Cannot call a class as a function");
  }
};

var createClass = function () {
  function defineProperties(target, props) {
    for (var i = 0; i < props.length; i++) {
      var descriptor = props[i];
      descriptor.enumerable = descriptor.enumerable || false;
      descriptor.configurable = true;
      if ("value" in descriptor) descriptor.writable = true;
      Object.defineProperty(target, descriptor.key, descriptor);
    }
  }

  return function (Constructor, protoProps, staticProps) {
    if (protoProps) defineProperties(Constructor.prototype, protoProps);
    if (staticProps) defineProperties(Constructor, staticProps);
    return Constructor;
  };
}();







































var toArray = function (arr) {
  return Array.isArray(arr) ? arr : Array.from(arr);
};

var toConsumableArray = function (arr) {
  if (Array.isArray(arr)) {
    for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) arr2[i] = arr[i];

    return arr2;
  } else {
    return Array.from(arr);
  }
};

// cf. https://www.w3.org/TR/html5/syntax.html#void-elements
var VOID_ELEMENTS = {}; // poor man's set
["area", "base", "br", "col", "embed", "hr", "img", "input", "keygen", "link", "meta", "param", "source", "track", "wbr"].forEach(function (tag) {
	VOID_ELEMENTS[tag] = true;
});

// generates an "element generator" function which writes the respective HTML
// element(s) to an output stream
// that element generator expects three arguments: a writable stream¹, a flag
// permitting non-blocking I/O and a callback - the latter is invoked upon
// conclusion, without any arguments²
//
// this indirection is necessary because this function implements the signature
// expected by JSX, so not only do we need to inject additional arguments, we
// to defer element creation in order to re-align the invocation order³ - thus
// element generators operate as placeholders which are unwrapped later
//
// ¹ an object with methods `#write`, `#writeln` and `#flush`
//
// ² TODO: error handling
//
// ³ JSX is essentially a DSL for function invocations:
//
//     <foo alpha="hello" bravo="world">
//         <bar>…</bar>
//     </foo>
//
//   turns into
//
//     createElement("foo", { alpha: "hello", bravo: "world" },
//             createElement("bar", null, "…"));
//
//   without this indirection, `<bar>` would be created before `<foo>`
function generateHTML(tag, params) {
	for (var _len = arguments.length, children = Array(_len > 2 ? _len - 2 : 0), _key = 2; _key < _len; _key++) {
		children[_key - 2] = arguments[_key];
	}

	return function (stream, nonBlocking, callback) {
		stream.write("<" + tag + generateAttributes(params, tag) + ">");

		// NB:
		// * discarding blank values to avoid conditionals within JSX (passing
		//   `undefined`/`null`/`false` is much simpler)
		// * `children` might contain nested arrays due to the use of
		//   collections within JSX (`{items.map(item => <span>{item}</span>)}`)
		children = flatCompact(children);

		var total = children.length;
		if (total === 0) {
			closeElement(stream, tag, callback);
		} else {
			var close = awaitAll(total, function (_) {
				closeElement(stream, tag, callback);
			});
			processChildren(stream, children, nonBlocking, close);
		}
	};
}

function HTMLString(str) {
	this.value = str;
}

function processChildren(stream, children, nonBlocking, callback) {
	var _children = toArray(children),
	    child = _children[0],
	    remainder = _children.slice(1);

	if (child.call) {
		// distinguish regular element generators from deferred child elements
		if (child.length !== 1) {
			// XXX: arity makes for a brittle heuristic
			child(stream, nonBlocking, callback);
		} else {
			// deferred
			var fn = function fn(element) {
				element(stream, nonBlocking, callback);
				if (remainder.length) {
					processChildren(stream, remainder, nonBlocking, callback);
				}
			};

			if (nonBlocking) {
				child(fn);
			} else {
				// ensure deferred child element is synchronous
				var invoked = false;
				var _fn = fn;
				fn = function fn() {
					invoked = true;
					return _fn.apply(null, arguments);
				};
				child(fn);

				if (!nonBlocking && !invoked) {
					throw new Error("invalid non-blocking operation detected");
				}
			}
			return; // `remainder` processing continues recursively
		}
	} else {
		/* eslint-disable indent */
		var content = child instanceof HTMLString ? child.value : htmlEncode(child.toString());
		/* eslint-enable indent */
		stream.write(content);
		callback();
	}

	if (remainder.length) {
		processChildren(stream, remainder, nonBlocking, callback);
	}
}

function closeElement(stream, tag, callback) {
	if (!VOID_ELEMENTS[tag]) {
		// void elements must not have closing tags
		stream.write("</" + tag + ">");
	}

	stream.flush();
	callback();
}

function generateAttributes(params, tag) {
	if (!params) {
		return "";
	}

	var attribs = Object.keys(params).reduce(function (memo, name) {
		var value = params[name];
		switch (value) {
			// blank attributes
			case null:
			case undefined:
				break;
			// boolean attributes (e.g. `<input … autofocus>`)
			case true:
				memo.push(name);
				break;
			case false:
				break;
			// regular attributes
			default:
				// cf. https://html.spec.whatwg.org/multipage/syntax.html#attributes-2
				if (/ |"|'|>|'|\/|=/.test(name)) {
					abort("invalid HTML attribute name: " + repr(name), tag);
				}

				if (typeof value === "number") {
					value = value.toString();
				} else if (!value.substr) {
					abort("invalid value for HTML attribute `" + name + "`: " + (repr(value) + " (expected string)"), tag);
				}

				memo.push(name + "=\"" + htmlEncode(value, true) + "\"");
		}
		return memo;
	}, []);
	return attribs.length === 0 ? "" : " " + attribs.join(" ");
}

// adapted from TiddlyWiki <http://tiddlywiki.com> and Python 3's `html` module
function htmlEncode(str, attribute) {
	var res = str.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
	if (attribute) {
		res = res.replace(/"/g, "&quot;").replace(/'/g, "&#x27;");
	}
	return res;
}

function abort(msg, tag) {
	if (tag) {
		msg += " - did you perhaps intend to use `" + tag + "` as a macro?";
	}
	throw new Error(msg);
}

function repr(value) {
	return "`" + JSON.stringify(value) + "`";
}

// distinguishes macros from regular tags
function createElement(element, params) {
	for (var _len = arguments.length, children = Array(_len > 2 ? _len - 2 : 0), _key = 2; _key < _len; _key++) {
		children[_key - 2] = arguments[_key];
	}

	/* eslint-disable indent */
	return element.call ? element.apply(undefined, [params].concat(toConsumableArray(flatCompact(children)))) : generateHTML.apply(undefined, [element, params].concat(children));
	/* eslint-enable indent */
}

// a renderer typically provides the interface to the host environment
// it maps views' string identifiers to the corresponding macros and supports
// both HTML documents and fragments

var Renderer$1 = function () {
	function Renderer() {
		var doctype = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : "<!DOCTYPE html>";
		classCallCheck(this, Renderer);

		this._doctype = doctype;
		this._macroRegistry = {};
	}

	createClass(Renderer, [{
		key: "registerView",
		value: function registerView(macro) {
			var name = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : macro.name;
			var replace = arguments[2];

			if (!name) {
				throw new Error("missing name for macro: `" + macro + "`");
			}

			var macros = this._macroRegistry;
			if (macros[name] && !replace) {
				throw new Error("invalid macro name: `" + name + "` already registered");
			}
			macros[name] = macro;

			return name; // primarily for debugging
		}

		// `view` is either a macro function or a string identifying a registered macro
		// `params` is a mutable key-value object which is passed to the respective macro
		// `stream` is a writable stream (cf. `generateHTML`)
		// `fragment` is a boolean determining whether to omit doctype and layout
		// `callback` is an optional function invoked upon conclusion - if provided,
		// this activates non-blocking rendering

	}, {
		key: "renderView",
		value: function renderView(view, params, stream) {
			var _ref = arguments.length > 3 && arguments[3] !== undefined ? arguments[3] : {},
			    fragment = _ref.fragment;

			var callback = arguments[4];

			if (!fragment) {
				stream.writeln(this._doctype);
			}

			if (fragment) {
				if (!params) {
					params = {};
				}
				params._layout = false; // XXX: hacky? (e.g. might break due to immutability)
			}

			// resolve string identifier to corresponding macro
			var macro = view && view.substr ? this._macroRegistry[view] : view;
			if (!macro) {
				throw new Error("unknown view macro: `" + view + "` is not registered");
			}

			var element = createElement(macro, params);
			if (callback) {
				// non-blocking mode
				element(stream, true, callback);
			} else {
				// blocking mode
				element(stream, false, noop);
			}
		}
	}]);
	return Renderer;
}();

var renderer = new Renderer$1("<!DOCTYPE html>");

renderer.registerView(function FrontPage(params) {
	return createElement(
		"div",
		{ "class": "container" },
		createElement(
			"span",
			null,
			"lorem ipsum"
		)
	);
});

var index = (function (stream, view, params, callback) {
	var fragment = params && params._fragment === true;
	return renderer.renderView(view, params, stream, { fragment: fragment }, callback);
});

return index;

}());
