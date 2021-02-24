package representer.normalizers;

/*
 * Normalize braces
 */
class BraceNormalizer extends NormalizerBase {
	public function apply(data:ParseData) {
		for (d in data.decls) {
			switch (d.decl) {
				case EClass(d):
					normalizeClass(d);
				case EStatic(d):
					normalizeStatic(d);
				case _:
			}
		}
	}

	function normalizeClass(d:Definition<ClassFlag, Array<Field>>) {
		d.data.iter(f -> normalizeTypeField(f.kind));
	}

	function normalizeTypeField(ft:FieldType) {
		switch (ft) {
			case FFun(f):
				f.expr.iter(normalizeExpr);
			case FVar(_, varExpr):
				normalizeExpr(varExpr);
				varExpr.iter(normalizeExpr);
			case FProp(_, _, _, propExpr):
				normalizeExpr(propExpr);
				propExpr.iter(normalizeExpr);
		}
	}

	function normalizeStatic(d:Definition<StaticFlag, FieldType>) {
		normalizeTypeField(d.data);
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
