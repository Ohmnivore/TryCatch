package hud;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;

/**
 * ...
 * @author Ohmnivore
 */
class HintText extends FlxSpriteGroup {
	
	public var bg:FlxSprite;
	public var text:FlxText;
	
	public function new(X:Float = 0, Y:Float = 0) {
		super(X, Y);
		bg = new FlxSprite();
		add(bg);
		text = new FlxText();
		add(text);
		text.color = Style.TEXT_COLOR;
		visible = false;
	}
	
	public function setText(Text:String):Void {
		if (text.text != Text) {
			text.text = Text;
			text.drawFrame();
			bg.makeGraphic(Std.int(text.frameWidth) + Style.MARGIN * 2,
				Std.int(text.frameHeight) + Style.MARGIN * 2, Style.BG_COLOR, true);
		}
	}
	
	public function setTile(TileX:Float, TileY:Float):Void {
		x = TileX * Reg.TILESIZE + Reg.HALFTILESIZE - bg.width / 2;
		y = TileY * Reg.TILESIZE + Reg.HALFTILESIZE - bg.height;
	}
	
	override public function update():Void {
		super.update();
		bg.setPosition(x, y);
		text.setPosition(x + Style.MARGIN, y + Style.MARGIN);
	}
}