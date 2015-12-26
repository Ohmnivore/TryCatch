package state;

/**
 * ...
 * @author Ohmnivore
 */
class Cinematic extends Context {

	public function new() {
		super();
		Reg.state.selector.exists = false;
		Reg.state.status.exists = false;
	}
	
	override public function update():Void {
		super.update();
	}
}