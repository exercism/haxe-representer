package representer.normalizers;

abstract class NormalizerBase {
	public function new() {}

	public abstract function apply(data:ParseData):Void;
}
