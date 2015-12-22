package ent;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;

/**
 * ...
 * @author Ohmnivore
 */
class Selector extends FlxSprite {
	
	public var onMove:Int->Int->Void;
	public var onSelect:Int->Int->Void;
	
	public var tileSize:Int;
	public var rightKey:String = "RIGHT";
	public var leftKey:String = "LEFT";
	public var upKey:String = "UP";
	public var downKey:String = "DOWN";
	
	private var xBuffer:Int = 0;
	private var yBuffer:Int = 0;
	
	public function new(TileSize:Int, X:Float = 0, Y:Float = 0) {
		tileSize = TileSize;
		
		super(X, Y);
		loadGraphic("assets/images/selector.png", true, 38, 38);
		offset.set(4, 4);
		animation.add("opened", [0]);
		animation.add("closed", [1]);
		animation.add("alternating", [0, 1], 2);
		animation.play("alternating");
	}
	
	override public function update():Void {
		super.update();
		updatePosition();
	}
	
	private function updatePosition():Void {
		if (FlxG.keys.anyPressed([rightKey]))
			if (FlxG.keys.anyJustPressed([rightKey]))
				xBuffer += tileSize;
			else
				xBuffer += 4;
		else if (FlxG.keys.anyPressed([leftKey]))
			if (FlxG.keys.anyJustPressed([leftKey]))
				xBuffer -= 1;
			else
				xBuffer -= 4;
		else if (FlxG.keys.anyPressed([downKey]))
			if (FlxG.keys.anyJustPressed([downKey]))
				yBuffer += tileSize;
			else
				yBuffer += 4;
		else if (FlxG.keys.anyPressed([upKey]))
			if (FlxG.keys.anyJustPressed([upKey]))
				yBuffer -= 1;
			else
				yBuffer -= 4;
		
		if (!FlxG.keys.anyPressed([rightKey, leftKey]))
			xBuffer = Std.int(x);
		if (!FlxG.keys.anyPressed([upKey, downKey]))
			yBuffer = Std.int(y);
		
		x = Math.floor(xBuffer / tileSize) * tileSize;
		y = Math.floor(yBuffer / tileSize) * tileSize;
	}
	
	public function setCameraFollow():Void {
		FlxG.camera.follow(this, FlxCamera.STYLE_TOPDOWN, null, 10.0);
	}
}