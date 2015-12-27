package state;

/**
 * ...
 * @author Ohmnivore
 */
class Cinematic extends Context {

	public function new() {
		super();
		Reg.state.canvas.exists = false;
		Reg.state.grid.exists = false;
		Reg.state.hint.visible = false;
		Reg.state.selector.exists = false;
		Reg.state.status.exists = false;
		Reg.state.speech.exists = false;
	}
	
	override public function update():Void {
		super.update();
	}
}