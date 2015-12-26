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
	
	public function getEntityAt(E:Entity):Entity {
		for (m in members)
			if (m.curTileX == E.curTileX && m.curTileY == E.curTileY)
				return m;
		return null;
	}
	
	public function getEntityByName(Name:String):Entity {
		for (m in members)
			if (m.name == Name)
				return m;
		return null;
	}
	
	public function getEntityByClass(C:Class<Entity>):Entity {
		for (m in members)
			if (Type.getClass(m) == C)
				return m;
		return null;
	}
}