package representer.normalizers;

typedef NormFlags = {
	classF:Array<ClassFlag>,
	staticF:Array<StaticFlag>,
	accessF:Array<Access>
}

/*
 * Normalize flags by removing them
 */
class Flags extends NormalizerBase {
	var flags:NormFlags;

	public function new(flags:NormFlags) {
		super();
		this.flags = flags;
	}

	public function apply(data:ParseData) {
		for (d in data.decls) {
			switch (d.decl) {
				case EClass(d):
					normalizeClass(d);
				case EStatic(s):
					normalizeStatic(s);
				case _:
			}
		}
	}

	function normalizeClass(c:Definition<ClassFlag, Array<Field>>) {
		flags.classF.iter(cf -> c.flags.remove(cf));
		flags.accessF.iter(af -> c.data.iter(field -> field.access.remove(af)));
	}

	function normalizeStatic(s:Definition<StaticFlag, FieldType>) {
		flags.staticF.iter(sf -> s.flags.remove(sf));
	}
}
