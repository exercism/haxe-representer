class Sut {
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
}
