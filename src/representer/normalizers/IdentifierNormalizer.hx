package representer.normalizers;

class IdentifierNormalizer extends NormalizerBase {
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
	static function placeholder(id:String):String {
		if (!idMap.exists(id))
			idMap[id] = 'PLACEHOLDER_${++idMapIdx}';
		return idMap[id];
	}

	// tries to retrieve placeholder, returning identity if not found
	static function placeholderIfExists(id:String):String
		return idMap.exists(id) ? idMap[id] : id;

	function normalizeClass(def:Definition<ClassFlag, Array<Field>>) {
		def.name = placeholder(def.name);
		for (flag in def.flags) {
			switch (flag) {
				case HExtends(t):
					t.name = placeholder(t.name);
				case _:
			}
		}
		for (field in def.data)
			normalizeField(field);
	}

	function normalizeField(f:Field) {
		f.name = placeholder(f.name);
		normalizeFieldType(f.kind);
	}

	function normalizeFieldType(ft:FieldType) {
		switch (ft) {
			case FVar(_, varExpr):
				normalizeExpr(varExpr);
				varExpr.iter(normalizeExpr);
			case FFun(fun):
				fun.args.iter(arg -> arg.name = placeholder(arg.name));
				fun.expr.iter(normalizeExpr);
			case FProp(_, _, _, propExpr):
				if (propExpr != null) {
					normalizeExpr(propExpr);
					propExpr.iter(normalizeExpr);
				}
		}
	}

	function normalizeEnum(d:Definition<EnumFlag, Array<EnumConstructor>>) {
		d.name = placeholder(d.name);
		d.data.iter(construct -> construct.name = placeholder(construct.name));
	}

	function normalizeTypeDef(d:Definition<EnumFlag, ComplexType>) {
		d.name = placeholder(d.name);
		normalizeComplextType(d.data);
	}

	function normalizeComplextType(ct:ComplexType) {
		switch (ct) {
			case TPath(p):
				p.name = placeholder(p.name);
			case TFunction(_, _):
			case TAnonymous(fields):
				fields.iter(f -> f.name = placeholder(f.name));
			case TParent(_):
			case TExtend(_, _):
			case TOptional(_):
			case TNamed(_, _):
			case TIntersection(_):
		}
	}

	function nomalizeStatic(d:Definition<StaticFlag, FieldType>) {
		d.name = placeholder(d.name);
		normalizeFieldType(d.data);
	}

	function normalizeExpr(e:Expr) {
		if (e == null)
			return;
		switch (e.expr) {
			// identifier
			case EConst(CIdent(ident)):
				e.expr = EConst(CIdent(placeholderIfExists(ident)));
			// interpolated identifier
			case EConst(CString(s, SingleQuotes)):
				var ident1 = ~/\$([a-zA-Z0-9_]+)/g;
				if (ident1.match(s)) {
					s = ident1.map(s, m -> placeholderIfExists(m.matched(1)));
					e.expr = EConst(CString(s, SingleQuotes));
					return;
				}
				var ident2 = ~/\$\{(.*?)\}/g;
				if (ident2.match(s)) {
					var pat = ~/(([a-zA-Z0-9_]+).*?)/g;
					s = pat.map(s, m -> placeholderIfExists(m.matched(2)));
					e.expr = EConst(CString(s, SingleQuotes));
					return;
				}
			case EVars(vars):
				for (v in vars) {
					v.name = placeholder(v.name);
					v.expr.iter(normalizeExpr);
				}
			case EField(fieldExpr, field):
				e.expr = EField(fieldExpr, placeholder(field));
			case _:
				e.iter(normalizeExpr);
		}
	}
}
