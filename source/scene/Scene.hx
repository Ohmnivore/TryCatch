package scene;
import ent.Entity;
import flixel.util.FlxTimer;
import state.Browse;
import state.Cinematic;

/**
 * ...
 * @author Ohmnivore
 */
class Scene {
	
	static public inline var EVENT_INTERACT = 0;
	
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
	
	public function receive(Event:Int, Target:Entity):Void {
		
	}
}