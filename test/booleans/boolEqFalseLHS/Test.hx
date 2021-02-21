class Test {
	static var x = true;

	var boolVar = false == x;

	static var boolSVar = false == x;

	var boolProp(null, null) = false == x;

	static function fun() {
		var boolVar = false == x;
	}
}
