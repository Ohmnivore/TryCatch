package state;
import ent.Entity;

/**
 * ...
 * @author Ohmnivore
 */
class Context {
	
	public function new() {
		Reg.state.canvas.exists = true;
		Reg.state.grid.exists = true;
		Reg.state.hint.visible = false;
		Reg.state.selector.exists = true;
		Reg.state.status.exists = true;
		Reg.state.speech.exists = false;
	}
	
	public function update():Void {
		Reg.state.status.set(Reg.state.entities.getEntityAt(Reg.state.selector));
	}
	
	private function readyForAction(E:Entity):Bool {
		return (E != null && E.exists && !E.moving && E.team == 0);
	}
	
	private function sendScene(Event:Int, Target:Entity):Void {
		if (Reg.state.scene != null)
			Reg.state.scene.receive(Event, Target);
	}
}