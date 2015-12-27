package scene;
import ent.Entity;
import ent.Station;
import ent.Terminal;
import ent.Unit27;
import flixel.FlxG;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Ohmnivore
 */
class Intro extends Scene {
	
	public var p:Unit27;
	public var terminal:Terminal;
	public var station:Station;
	
	public function new(P:PlayState, Skip:Bool = false) {
		super(P, Skip);
		p = cast state.entities.getEntityByClass(Unit27);
		terminal = cast state.entities.getEntityByClass(Terminal);
		station = cast state.entities.getEntityByClass(Station);
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
		
		station.exists = false;
	}
	
	private function onCue(T:FlxTimer = null):Void {
		p.anim.add(p.animation.get("close"));
		p.anim.add(p.animation.get("alert"));
		
		state.speech.show([
			"You're my new remote operator, right?",
			"You see, I wasn't dropped in the right sector.",
			"Hold on, get me to that terminal over there, then we can talk. The big box with the big screen."
			], end);
	}
	
	override private function end(T:FlxTimer = null):Void {
		super.end(T);
		
		p.anim.add(p.animation.get("open"));
		p.anim.add(p.animation.get("idle"));
	}
	
	override public function receive(Event:Int, Target:Entity):Void {
		super.receive(Event, Target);
		
		if (Event == Scene.EVENT_INTERACT && Target == terminal) {
			terminal.interact = false;
			station.exists = true;
			
			if (!skip) {
				super.start();
				state.speech.show([
					"Oh, wonderful! You figured out what to do all by yourself.",
					"This is promising, very promising.",
					"Now we need to go that train stop to the right of the room.",
					"I'll stop bossing you around in a short while, I promise."
					], end2);
			}
		}
		else if (Event == Scene.EVENT_INTERACT && Target == station) {
			super.start();
			FlxG.camera.fade(0xff000000, 3);
		}
	}
	
	private function end2(T:FlxTimer = null):Void {
		super.end();
	}
}