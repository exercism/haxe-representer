package representer.normalizers;

class Identifiers extends NormalizerBase {
	// mapping of identifiers to placeholders
	public static var idMap(default, null) = new Map<String, String>();

	static var idMapIdx = 0;

	public function apply(data:ParseData) {
		for (dec in data.decls) {
			switch (dec.decl) {
				case EClass(d):
					normalizeClass(d);
				case EEnum(d):
					normalizeEnum(d);
				case ETypedef(d):
					normalizeTypeDef(d);
				case EStatic(d):
					nomalizeStatic(d);
				case _:
			};
		}
	}

	// retrieves placeholder, creating new one if not found
	static function mkPlaceholder(id:String):String {
		if (!idMap.exists(id))
			idMap[id] = 'PLACEHOLDER_${++idMapIdx}';
		return idMap[id];
	}

	// retrieves placeholder, returning identity if not found
	static function getPlaceholder(id:String):String
		return idMap.exists(id) ? idMap[id] : id;

	function normalizeClass(def:Definition<ClassFlag, Array<Field>>) {
		def.name = mkPlaceholder(def.name);
		for (flag in def.flags) {
			switch (flag) {
				case HExtends(t):
					t.name = mkPlaceholder(t.name);
				case _:
			}
		}
		for (field in def.data)
			normalizeField(field);
	}

	function normalizeField(f:Field) {
		f.name = mkPlaceholder(f.name);
		normalizeFieldType(f.kind);
	}

	function normalizeFieldType(ft:FieldType) {
		switch (ft) {
			case FVar(_, varExpr):
				varExpr.iter(normalizeExpr);
			case FFun(fun):
				fun.args.iter(arg -> arg.name = mkPlaceholder(arg.name));
				// fun.params.iter(param -> param.name = mkPlaceholder(param.name));
				fun.expr.iter(e -> trace(e));
				fun.expr.iter(normalizeExpr);
			case FProp(get, set, t, propExpr):
				if (propExpr != null)
					propExpr.iter(normalizeExpr);
		}
	}

	function normalizeEnum(d:Definition<EnumFlag, Array<EnumConstructor>>) {
		d.name = mkPlaceholder(d.name);
		d.data.iter(construct -> construct.name = mkPlaceholder(construct.name));
	}

	function normalizeTypeDef(d:Definition<EnumFlag, ComplexType>) {
		trace(d);
		d.name = mkPlaceholder(d.name);
		normalizeComplextType(d.data);
	}

	function normalizeComplextType(ct:ComplexType) {
		switch (ct) {
			case TPath(p):
				p.name = mkPlaceholder(p.name);
			case TFunction(args, ret):
			case TAnonymous(fields):
				fields.iter(f -> f.name = mkPlaceholder(f.name));
			case TParent(t):
			case TExtend(p, fields):
			case TOptional(t):
			case TNamed(n, t):
			case TIntersection(tl):
		}
	}

	function nomalizeStatic(d:Definition<StaticFlag, FieldType>) {
		d.name = mkPlaceholder(d.name);
		normalizeFieldType(d.data);
	}

	function normalizeExpr(e:Expr) {
		if (e == null)
			return;
		switch (e.expr) {
			case EConst(CIdent(ident)):
				e.expr = EConst(CIdent(getPlaceholder(ident)));
			case EConst(CString(s, SingleQuotes)):
				var ident = ~/\$([a-zA-Z0-9_]+)/g;
				if (ident.match(s)) {
					s = ident.map(s, m -> getPlaceholder(m.matched(1)));
					e.expr = EConst(CString(s, SingleQuotes));
				}
			case EVars(vars):
				for (v in vars) {
					v.name = mkPlaceholder(v.name);
					v.expr.iter(normalizeExpr);
				}
			case _:
				e.iter(normalizeExpr);
		}
	}
}
