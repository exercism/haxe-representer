package representer.normalizers;

/*
 * Normalize boolean expressions
 */
class BoolNormalizer extends NormalizerBase {
	public function apply(data:ParseData) {
		Normalizer.collectExpr(data).iter(normalizeExpr);
	}

	function normalizeExpr(e:Expr) {
		if (e == null)
			return;
		switch (e) {
			case(macro true == $x):
				e.expr = x.expr;
			case(macro $x == true):
				e.expr = x.expr;
			case(macro false == $x):
				e.expr = EUnop(OpNot, false, x);
			case(macro $x == false):
				e.expr = EUnop(OpNot, false, x);
			case _:
				e.iter(normalizeExpr);
		}
	}
}
