package hud;
import ent.Entity;
import ent.EntityGroup;
import flixel.FlxCamera;
import flixel.tile.FlxTilemap;
import flixel.tile.FlxTilemapBuffer;
import flixel.util.FlxPoint;
import openfl.display.BitmapData;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.tile.FlxTile;

/**
 * ...
 * @author Ohmnivore
 */
class Grid extends FlxTilemap {
	
	static public inline var EMPTY:Int = 0;
	static public inline var MOVE:Int = 1;
	static public inline var ATTACK:Int = 2;
	static public inline var INTERACT:Int = 3;
	
	public var collisionMap:FlxTilemap;
	public var path:Array<FlxPoint>;
	
	public function new(WidthInTiles:Int, HeightInTiles:Int) {
		super();
		widthInTiles = WidthInTiles;
		heightInTiles = HeightInTiles;
		loadMap(getZeroArray(widthInTiles * heightInTiles),
			"assets/images/highlight.png", Reg.TILESIZE, Reg.TILESIZE);
		
		alpha = 0.77;
		FlxTween.tween(this, { "alpha":0.5 }, 2, { type:FlxTween.PINGPONG, ease:FlxEase.quadInOut } );
	}
	
	private function getZeroArray(Size:Int):Array<Int> {
		var ret:Array<Int> = [];
		for (i in 0...Size)
			ret.push(0);
		return ret;
	}
	
	public function clear():Void {
		for (i in 0...heightInTiles)
			for (j in 0...widthInTiles)
				setTile(j, i, EMPTY);
	}
	
	public function showActions(E:Entity, Ents:EntityGroup):Void {
		var tx:Int = Std.int(E.x / _tileWidth);
		var ty:Int = Std.int(E.y / _tileHeight);
		for (i in 0...heightInTiles)
			for (j in 0...widthInTiles)
				if (getDistance(tx, ty, j, i) <= E.moveDistance)
					if (pathIsOk(
						E.getTileMidpoint(),
						new FlxPoint(j * Reg.TILESIZE + Reg.HALFTILESIZE, i * Reg.TILESIZE + Reg.HALFTILESIZE)
						)) {
							// Move tile
							setTile(j, i, MOVE);
							// Interact tile
							for (e in Ents.members)
								if (e.interact)
									if (getDistance(e.curTileX, e.curTileY, j, i) <= 1)
										setTile(e.curTileX, e.curTileY, INTERACT);
						}
	}
	private function pathIsOk(Start:FlxPoint, End:FlxPoint):Bool {
		return collisionMap.findPath(Start, End, true, false, true) != null;
	}
	
	static public function getDistance(X1:Int, Y1:Int, X2:Int, Y2:Int):Float {
		return Math.sqrt(Math.pow(X1 - X2, 2) + Math.pow(Y1 - Y2, 2));
	}
	static public function getEntDistance(E1:Entity, E2:Entity):Float {
		return getDistance(E1.curTileX, E1.curTileY, E2.curTileX, E2.curTileY);
	}
	public function getTileAt(E:Entity):Int {
		return getTile(E.curTileX, E.curTileY);
	}
	
	public function storePath(From:Entity, To:Entity):Void {
		if (getTile(To.curTileX, To.curTileY) == MOVE) {
			path = collisionMap.findPath(From.getTileMidpoint(), To.getTileMidpoint(),
				true, false, true);
		}
		else
			path = null;
	}
	
