package hud;
import ent.Entity;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxPoint;

/**
 * ...
 * @author Ohmnivore
 */
class Selector extends FlxSprite {
	
	public var rightKey:String = "RIGHT";
	public var leftKey:String = "LEFT";
	public var upKey:String = "UP";
	public var downKey:String = "DOWN";
	
	private var xBuffer:Int = 0;
	private var yBuffer:Int = 0;
	private var oldX:Float = 0;
	private var oldY:Float = 0;
	
	public var curTileX:Int;
	public var curTileY:Int;
	
	public function new(X:Float = 0, Y:Float = 0) {
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
				xBuffer += Reg.TILESIZE;
			else
				xBuffer += 4;
		else if (FlxG.keys.anyPressed([leftKey]))
			if (FlxG.keys.anyJustPressed([leftKey]))
				xBuffer -= 1;
			else
				xBuffer -= 4;
		else if (FlxG.keys.anyPressed([downKey]))
			if (FlxG.keys.anyJustPressed([downKey]))
				yBuffer += Reg.TILESIZE;
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
		
		x = Math.floor(xBuffer / Reg.TILESIZE) * Reg.TILESIZE;
		y = Math.floor(yBuffer / Reg.TILESIZE) * Reg.TILESIZE;
		
		if (oldX != x || oldY != y) {
			curTileX = Math.floor(x / Reg.TILESIZE);
			curTileY = Math.floor(y / Reg.TILESIZE);
		}
		
		oldX = x;
		oldY = y;
	}
	
	public function getTileCoords():FlxPoint {
		return new FlxPoint(curTileX * Reg.TILESIZE, curTileY * Reg.TILESIZE);
	}
	public function getTileMidpoint():FlxPoint {
		return new FlxPoint(curTileX * Reg.TILESIZE + Reg.HALFTILESIZE, curTileY * Reg.TILESIZE + Reg.HALFTILESIZE);
	}
	
	public function setCameraFollow():Void {
		FlxG.camera.follow(this, FlxCamera.STYLE_TOPDOWN, null, 10.0);
	}
	
	public function snapToEntity(E:Entity):Void {
		var newPos:FlxPoint = E.getTileCoords();
		setPosition(newPos.x, newPos.y);
	}
}