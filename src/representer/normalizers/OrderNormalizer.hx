package representer.normalizers;

typedef Defs = Array<TypeDef>;

/*
 * Normalize TypeDecls by re-ordering
 * This normalization removes decl.Pos data
 */
class OrderNormalizer extends NormalizerBase {
	public function apply(data:ParseData) {
		var enums = [];
		var typedefs = [];
		var statics = [];
		var classes = [];
		var abstracts = [];
		for (dec in data.decls) {
			var decl = dec.decl;
			switch (decl) {
				case EEnum(d):
					enums.push(d);
				case ETypedef(d):
					typedefs.push(d);
				case EStatic(d):
					statics.push(d);
				case EClass(d):
					classes.push(d);
				case EAbstract(d):
					abstracts.push(d);
				case _:
			}
		}
		// normalize and remap from Defintion to TypeDef
		var normalizedTypeDefs = [
			orderEnum(enums).map(d -> EEnum(d)),
			orderTypeDef(typedefs).map(d -> ETypedef(d)),
			orderStatic(statics).map(d -> EStatic(d)),
			orderClass(classes).map(d -> EClass(d)),
			orderAbstract(abstracts).map(d -> EAbstract(d))
		].flatten();

		// convert to TypeDecl, ignoring Pos data
		data.decls = normalizedTypeDefs.map(d -> {decl: d, pos: null});
	}

	function sortDefAlphaAsc<T, U>(a:Definition<T, U>, b:Definition<T, U>):Int
		return Reflect.compare(a.name, b.name);

	function orderEnum(defs:Array<Definition<EnumFlag, Array<EnumConstructor>>>) {
		// sort enums
		defs.sort(sortDefAlphaAsc);
		// sort enum constructors
		defs.iter(d -> d.data.sort((a, b) -> Reflect.compare(a.name, b.name)));
		return defs;
	}

	function orderTypeDef(defs:Array<Definition<EnumFlag, ComplexType>>) {
		// sort typedefs
		defs.sort(sortDefAlphaAsc);
		defs.iter(d -> {
			switch (d.data) {
				// sort anonymoust structures
				case TAnonymous(fields):
					fields.sort((a, b) -> Reflect.compare(a.name, b.name));
				// TODO: sort other types
				case _:
			}
		});
		return defs;
	}

	function orderStatic(defs:Array<Definition<StaticFlag, FieldType>>) {
		defs.sort(sortDefAlphaAsc);
		return defs;
	}

	function orderClass(defs:Array<Definition<ClassFlag, Array<Field>>>) {
		defs.sort(sortDefAlphaAsc);
		return defs;
	}

	function orderAbstract(defs:Array<Definition<AbstractFlag, Array<Field>>>) {
		defs.sort(sortDefAlphaAsc);
		return defs;
	}
}