	private var b:BitmapData;
	private var alpha(default, set):Float;
	private var _alpha:Float;
	private function get_alpha():Float {
		return _alpha;
	}
	private function set_alpha(Alpha:Float):Float {
		_alpha = Alpha;
		b = new BitmapData(_tileWidth, _tileHeight, true, Std.int(_alpha * 255) << 24);
		return _alpha;
	}
	/**
	 * Internal function that actually renders the tilemap to the tilemap buffer. Called by draw().
	 * 
	 * @param	Buffer		The FlxTilemapBuffer you are rendering to.
	 * @param	Camera		The related FlxCamera, mainly for scroll values.
	 */
	override private function drawTilemap(Buffer:FlxTilemapBuffer, Camera:FlxCamera):Void
	{
	#if FLX_RENDER_BLIT
		Buffer.fill();
	#else
		_helperPoint.x = x - Camera.scroll.x * scrollFactor.x; //copied from getScreenXY()
		_helperPoint.y = y - Camera.scroll.y * scrollFactor.y;
		
		var tileID:Int;
		var drawX:Float;
		var drawY:Float;
		
		var hackScaleX:Float = tileScaleHack * scale.x;
		var hackScaleY:Float = tileScaleHack * scale.y;
		
		var drawItem:DrawStackItem = Camera.getDrawStackItem(cachedGraphics, false, 0);
		var currDrawData:Array<Float> = drawItem.drawData;
		var currIndex:Int = drawItem.position;
	#end
		
		// Copy tile images into the tile buffer
		_point.x = (Camera.scroll.x * scrollFactor.x) - x; //modified from getScreenXY()
		_point.y = (Camera.scroll.y * scrollFactor.y) - y;
		
		var screenXInTiles:Int = Math.floor(_point.x / _scaledTileWidth);
		var screenYInTiles:Int = Math.floor(_point.y / _scaledTileHeight);
		var screenRows:Int = Buffer.rows;
		var screenColumns:Int = Buffer.columns;
		
		// Bound the upper left corner
		if (screenXInTiles < 0)
		{
			screenXInTiles = 0;
		}
		if (screenXInTiles > widthInTiles - screenColumns)
		{
			screenXInTiles = widthInTiles - screenColumns;
		}
		if (screenYInTiles < 0)
		{
			screenYInTiles = 0;
		}
		if (screenYInTiles > heightInTiles - screenRows)
		{
			screenYInTiles = heightInTiles - screenRows;
		}
		
		var rowIndex:Int = screenYInTiles * widthInTiles + screenXInTiles;
		_flashPoint.y = 0;
		var row:Int = 0;
		var column:Int;
		var columnIndex:Int;
		var tile:FlxTile;
		
		#if !FLX_NO_DEBUG
		var debugTile:BitmapData;
		#end 
		
		while (row < screenRows)
		{
			columnIndex = rowIndex;
			column = 0;
			_flashPoint.x = 0;
			
			while (column < screenColumns)
			{
				#if FLX_RENDER_BLIT
				_flashRect = _rects[columnIndex];
				
				if (_flashRect != null)
				{
					Buffer.pixels.copyPixels(cachedGraphics.bitmap, _flashRect, _flashPoint, b, null, true);
					
					#if !FLX_NO_DEBUG
					if (FlxG.debugger.drawDebug && !ignoreDrawDebug) 
					{
						tile = _tileObjects[_data[columnIndex]];
						
						if (tile != null)
						{
							if (tile.allowCollisions <= FlxObject.NONE)
							{
								// Blue
								debugTile = _debugTileNotSolid; 
							}
							else if (tile.allowCollisions != FlxObject.ANY)
							{
								// Pink
								debugTile = _debugTilePartial; 
							}
							else
							{
								// Green
								debugTile = _debugTileSolid; 
							}
							
							Buffer.pixels.copyPixels(debugTile, _debugRect, _flashPoint, null, null, true);
						}
					}
					#end
				}
				#else
				tileID = _rectIDs[columnIndex];
				
				if (tileID != -1)
				{
					drawX = _helperPoint.x + (columnIndex % widthInTiles) * _scaledTileWidth;
					drawY = _helperPoint.y + Math.floor(columnIndex / widthInTiles) * _scaledTileHeight;
					
					currDrawData[currIndex++] = pixelPerfectRender ? Math.floor(drawX) : drawX;
					currDrawData[currIndex++] = pixelPerfectRender ? Math.floor(drawY) : drawY;
					currDrawData[currIndex++] = tileID;
					
					// Tilemap tearing hack
					currDrawData[currIndex++] = hackScaleX; 
					currDrawData[currIndex++] = 0;
					currDrawData[currIndex++] = 0;
					// Tilemap tearing hack
					currDrawData[currIndex++] = hackScaleY; 
					
					// Alpha
					currDrawData[currIndex++] = 1.0; 
				}
				#end
				
				#if FLX_RENDER_BLIT
				_flashPoint.x += _tileWidth;
				#end
				column++;
				columnIndex++;
			}
			
			#if FLX_RENDER_BLIT
			_flashPoint.y += _tileHeight;
			#end
			rowIndex += widthInTiles;
			row++;
		}
		
		#if FLX_RENDER_TILE
		drawItem.position = currIndex;
		#end
		
		Buffer.x = screenXInTiles * _scaledTileWidth;
		Buffer.y = screenYInTiles * _scaledTileHeight;
	}
}