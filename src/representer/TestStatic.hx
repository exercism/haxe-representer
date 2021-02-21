import haxe.io.Path;

using Lambda;

typedef TypeDefB = {
	b:Int,
	a:Int
};

typedef TypeDefA = {
	b:Int,
	a:Int
};

enum EnumB {
	c;
	b;
	a;
}

enum EnumA {
	b;
	a;
	c;
}

private var field1 = 1;
private var field2 = field1 + 1;

function hello(name:String) {
	trace('hello $name');
	if (true) {
		trace("true");
	}
	if (false)
		trace("false");
}
