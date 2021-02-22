var svar = 1;
var sprop(null, null) = 1;

function sfun(sarg1:Int, sarg2:Int):Int {
	var sfvar = 1;
	return sarg1 + sarg2 + sfvar;
}

class Sut {
	var cvar = 1;

	static var scvar = 1;

	var cprop(null, null) = 1;

	function cfun(carg1:Int, carg2:Int):Int {
		var cfvar = 1;
		return carg1 + carg2 + cfvar;
	}
}
