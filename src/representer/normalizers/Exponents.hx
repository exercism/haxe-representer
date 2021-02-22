package representer.normalizers;

/*
 * Normalize exponent expressions (e.g. converts 14e32 -> 14E32)
 */
class Exponents extends NormalizerBase {
	public function apply(data:ParseData) {
		Normalizer.collectExpr(data).iter(normalizeExpr);
	}

	function normalizeExpr(e:Expr) {
		if (e == null)
			return;
		switch (e.expr) {
			case EConst(CFloat(f)):
				var pat = ~/\de-?\d/;
				if (pat.match(f))
					e.expr = EConst(CFloat(f.toUpperCase()));
			case _:
				e.iter(normalizeExpr);
		}
	}
}
