package scene;
import flixel.util.FlxTimer;
import state.Browse;
import state.Cinematic;

/**
 * ...
 * @author Ohmnivore
 */
class Scene {
	
	public var state:PlayState;
	public var skip:Bool;
	
	public function new(P:PlayState, Skip:Bool = false) {
		state = P;
		skip = Skip;
	}
	
	private function start():Void {
		if (!skip)
			state.context = new Cinematic();
	}
	
	private function end(T:FlxTimer = null):Void {
		state.context = new Browse();
	}
}