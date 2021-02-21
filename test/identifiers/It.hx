var x = true;
var boolVar = false == x;
var boolProp(null, null) = false == x;

function fun() {
	var boolVar = false == x;
}

class It {
	var boolVar = false == false;

	static var boolSVar = false == false;

	var boolProp(null, null) = false == false;

	function fun() {
		var boolVar = false == false;
	}
}
