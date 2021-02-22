package representer;

import haxe.io.Path;
import sys.io.File;
import representer.normalizers.Normalizer;
import representer.normalizers.Identifiers;

class Representer {
	public static function main() {
		var args = Sys.args();
		var slug = args[0];
		var inputDir = args[1];
		var outputDir = args[2];
		represent(slug, inputDir, outputDir);
	}

	static function represent(slug:String, inputDir:String, outputDir:String) {
		function capitalize(str:String)
			return str.charAt(0).toUpperCase() + str.substr(1);

		var className = slug.split("-").map(capitalize).join("");
		var repDest = Path.join([outputDir, "representation.txt"]);
		var mapDest = Path.join([outputDir, "mapping.json"]);
		var codeSrc = Path.join([inputDir, '$className.hx']);

		// apply code formatting
		var origCode = File.getContent(codeSrc);
		origCode = formatCode(origCode);

		// convert src to ast
		var parser = new HaxeParser(byte.ByteData.ofString(origCode), Path.withoutDirectory(codeSrc));
		var data = parser.parse();

		// apply normalizations
		Normalizer.applyAll(data);

		// convert ast back to str
		var printer = new haxe.macro.Printer();
		var representation = data.decls.map(d -> {
			var converted = haxeparser.DefinitionConverter.convertTypeDef(data.pack, d.decl);
			printer.printTypeDefinition(converted);
		}).join("\n");

		// write representation
		representation = formatCode(representation);
		File.saveContent(repDest, representation);

		// write mapping
		var mapping = haxe.Json.stringify(Identifiers.idMap, "\t");
		File.saveContent(mapDest, mapping);
	}

	static function formatCode(code:String):String {
		var input = formatter.Formatter.FormatterInput.Code(code);
		return switch (formatter.Formatter.format(input)) {
			case Success(formatted):
				formatted;
			case Failure(msg):
				throw 'Error formatting code: $msg';
			case Disabled:
				throw 'Error formatting code: disabled';
		}
	}
}
