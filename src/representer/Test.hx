using Lambda;

import haxe.io.Path;

class Test {
	final x = 5;

	static inline var xi = 5;

	static final field1 = 1;
	static var field2 = field1 + 1;

	var prop(null, null):Int;
	var boolVar = true == true;
	var boolProp(null, null) = true == true;
	var y = field1 == 1 ? 1 : 0;
	var z = 123e5;

	public static function hello(name:String) {
		var x = true;
		var y = x == true;
		var z = false == y;
		if (!x)
			trace("");
		trace(name);
		trace('hello $name');
		for (x in 0...10)
			trace(true);
		if (false)
			trace("false");
		if (false)
			if (true)
				trace("false");
		while (true)
			trace("true");
		while (true) {
			trace("true");
		}
	}
}
