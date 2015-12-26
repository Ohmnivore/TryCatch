package scene;
import ent.Station;
import ent.Unit27;
import flixel.FlxG;
import flixel.util.FlxTimer;
import state.Browse;
import state.Cinematic;

/**
 * ...
 * @author Ohmnivore
 */
class Intro extends Scene {
	
	public var p:Unit27;
	public var station:Station;
	
	public function new(P:PlayState, Skip:Bool = false) {
		super(P, Skip);
		p = cast state.entities.getEntityByClass(Unit27);
		start();
	}
	
	override private function start():Void {
		super.start();
		
		if (!skip) {
			new FlxTimer(5, onCue);
			p.open();
		}
		
		state.selector.snapToEntity(p);
		FlxG.camera.focusOn(p.getMidpoint());
		
		station = cast state.entities.getEntityByClass(Station);
		station.exists = false;
	}
	
	private function onCue(T:FlxTimer = null):Void {
		p.anim.add(p.animation.get("close"));
		p.anim.add(p.animation.get("alert"));
		
		state.speech.show([
			"You're my new remote operator, right?",
			"You see, I wasn't dropped in the right sector.",
			"Hold on, get me to that terminal over there, then we can talk. The big box with the big screen."
			//"You're my new remote operator, right? I'm K, short for Unit 27, knock-off Data Inc. maintenance bot geared for sabotage. I'm somewhat of a big deal around these parts, you could say.",
			//"Now uh, they kind of dropped me off in the wrong sector. We'll need to take the express to get to the core of the facility.",
			//"You see that mainframe over there? Big box with the big screen. Get me over there so we can call an express shuttle."
			], end);
	}
	
	override private function end(T:FlxTimer = null):Void {
		super.end(T);
		
		p.anim.add(p.animation.get("open"));
		p.anim.add(p.animation.get("idle"));
	}
}