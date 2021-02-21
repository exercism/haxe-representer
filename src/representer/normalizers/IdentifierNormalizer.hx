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

	static function mkPlaceholder(id:String):String {
		if (!idMap.exists(id))
			idMap[id] = 'PLACEHOLDER_${++idMapIdx}';
		var placeholder = idMap[id];
		return placeholder;
	}

	static function getPlaceholder(id:String):String
		return idMap.exists(id) ? idMap[id] : id;

	function normalizeClass(def:Definition<ClassFlag, Array<Field>>) {
		def.name = mkPlaceholder(def.name);
		for (field in def.data)
			normalizeField(field);
	}

	function normalizeField(f:Field) {
		f.name = mkPlaceholder(f.name);
		switch (f.kind) {
			case FVar(_, e):
				e.iter(normalizeExpr);
			case FFun(f):
				f.args.iter(p -> p.name = mkPlaceholder(p.name));
				f.params.iter(p -> p.name = mkPlaceholder(p.name));
				f.expr.iter(normalizeExpr);
			case FProp(get, set, t, e):
				if (e != null)
					e.iter(normalizeExpr);
		}
	}

	function normalizeEnum(d:Definition<EnumFlag, Array<EnumConstructor>>) {}

	function normalizeTypeDef(d:Definition<EnumFlag, ComplexType>) {}

	function nomalizeStatic(d:Definition<StaticFlag, FieldType>) {}

	function normalizeExpr(e:Expr) {
		if (e == null)
			return;
		switch (e.expr) {
			case EConst(CIdent(ident)):
				e.expr = EConst(CIdent(getPlaceholder(ident)));
			case EConst(CString(s, SingleQuotes)):
				var ident = ~/\$([a-zA-Z0-9_]+)/g;
				if (ident.match(s))
					s = ident.map(s, m -> getPlaceholder(m.matched(1)));
				e.expr = EConst(CString(s, SingleQuotes));
			case _:
				e.iter(normalizeExpr);
		}
	}
}
