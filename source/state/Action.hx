package state;
import hud.Grid;
import ent.Entity;
import flixel.FlxG;
import scene.Scene;

/**
 * ...
 * @author Ohmnivore
 */
class Action extends Context {
	
	public var e:Entity;
	
	public function new(E:Entity) {
		super();
		e = E;
	}
	
	override public function update():Void {
		super.update();
		
		Reg.state.grid.storePath(e, Reg.state.selector);
		if (Reg.state.grid.path != null)
			Reg.state.canvas.drawMoveLine(Reg.state.grid.path);
		Reg.state.hint.visible = false;
		
		if (Reg.state.grid.getTileAt(Reg.state.selector) == Grid.MOVE) {
			if (FlxG.keys.justPressed.Z && Reg.state.grid.path != null) {
				e.followPath(Reg.state.grid.path);
				stopMove();
			}
		}
		else if (Reg.state.grid.getTileAt(Reg.state.selector) == Grid.INTERACT) {
			var selected:Entity = Reg.state.entities.getEntityAt(Reg.state.selector);
			if (Grid.getEntDistance(e, selected) <= 1) {
				Reg.state.hint.visible = true;
				Reg.state.hint.setText(selected.hint);
				Reg.state.hint.setTile(selected.curTileX, selected.curTileY);
				
				if (FlxG.keys.justPressed.Z) {
					sendScene(Scene.EVENT_INTERACT, selected);
					Reg.state.selector.snapToEntity(e);
					Reg.state.grid.showActions(e, Reg.state.entities);
				}
			}
		}
		
		if (FlxG.keys.justPressed.X) {
			Reg.state.selector.snapToEntity(e);
			stopMove();
		}
	}
	
	private function stopMove():Void {
		Reg.state.canvas.clear();
		Reg.state.grid.clear();
		Reg.state.context = new Browse();
	}
}