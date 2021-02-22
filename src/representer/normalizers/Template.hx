package representer.normalizers;

/*
 * An empty stub to adapt for creating new normalizers
 */
class Template extends NormalizerBase {
	public function apply(data:ParseData) {
		for (d in data.decls) {
			switch (d.decl) {
				case EImport(sl, mode):
					normalizeImport(sl, mode);
				case EClass(d):
					normalizeClass(d);
				case EEnum(d):
					normalizeEnum(d);
				case ETypedef(d):
					normalizeTypedef(d);
				case EAbstract(d):
					normalizeAbstract(d);
				case EStatic(d):
					normalizeStatic(d);
				case EUsing(tpath):
					normalizeUsing(tpath);
			}
		}
	}

	function normalizeImport(sl:Array<{pack:String, pos:Position}>, mode:ImportMode) {}

	function normalizeClass(d:Definition<ClassFlag, Array<Field>>) {
		for (field in d.data) {
			switch (field.kind) {
				case FVar(t, e):
				case FFun(f):
				case FProp(get, set, t, e):
			}
		}
	}

	function normalizeEnum(d:Definition<EnumFlag, Array<EnumConstructor>>) {}

	function normalizeTypedef(d:Definition<EnumFlag, ComplexType>) {
		normalizeComplextType(d.data);
	}

	function normalizeComplextType(ctyp:ComplexType) {
		switch (ctyp) {
			case TPath(p):
			case TFunction(args, ret):
			case TAnonymous(fields):
			case TParent(t):
			case TExtend(p, fields):
			case TOptional(t):
			case TNamed(n, t):
			case TIntersection(tl):
		}
	}

	function normalizeAbstract(d:Definition<AbstractFlag, Array<Field>>) {
		for (field in d.data) {
			switch (field.kind) {
				case FVar(t, e):
				case FFun(f):
				case FProp(get, set, t, e):
			}
		}
	}

	function normalizeStatic(d:Definition<StaticFlag, FieldType>) {
		switch (d.data) {
			case FVar(t, e):
			case FFun(f):
			case FProp(get, set, t, e):
		}
	}

	function normalizeUsing(tpath:TypePath) {}
}
