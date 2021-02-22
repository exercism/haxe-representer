var a = if (true) 1 else 2;
var b(null, null) = if (true) 1 else 2;

class Sut {
	var x = if (true) 1 else 2;

	static var y = if (true) 1 else 2;

	var z(null, null) = if (true) 1 else 2;

	function fun() {
		if (true)
			if (false)
				trace(1);
			else
				trace(1);
		while (true)
			while (false)
				trace(1);
		for (_ in 0...0)
			for (_ in 0...0)
				trace(1);
	}

	static function sfun() {
		for (_ in 0...0)
			if (true)
				while (true)
					trace(1)
			else
				trace(1);
	}
}
