package representer.normalizers;

/*
 * Normalize braces
 */
class BraceNormalizer extends NormalizerBase {
	public function apply(data:ParseData) {
		for (d in data.decls) {
			switch (d.decl) {
				case EImport(sl, mode):
				case EClass(d):
					normalizeClass(d);
				case EEnum(d):
				case ETypedef(d):
				case EAbstract(a):
				case EStatic(d):
				case EUsing(path):
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
		function addBrace(x) {
			switch (x.expr) {
				case EBlock(_):
				case _:
					// e.expr = macro {$x;}
			}
		}
		switch (e.expr) {
			case EFor(it, expr):
				expr.iter(addBrace);
			case EIf(econd, eif, eelse):
				eif.iter(addBrace);
			case EWhile(econd, e, normalWhile):
				e.iter(addBrace);
			case _:
		}
	}
}
