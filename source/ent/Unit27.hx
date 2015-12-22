package ent;
import ent.Unit27.AnimQueue;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxAnimation;

/**
 * ...
 * @author Ohmnivore
 */
class Unit27 extends Entity {
	
	public var anim:AnimQueue;
	
	public function new(X:Float, Y:Float) {
		super(X, Y);
		name = "Unit 27";
		
		anim = new AnimQueue();
		loadGraphic("assets/images/chib.png", true, 24, 32);
		animation.add("idle", [11, 11, 11, 11, 11, 12, 12], 2);
		animation.add("init", [5, 6, 7, 8], 4, false);
		animation.add("open", [5, 4, 3, 2, 1, 0], 12, false);
		animation.add("close", [0, 1, 2, 3, 4, 5], 12, false);
		animation.add("alert", [9], 1, false);
		animation.add("question", [10], 1, false);
		offset.x = (width - 32.0) / 2.0;
		offset.y = 4.0;
		animation.play("close", true, 5);
	}
	
	public function open():Void {
		anim.add(animation.get("init"));
		anim.add(animation.get("open"));
		anim.add(animation.get("idle"));
	}
	
	override public function update():Void {
		super.update();
		anim.update();
	}
}

class AnimQueue {
	
	private var queue:Array<FlxAnimation>;
	
	public function new() {
		queue = [];
	}
	
	public function add(Anim:FlxAnimation):Void
	{
		queue.push(Anim);
		if (queue.length == 1) {
			Anim.parent.play(Anim.name);
			Anim.parent.update();
		}
	}
	
	public function update() {
		if (queue.length > 0) {
			if (queue[0].finished || queue[0].looped) {
				trace("done: " + queue[0].name);
				queue.shift();
			}
			if (queue.length > 0)
				queue[0].parent.play(queue[0].name);
		}
	}
}