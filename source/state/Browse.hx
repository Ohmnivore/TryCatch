package state;
import flixel.FlxG;
import ent.Entity;

/**
 * ...
 * @author Ohmnivore
 */
class Browse extends Context {

	public function new() {
		super();
		Reg.state.canvas.exists = false;
		Reg.state.grid.exists = false;
		Reg.state.hint.exists = false;
	}
	
	override public function update():Void {
		super.update();
		
		if (FlxG.keys.justPressed.Z) {
			var e:Entity = Reg.state.entities.getEntityAt(Reg.state.selector);
			if (e == null) {
				// TODO: Menu
			}
			else if (readyForAction(e)) {
				Reg.state.grid.showActions(e, Reg.state.entities);
				Reg.state.context = new Action(e);
			}
		}
	}
}