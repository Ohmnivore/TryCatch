package ent;
import flixel.group.FlxTypedGroup;
import hud.Selector;

/**
 * ...
 * @author Ohmnivore
 */
class EntityGroup extends FlxTypedGroup<Entity> {

	public function new() {
		super();
	}
	
	public function getSelectedEntity(S:Selector):Entity {
		for (m in members)
			if (m.curTileX == S.curTileX && m.curTileY == S.curTileY)
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