package util;
import flixel.FlxObject;
import haxe.xml.Fast;
import openfl.Assets;
import flixel.tile.FlxTilemap;
import ent.Entity;

/**
 * ...
 * @author Ohmnivore
 */
class TiledLoader {
	
	public var bgColor:Int = 0;
	public var tilemaps:Array<FlxTilemap> = [];
	public var entities:Array<Entity> = [];
	public var sceneName:String;
	
	public function new(Path:String) {
		var root:Fast = new Fast(Xml.parse(Assets.getText(Path)));
		var map:Fast = root.node.map;
		bgColor = convertColor(map.att.backgroundcolor);
		sceneName = getProperty(map, "scene");
		
		for (child in map.elements) {
			if (child.name == "layer" && child.hasNode.data)
				handleTileLayer(child);
			if (child.name == "objectgroup")
				handleObjLayer(child);
		}
	}
	
	private function handleObjLayer(F:Fast):Void {
		for (obj in F.nodes.object) {
			var className:String = "ent." + obj.att.name;
			var realX:Int = Std.parseInt(obj.att.x);
			var realY:Int = Std.parseInt(obj.att.y);
			var x:Int = realX - realX % Reg.TILESIZE;
			var y:Int = realY - realY % Reg.TILESIZE;
			
			var ent:Entity = Type.createInstance(Type.resolveClass(className), [x, y]);
			entities.push(ent);
			
			if (obj.hasNode.properties)
				for (prop in obj.node.properties.nodes.property)
					Reflect.setProperty(ent, prop.att.name, prop.att.value);
		}
	}
	
	private function handleTileLayer(F:Fast):Void {
		var width:Int = Std.parseInt(F.att.width);
		var height:Int = Std.parseInt(F.att.height);
		
		var tilemap:FlxTilemap = new FlxTilemap();
		tilemap.widthInTiles = width;
		tilemap.heightInTiles = height;
		tilemap.loadMap(CSVToArray(F.node.data.innerData, 1),
			"assets/images/sciFiIndoorTileset.png", Reg.TILESIZE, Reg.TILESIZE, 0, 0, 0, 1);
		setCollision(tilemap);
		tilemaps.push(tilemap);
	}
	
	private function setCollision(T:FlxTilemap):Void {
		for (t in 0...84)
			T.setTileProperties(t, FlxObject.NONE);
		var collidable:Array<Int> = [0, 1, 3, 14, 15, 16, 17, 28, 29, 30, 31, 42, 43, 44, 45, 56, 57, 58, 59, 70, 71, 73, 83];
		for (c in collidable)
			T.setTileProperties(c, FlxObject.ANY);
	}
	
	private function CSVToArray(Data:String, GID:Int):Array<Int> {
		var ret:Array<Int> = [];
		for (i in Data.split(",")) {
			var index:Int = Std.parseInt(i);
			if (index <= 0)
				index = 84;
			ret.push(index - GID);
		}
		return ret;
	}
	
	private function convertColor(Original:String):Int {
		return Std.parseInt("0x" + Original.substr(1)) + 0xFF000000;
	}
	
	private function getProperty(D:Fast, Name:String):String {
		if (D.hasNode.properties)
			for (prop in D.node.properties.elements)
				if (prop.att.name == Name)
					return prop.att.value;
		return null;
	}
}