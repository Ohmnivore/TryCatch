package ent;
import flixel.FlxSprite;
import flixel.util.FlxPath;
import flixel.util.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

/**
 * ...
 * @author Ohmnivore
 */
class Entity extends FlxSprite {
	
	public var name:String;
	public var team:Int;
	public var moveDistance:Int;
	public var moveSpeed:Int;
	
	public var path:FlxPath;
	public var moving:Bool;
	public var interact:Bool;
	public var hint:String;
	
	public var curTileX:Int;
	public var curTileY:Int;
	
	public function new(X:Float, Y:Float) {
		super(X, Y);
		name = "---";
		team = -1;
		moveDistance = 0;
		moveSpeed = 160;
		
		moving = false;
		interact = false;
		
		visible = false;
	}
	
	override public function update():Void 
	{
		super.update();
		curTileX = Math.floor(x / Reg.TILESIZE);
		curTileY = Math.floor(y / Reg.TILESIZE);
		
		if (path != null && path.finished)
			moving = false;
	}
	
	
	public function getTileCoords():FlxPoint {
		return new FlxPoint(curTileX * Reg.TILESIZE, curTileY * Reg.TILESIZE);
	}
	public function getTileMidpoint():FlxPoint {
		return new FlxPoint(curTileX * Reg.TILESIZE + Reg.HALFTILESIZE, curTileY * Reg.TILESIZE + Reg.HALFTILESIZE);
	}
	
	public function followPath(Path:Array<FlxPoint>):Void {
		for (point in Path)
			point.set(point.x - Reg.HALFTILESIZE, point.y - Reg.HALFTILESIZE);
		path = new FlxPath(this, Path, moveSpeed / 5);
		path.autoCenter = false;
		FlxTween.tween(path, { "speed":moveSpeed }, 0.3, { type:FlxTween.ONESHOT, ease:FlxEase.cubeIn } );
		moving = true;
	}
}