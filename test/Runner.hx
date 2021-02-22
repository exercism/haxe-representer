package test;

import sys.io.Process;
import haxe.io.Path;
import sys.io.File;
import haxe.Json;
import sys.FileSystem as FS;

using buddy.Should;
using StringTools;
using Lambda;

class Runner extends buddy.SingleSuite {
	var tmpDirs = [];

	public function new() {
		var scriptDir = Path.directory(Sys.programPath());
		var representerBin = Path.join([scriptDir, "..", "bin", "representer.n"]);

		function filterDirs(path)
			return FS.readDirectory(path).map(x -> Path.join([path, x])).filter(FS.isDirectory);

		for (testDir in filterDirs(scriptDir)) {
			var expectMap = Json.parse(File.getContent('$testDir/mapping.json'));
			var expectRep = File.getContent('$testDir/representation.txt');
			var tmpDir = '$testDir/tmp';
			tmpDirs.push(tmpDir);
			FS.createDirectory(tmpDir);

			var proc = new Process("neko", [representerBin, "sut", testDir, tmpDir]);
			if (proc.exitCode() != 0)
				trace(proc.stderr.readAll().toString());

			var testName = Path.withoutDirectory(testDir);
			describe(testName, {
				it("representation should match expected", {
					var outRep = File.getContent('$tmpDir/representation.txt');
					outRep.should.be(expectRep);
				});
				it("mapping should match expected", {
					var outMap = Json.parse(File.getContent('$tmpDir/mapping.json'));
					// convert back to str for comparison
					Json.stringify(outMap).should.be(Json.stringify(expectMap));
				});
			});

			afterAll({
				for (dir in tmpDirs)
					deleteDirRecursively(dir);
			});
		}
	}

	static function deleteDirRecursively(path:String) {
		if (FS.exists(path) && FS.isDirectory(path)) {
			var entries = FS.readDirectory(path);
			for (entry in entries) {
				if (FS.isDirectory('$path/$entry')) {
					deleteDirRecursively('$path/$entry');
					FS.deleteDirectory('$path/$entry');
				} else
					FS.deleteFile('$path/$entry');
			}
			// delete root dir
			FS.deleteDirectory(path);
		}
	}
}
