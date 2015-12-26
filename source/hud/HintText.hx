package hud;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;

/**
 * ...
 * @author Ohmnivore
 */
class HintText extends FlxSpriteGroup {
	
	static private inline var MARGIN:Int = 4;
	static private inline var BG_COLOR:Int = 0xff000000;
	static private inline var TEXT_COLOR:Int = 0xff00D427;
	
	public var bg:FlxSprite;
	public var text:FlxText;
	
	public function new(X:Float = 0, Y:Float = 0) {
		super(X, Y);
		bg = new FlxSprite();
		add(bg);
		text = new FlxText();
		add(text);
		text.color = TEXT_COLOR;
		visible = false;
	}
	
	public function setText(Text:String):Void {
		if (text.text != Text) {
			text.text = Text;
			text.drawFrame();
			bg.makeGraphic(Std.int(text.frameWidth) + MARGIN * 2, Std.int(text.frameHeight) + MARGIN * 2, BG_COLOR, true);
		}
	}
	
	override public function update():Void {
		super.update();
		bg.setPosition(x, y);
		text.setPosition(x + MARGIN, y+ MARGIN);
	}
}