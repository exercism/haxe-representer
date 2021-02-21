package representer.normalizers;

/*
	Normalize import statements by removing them
 */
class DebugNormalizer extends NormalizerBase {
	public function apply(data:ParseData) {
		for (d in data.decls) {
			switch (d.decl) {
				case EImport(sl, mode):
					trace("import");
				case EClass(d):
					trace("class");
				case EEnum(d):
					trace("enum");
				case ETypedef(d):
					trace("typedef");
				case EAbstract(a):
					trace("abstract");
				case EStatic(s):
					trace("static");
				case EUsing(path):
					trace("using");
			}
		}
	}
}
