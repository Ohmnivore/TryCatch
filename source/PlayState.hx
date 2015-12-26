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
import util.TiledLoader;
import flixel.system.scaleModes.RatioScaleMode;

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
	public var context:Int;
	
	static public inline var C_CINEMATIC:Int = 0;
	static public inline var C_BROWSE:Int = 1;
	static public inline var C_MOVE:Int = 2;
	static public inline var C_ACTION:Int = 3;
	
	override public function create():Void {
		super.create();
		
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
		context = C_BROWSE;
		
		// Set selector pos to protagonist
		var e:Entity = entities.getEntityByClass(Unit27);
		selector.x = e.x;
		selector.y = e.y;
		
		// Load intro scene, if any
		if (tl.sceneName != null) {
			var skip:Bool = false;
			#if !FLX_NO_DEBUG
			skip = true;
			#end
			loadScene(tl.sceneName, skip);
		}
		
		// Create the selection grid
		grid = new Grid(tilemaps.members[0].widthInTiles, tilemaps.members[0].heightInTiles);
		grid.collisionMap = tilemaps.members[0];
		grid.canvas = canvas;
		tilemaps.add(grid);
	}
	
	public function loadScene(Name:String, Skip:Bool = false):Void {
		var className:String = "scene." + Name;
		Type.createInstance(Type.resolveClass(className), [this, Skip]);
	}
	
	override public function destroy():Void {
		super.destroy();
	}
	
	override public function update():Void {
		super.update();
		
		status.set(entities.getEntityAt(selector));
		
		if (context == C_BROWSE) {
			if (FlxG.keys.justPressed.Z) {
				startMove();
			}
		}
		else if (context == C_MOVE) {
			grid.showArrow(selector);
			hint.visible = false;
			
			if (grid.getTileAt(selector) == Grid.MOVE) {
				if (FlxG.keys.justPressed.Z && grid.path != null) {
					grid.cur.followPath(grid.path);
					stopMove();
				}
			}
			else if (grid.getTileAt(selector) == Grid.INTERACT) {
				var selected:Entity = entities.getEntityAt(selector);
				if (Grid.getEntDistance(grid.cur, selected) <= 1) {
					hint.visible = true;
					hint.setText(selected.hint);
					hint.setTile(selected.curTileX, selected.curTileY);
				}
			}
			
			if (FlxG.keys.justPressed.X) {
				selector.snapToEntity(grid.cur);
				stopMove();
			}
		}
	}
	
	private function startMove():Void {
		var e:Entity = entities.getEntityAt(selector);
		if (e != null && e.exists && !e.moving && e.team == 0) {
			grid.showMove(e, entities);
			context = C_MOVE;
		}
	}
	
	private function stopMove():Void {
		grid.clear();
		hint.visible = false;
		context = C_BROWSE;
	}
}