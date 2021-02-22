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
	// dirs where representer output is written to, cleaned at end of suite run
	var tmpDirs = [];

	static var scriptDir = Path.directory(Sys.programPath());

	public function new() {
		var representerBin = Path.join([scriptDir, "..", "bin", "representer.n"]);

		for (testDir in collectTestDirs(scriptDir)) {
			var tmpDir = '$testDir/tmp';
			FS.createDirectory(tmpDir);
			tmpDirs.push(tmpDir);

			// run representer
			var proc = new Process("neko", [representerBin, "sut", testDir, tmpDir]);

			// for debugging
			var stdout = proc.stdout.readAll().toString();
			if (stdout.length > 0)
				trace(stdout);
			var stderr = proc.stderr.readAll().toString();
			if (stderr.length > 0)
				trace(stderr);

			// e.g. path/to/test/identifiers/class -> identifiers/class
			var testName = testDir.substring(testDir.indexOf("/test/") + 6);

			describe(testName, {
				it("representation should match expected", {
					var expectRep = File.getContent('$testDir/representation.txt');
					var outRep = File.getContent('$tmpDir/representation.txt');
					outRep.should.be(expectRep);
				});
				it("mapping should match expected", {
					var expectMap = Json.parse(File.getContent('$testDir/mapping.json'));
					var outMap = Json.parse(File.getContent('$tmpDir/mapping.json'));
					// convert back to str for comparison
					Json.stringify(outMap).should.be(Json.stringify(expectMap));
				});
			});

			// clean up
			afterAll({
				for (dir in tmpDirs)
					deleteDirRecursively(dir);
			});
		}
	}

	// Traverse scriptDir recursively and return a list of all dirs containing a test,
	// this allows arbitrary nesting
	static function collectTestDirs(path:String):Array<String> {
		function filterDirs(p)
			return FS.readDirectory(p).map(x -> Path.join([p, x])).filter(FS.isDirectory);

		var testDirs = [];

		if (FS.exists('$path/Sut.hx'))
			return [path];

		for (dir in filterDirs(path)) {
			if (FS.exists('$dir/Sut.hx'))
				testDirs.push(dir);
			else
				testDirs = testDirs.concat(filterDirs(dir).flatMap(collectTestDirs));
		}
		return testDirs;
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
