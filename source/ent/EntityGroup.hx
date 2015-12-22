package ent;
import flixel.group.FlxTypedGroup;

/**
 * ...
 * @author Ohmnivore
 */
class EntityGroup extends FlxTypedGroup<Entity> {

	public function new() {
		super();
	}
	
	public function getEntity(X:Float, Y:Float):Entity {
		for (m in members)
			if (m.x == X && m.y == Y)
				return m;
		return null;
	}
	
	public function getEntityByName(Name:String):Entity {
		for (m in members)
			if (m.name == Name)
				return m;
		return null;
	}
}