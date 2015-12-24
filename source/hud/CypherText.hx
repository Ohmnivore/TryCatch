package hud;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxRandom;

/**
 * ...
 * @author Ohmnivore
 */
class CypherText extends FlxText {
	
	public var realText:String;
	private var cur:Float;
	private var random:Array<String> = ["!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "-", "_", "=", "+", "~", "\"", "|", "/", "\\", ",", ".", "{", "}", "[", "]", ":", ";",
		"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"];
	
	public function new(X:Float, Y:Float, FieldWidth:Float = 0, ?Text:String, Size:Int = 8, EmbeddedFont:Bool = true) {
		super(X, Y, FieldWidth, Text, Size, EmbeddedFont);
		showText(text);
	}
	
	public function showText(Text:String, OnEnd:Void->Void = null):Void {
		cur = 0;
		realText = Text;
		FlxTween.tween(this, { "cur":Text.length }, 0.01 * (Text.length - 1), { type:FlxTween.ONESHOT, ease:FlxEase.sineInOut } );
	}
	
	override public function update():Void {
		super.update();
		
		var buffer:String = "";
		var i:Int = 0;
		while (i <= cur)
			buffer += realText.charAt(i++);
		//while (i < realText.length * 0.5) {
			//buffer += FlxRandom.getObject(random);
			//i++;
		//}
		text = buffer;
	}
	
	
}