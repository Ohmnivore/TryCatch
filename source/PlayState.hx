package;

import ent.Entity;
import ent.EntityGroup;
import ent.Unit27;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.tile.FlxTilemap;
import hud.Canvas;
import hud.Grid;
import hud.HintText;
import hud.Selector;
import hud.Speech;
import hud.Status;
import scene.Intro;
import state.Browse;
import state.Context;
import util.TiledLoader;
import flixel.system.scaleModes.RatioScaleMode;
import scene.Scene;

class PlayState extends FlxState {
	
	public var tilemaps:FlxTypedGroup<FlxTilemap>;
	public var under:FlxGroup;
	public var entities:EntityGroup;
	public var hud:FlxGroup;
	
	public var canvas:Canvas;
	public var grid:Grid;
	public var selector:Selector;
	public var status:Status;
	public var speech:Speech;
	public var hint:HintText;
	
	public var scene:Scene;
	public var context:Context;
	
	override public function create():Void {
		super.create();
		Reg.state = this;
		
		FlxG.mouse.visible = false;
		FlxG.scaleMode = new RatioScaleMode();
		
		tilemaps = new FlxTypedGroup<FlxTilemap>();
		under = new FlxGroup();
		entities = new EntityGroup();
		hud = new FlxGroup();
		add(tilemaps);
		add(under);
		add(entities);
		add(hud);
		
		selector = new Selector();
		hud.add(selector);
		selector.setCameraFollow();
		
		status = new Status();
		hud.add(status);
		
		speech = new Speech();
		hud.add(speech);
		
		hint = new HintText();
		hud.add(hint);
		
		canvas = new Canvas();
		under.add(canvas);
		
		var tl:TiledLoader = new TiledLoader("assets/data/1.tmx");
		FlxG.camera.bgColor = tl.bgColor;
		for (tilemap in tl.tilemaps)
			tilemaps.add(tilemap);
		for (e in tl.entities)
			entities.add(e);
		
		// Set selector pos to protagonist
		var e:Entity = entities.getEntityByClass(Unit27);
		selector.x = e.x;
		selector.y = e.y;
		
		// Create the selection grid
		grid = new Grid(tilemaps.members[0].widthInTiles, tilemaps.members[0].heightInTiles);
		grid.collisionMap = tilemaps.members[0];
		tilemaps.add(grid);
		
		context = new Browse();
		// Load intro scene, if any
		if (tl.sceneName != null) {
			var skip:Bool = false;
			#if !FLX_NO_DEBUG
			skip = true;
			#end
			loadScene(tl.sceneName, skip);
		}
	}
	
	public function loadScene(Name:String, Skip:Bool = false):Void {
		var className:String = "scene." + Name;
		scene = cast Type.createInstance(Type.resolveClass(className), [this, Skip]);
	}
	
	override public function update():Void {
		super.update();
		context.update();
	}
}