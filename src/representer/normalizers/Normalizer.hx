package representer.normalizers;

typedef ParseData = {
	pack:Array<String>,
	decls:Array<TypeDecl>
}

class Normalizer {
	static var normalizers = [
		new Imports(),
		new Usings(),
		new Braces(),
		// new DeclarationOrder(),
		new Identifiers(),
		new Bools(),
		new Exponents(),
		new Flags({
			classF: [HFinal, HPrivate],
			staticF: [SFinal, SInline, SPrivate],
			accessF: [AFinal, AInline, APrivate, APublic]
		}),
	];

	public static function applyAll(data:ParseData) {
		for (normalizer in normalizers)
			normalizer.apply(data);
	}

	/*
	 * Walks the AST collecting and returning a list of exprs. 
	 * This is useful for normalizers that operate on Expr 
	 * and don't require matching specific TypeDefs.
	 */
	public static function collectExpr(data:ParseData):Array<Expr> {
		var exprs = [];
		function collExpr(e:Expr) {
			if (e == null)
				return;
			exprs.push(e);
			e.iter(collExpr);
		}
		for (d in data.decls) {
			switch (d.decl) {
				case EClass(d):
					for (f in d.data)
						switch (f.kind) {
							case FVar(t, e):
								collExpr(e);
							case FFun(f):
								collExpr(f.expr);
							case FProp(get, set, t, e):
								collExpr(e);
						}
				case EStatic(s):
					switch (s.data) {
						case FVar(t, e):
							collExpr(e);
						case FFun(f):
							collExpr(f.expr);
						case FProp(get, set, t, e):
							collExpr(e);
					}
				case _:
			}
		}
		return exprs;
	}
}
