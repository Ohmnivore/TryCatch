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
	
	private var bg:FlxSprite;
	private var name:FlxText;
	
	public function new() {
		super();
		
		bg = new FlxSprite(Style.MARGIN, Style.MARGIN);
		add(bg);
		bg.scrollFactor.set();
		
		name = new FlxText(Style.MARGIN * 2, Style.MARGIN * 2);
		add(name);
		name.text = DEFAULT_NAME;
		name.color = Style.TEXT_COLOR;
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
		bg.makeGraphic(Style.MARGIN * 2 + Std.int(name.frameWidth),
			Style.MARGIN * 2 + Std.int(name.frameHeight), Style.BG_COLOR, true);
	}
}