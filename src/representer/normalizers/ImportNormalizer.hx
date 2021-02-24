package representer.normalizers;

/*
 * Normalize import statements by removing them
 */
class ImportNormalizer extends NormalizerBase {
	public function apply(data:ParseData) {
		var rm = [];
		for (d in data.decls) {
			switch (d.decl) {
				case EImport(_, _):
					rm.push(d);
				case _:
			}
		}
		for (d in rm)
			data.decls.remove(d);
	}
}
