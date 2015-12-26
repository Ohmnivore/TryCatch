package hud;

import ent.Entity;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxGroup;

/**
 * ...
 * @author Ohmnivore
 */
class Status extends FlxGroup {
	
	static public inline var DEFAULT_NAME:String = "---";
	static private inline var BG_COLOR:Int = 0xff000000;
	static private inline var TEXT_COLOR:Int = 0xff00D427;
	static private inline var MARGIN:Int = 4;
	
	private var bg:FlxSprite;
	private var name:FlxText;
	
	public function new() {
		super();
		
		bg = new FlxSprite(MARGIN, MARGIN);
		add(bg);
		bg.scrollFactor.set();
		
		name = new FlxText(MARGIN * 2, MARGIN * 2);
		add(name);
		name.text = DEFAULT_NAME;
		name.color = TEXT_COLOR;
		name.scrollFactor.set();
		
		updateBg();
	}
	
	public function set(E:Entity):Void {
		var newText:String = DEFAULT_NAME;
		if (E != null && E.exists)
			newText = E.name;
		if (name.text != newText) {
			name.text = newText;
			updateBg();
		}
	}
	
	private function updateBg():Void {
		name.drawFrame();
		bg.makeGraphic(MARGIN * 2 + Std.int(name.frameWidth), MARGIN * 2 + Std.int(name.frameHeight), BG_COLOR, true);
	}
}