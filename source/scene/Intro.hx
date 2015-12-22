package scene;
import ent.Unit27;
import flixel.FlxG;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Ohmnivore
 */
class Intro {
	
	public var state:PlayState;
	public var p:Unit27;
	
	public function new(P:PlayState) {
		state = P;
		p = cast state.entities.getEntityByName("Unit 27");
		
		state.selector.active = false;
		state.selector.visible = false;
		
		FlxG.camera.focusOn(p.getMidpoint());
		
		new FlxTimer(5, onCue);
	}
	
	private function onCue(T:FlxTimer):Void {
		state.selector.active = true;
		state.selector.visible = true;
		
		p.anim.add(p.animation.get("close"));
		p.anim.add(p.animation.get("alert"));
		//p.anim.add(p.animation.get("open"));
		//p.anim.add(p.animation.get("idle"));
	}
}