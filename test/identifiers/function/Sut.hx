function sfun(arg1:Int, ?arg2:Int, arg3 = 1) {
	return arg1 + arg2 + arg3;
}

class Sut {
	function cfun(arg1:Int, ?arg2:Int, arg3 = 1) {
		return arg1 + arg2 + arg3;
	}
}
