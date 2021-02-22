var a = 1;
var b = '$a';
var c = '$a + $b';
var d = '${a + b}';
var e = '${a + b} + ${a + b}';

class Sut {
	static var a = 1;
	static var b = '$a';
	static var c = '$a + $b';
	static var d = '${a + b}';
	static var e = '${a + b} + ${a + b}';
}
