package;

import ent.Entity;
import ent.EntityGroup;
import ent.Unit27;
import flixel.FlxG;
import flixel.FlxState;
import hud.Selector;
import hud.Status;
import scene.Intro;
import util.TiledLoader;

class PlayState extends FlxState {
	
	public var entities:EntityGroup;
	public var selector:Selector;
	public var status:Status;
	
	override public function create():Void {
		super.create();
		
		FlxG.mouse.visible = false;
		
		var tl:TiledLoader = new TiledLoader("assets/data/1.tmx");
		FlxG.camera.bgColor = tl.bgColor;
		for (tilemap in tl.tilemaps)
			add(tilemap);
		
		entities = new EntityGroup();
		add(entities);
		
		var unit:Unit27 = new Unit27(160 + 32, 160 + 96);
		entities.add(unit);
		unit.open();
		
		selector = new Selector(32);
		add(selector);
		selector.onMove = onSelectorMove;
		selector.setCameraFollow();
		selector.x = unit.x;
		selector.y = unit.y;
		
		status = new Status();
		add(status);
		
		new Intro(this);
	}
	
	private function onSelectorMove(X:Float, Y:Float):Void {
		status.set(entities.getEntity(X, Y));
	}
	
	override public function destroy():Void {
		super.destroy();
	}
	
	override public function update():Void {
		super.update();
	}
}