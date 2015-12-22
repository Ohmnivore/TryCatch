package util;
import haxe.xml.Fast;
import openfl.Assets;
import flixel.tile.FlxTilemap;

/**
 * ...
 * @author Ohmnivore
 */
class TiledLoader {
	
	public var bgColor:Int = 0;
	public var tilemaps:Array<FlxTilemap> = [];
	
	public function new(Path:String) {
		var root:Fast = new Fast(Xml.parse(Assets.getText(Path)));
		var map:Fast = root.node.map;
		bgColor = convertColor(map.att.backgroundcolor);
		
		for (child in map.elements) {
			if (child.name == "layer" && child.hasNode.data)
				handleLayer(child);
		}
	}
	
	private function handleLayer(F:Fast):Void {
		var width:Int = Std.parseInt(F.att.width);
		var height:Int = Std.parseInt(F.att.height);
		
		var tilemap:FlxTilemap = new FlxTilemap();
		tilemap.widthInTiles = width;
		tilemap.heightInTiles = height;
		tilemap.loadMap(CSVToArray(F.node.data.innerData, 1), "assets/images/sciFiIndoorTileset.png", 32, 32);
		tilemaps.push(tilemap);
		trace(tilemap);
	}
	
	private function CSVToArray(Data:String, GID:Int):Array<Int> {
		var ret:Array<Int> = [];
		for (i in Data.split(","))
			ret.push(Std.parseInt(i) - GID);
		return ret;
	}
	
	private function convertColor(Original:String):Int {
		return Std.parseInt("0x" + Original.substr(1)) + 0xFF000000;
	}
}