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
		visible = true;
		name = "Unit 27";
		team = 0;
		moveDistance = 2;
		
		anim = new AnimQueue();
		loadGraphic("assets/images/chib.png", true, 24, 32);
		animation.add("idle", [11, 11, 12, 12, 11, 11, 11, 11, 11, 11, 11, 11], 2);
		animation.add("init", [5, 6, 7, 8], 4, false);
		animation.add("open", [5, 4, 3, 2, 1, 0], 12, false);
		animation.add("close", [0, 1, 2, 3, 4, 5], 12, false);
		animation.add("alert", [9], 1, false);
		animation.add("question", [10], 1, false);
		offset.x = (width - Reg.TILESIZE) / 2;
		offset.y = 4;
		anim.add(animation.get("idle"));
	}
	
	public function open():Void {
		anim.add(animation.get("init"));
		anim.add(animation.get("open"));
		anim.add(animation.get("idle"), 10);
	}
	
	override public function update():Void {
		super.update();
		anim.update();
	}
}

class AnimQueue {
	
	private var queue:Array<AnimQueueElement>;
	
	public function new() {
		queue = [];
	}
	
	public function add(Anim:FlxAnimation, StartFrame:Int = 0):Void
	{
		queue.push(new AnimQueueElement(Anim, StartFrame));
		if (queue.length == 1) {
			Anim.parent.play(Anim.name, false, StartFrame);
			Anim.parent.update();
		}
	}
	
	public function update() {
		if (queue.length > 0) {
			var e:AnimQueueElement = queue[0];
			if (e.anim.finished || e.anim.looped)
				queue.shift();
			if (queue.length > 0) {
				e = queue[0];
				e.anim.parent.play(e.anim.name, false, e.startFrame);
			}
		}
	}
}

class AnimQueueElement {
	
	public var anim:FlxAnimation;
	public var startFrame:Int;
	
	public function new(Anim:FlxAnimation, StartFrame:Int) {
		anim = Anim;
		startFrame = StartFrame;
	}
}