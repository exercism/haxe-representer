package representer.normalizers;

/*
 * Normalize braces
 */
class Braces extends NormalizerBase {
	public function apply(data:ParseData) {
		for (d in data.decls) {
			switch (d.decl) {
				case EClass(d):
					normalizeClass(d);
				case EStatic(d):
				case _:
			}
		}
	}

	function normalizeClass(d:Definition<ClassFlag, Array<Field>>) {
		for (field in d.data) {
			switch (field.kind) {
				case FFun(f):
					f.expr.iter(normalizeExpr);
				case _:
			}
		}
	}

	function normalizeExpr(e:Expr) {
		if (e == null)
			return;
		// TODO: figure out why this is adding a semicolon to the end of each block
		function addBrace(x) {
			return switch (x.expr) {
				case EBlock(_):
					x;
				case _:
					macro {$x;}
			}
		}
		switch (e.expr) {
			case EFor(it, efor):
				efor = addBrace(efor);
				e.expr = EFor(it, efor);
				efor.iter(normalizeExpr);
			case EIf(econd, eif, eelse):
				eif = addBrace(eif);
				e.expr = EIf(econd, eif, eelse);
				eif.iter(normalizeExpr);
			case EWhile(econd, ewhile, normalWhile):
				ewhile = addBrace(ewhile);
				e.expr = EWhile(econd, ewhile, normalWhile);
				ewhile.iter(normalizeExpr);
			case _:
		}
	}
}
