package representer.normalizers;

/*
 * Normalize using statements by removing them
 */
class Usings extends NormalizerBase {
	public function apply(data:ParseData) {
		var rm = [];
		for (d in data.decls) {
			switch (d.decl) {
				case EUsing(_):
					rm.push(d);
				case _:
			}
		}
		for (d in rm)
			data.decls.remove(d);
	}
}
