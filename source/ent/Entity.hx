package ent;
import flixel.FlxSprite;

/**
 * ...
 * @author Ohmnivore
 */
class Entity extends FlxSprite {
	
	public var name:String;
	
	public function new(X:Float, Y:Float) {
		super(X, Y);
		name = "---";
	}
}