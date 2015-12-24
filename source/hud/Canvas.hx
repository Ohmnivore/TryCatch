package hud;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Ohmnivore
 */
class Canvas extends FlxSprite {

	public function new() {
		super(0, 0);
		scrollFactor.set();
		makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
	}
	
	override public function update():Void {
		FlxSpriteUtil.fill(this, FlxColor.TRANSPARENT);
		super.update();
	}
	
	//override public function draw():Void 
	//{
		//super.draw();
		//FlxSpriteUtil.fill(this, FlxColor.TRANSPARENT);
	//}
	
	public function drawMoveLine(Path:Array<FlxPoint>):Void {
		for (i in 0...Path.length - 1) {
			var start:FlxPoint = Path[i];
			var end:FlxPoint = Path[i + 1];
			FlxSpriteUtil.drawLine(this, start.x - FlxG.camera.scroll.x, start.y - FlxG.camera.scroll.y, end.x - FlxG.camera.scroll.x, end.y - FlxG.camera.scroll.y,
				{ thickness:2, pixelHinting:true, color:0xCC00D427 }, { smoothing: false, } );
		}
	}
}