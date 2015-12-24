package hud;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Ohmnivore
 */
class Speech extends FlxGroup {
	
	static private inline var HEIGHT:Int = 42;
	static private inline var MARGIN:Int = 4;
	static private inline var BG_COLOR:Int = 0xff000000;
	static private inline var TEXT_COLOR:Int = 0xff00D427;
	
	public var bg:FlxSprite;
	public var text:CypherText;
	
	private var msg:Array<String> = [];
	private var curMsg:Int = 0;
	private var onEnd:FlxTimer->Void;
	private var timer:FlxTimer;
	
	public function new() {
		super();
		
		bg = new FlxSprite(0, FlxG.height - HEIGHT);
		add(bg);
		bg.makeGraphic(FlxG.width, HEIGHT, BG_COLOR, true);
		bg.scrollFactor.set();
		
		text = new CypherText(MARGIN, bg.y + MARGIN, bg.width - MARGIN * 2, "");
		add(text);
		text.scrollFactor.set();
		text.color = TEXT_COLOR;
		timer = new FlxTimer(0.5, null, 0);
		
		exists = false;
	}
	
	public function show(Msg:Array<String>, OnEnd:FlxTimer->Void):Void {
		msg = Msg;
		curMsg = 0;
		onEnd = OnEnd;
		showMsg();
	}
	
	private function showMsg():Void {
		if (curMsg >= msg.length) {
			exists = false;
			if (onEnd != null)
				onEnd(null);
		}
		else
			text.showText(msg[curMsg++]);
	}
	
	override public function update():Void {
		super.update();
		
		if (timer.elapsedLoops % 2 == 0)
			text.text += "_";
		else
			text.text += " ";
		
		if (FlxG.keys.justPressed.Z)
			showMsg();
	}
}