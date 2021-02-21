package representer;

import formatter.Formatter;
import formatter.Formatter.FormatterInput;
import haxeparser.DefinitionConverter;
import haxe.macro.Printer;
import haxe.io.Path;
import byte.ByteData;
import sys.io.File;
import representer.normalizers.Normalizer;
import representer.normalizers.IdentifierNormalizer;

using Lambda;
using haxe.macro.ExprTools;

class Representer {
	public static function main() {
		represent("test", Path.directory(Sys.programPath()), "./");
	}

	public static function represent(slug:String, inputDir:String, outputDir:String) {
		function capitalize(str:String)
			return str.charAt(0).toUpperCase() + str.substr(1);

		var className = slug.split("-").map(capitalize).join("");
		var repDest = Path.join([outputDir, "representation.txt"]);
		var mapDest = Path.join([outputDir, "mapping.json"]);

		var codeSrc = Path.join([inputDir, '$className.hx']);

		// apply formatting to original source
		var origCode = File.getContent(codeSrc);
		origCode = formatCode(origCode);

		// convert src str to ast
		var parser = new HaxeParser(ByteData.ofString(origCode), Path.withoutDirectory(codeSrc));
		var data = parser.parse();

		// apply normalizations
		Normalizer.applyAll(data);
		var printer = new Printer();

		// convert ast back to src str
		var normCode = data.decls.map(d -> {
			var converted = DefinitionConverter.convertTypeDef(data.pack, d.decl);
			printer.printTypeDefinition(converted);
		}).join("\n");

		// apply formatting to normalized source
		normCode = formatCode(normCode);
		trace(normCode);
		// write representation
		// File.saveContent(repDest, formatted);

		// write mapping
		var mapping = haxe.Json.stringify(IdentifierNormalizer.idMap);
		// trace(mapping);
		// File.saveContent(mapDest, mapping);
	}

	public static function formatCode(code:String):String {
		var formatterInput = FormatterInput.Code(code);
		return switch (Formatter.format(formatterInput)) {
			case Success(formattedCode):
				formattedCode;
			case Failure(errorMessage):
				throw 'Error formatting code: $errorMessage';
			case Disabled:
				throw 'Error formatting code: disabled';
		}
	}
}
