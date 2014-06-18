package com.II 
{
	import com.adobe.images.JPGEncoder;
	import com.ssd.ane.AndroidExtensions;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	import flash.filesystem.FileMode;
	
	/**
	 * ...
	 * @author 
	 */
	public class Utils {
		
		// VISUALIZZA UN BREVE MESSAGGIO A SCHERMO //
		static public function Alert ( msg:String ) : void {
			try {
				AndroidExtensions.toast ( msg );
			} catch ( e:Error ) {
				trace ( "AndroidExtensions:: " + msg );
			}
		}
		
		
		// RESTITUISCE TRUE SE L'EMAIL è PRESUMIBILMENTE GIUTA O NO.
		static public function IsValidEmail(email:String):Boolean {
			var emailExpression:RegExp = /([a-z0-9._-]+?)@([a-z0-9.-]+)\.([a-z]{2,4})/;
			return emailExpression.test(email);
		}
		
		
		// RASTERIZZA UN OGGETTO E RESTITUISCE I DATI IN FORMATO JPG
		static public function RasterizeDisplayObject ( dobj:DisplayObject, scale:Number=1 ) : ByteArray {
			
			var clipRect:Rectangle = new Rectangle ( 0, 0, dobj.width*scale, dobj.height*scale );
			
			var AuxBData:BitmapData = new BitmapData ( clipRect.width, clipRect.height, true, 0 );
			var matrix:Matrix = new Matrix();
			matrix.scale ( scale, scale );
			AuxBData.draw(dobj, matrix, null, null, clipRect, true);
			
			var bd:BitmapData = new BitmapData ( clipRect.width, clipRect.height, true, 00000000 );
			bd.copyPixels(AuxBData, clipRect, new Point(0, 0));
			
			var result:Bitmap = new Bitmap(bd, PixelSnapping.NEVER, true);
			
			var encoder:JPGEncoder = new JPGEncoder(75);
			return encoder.encode(result.bitmapData);
		}
		
		
		
		// SALVA IN UN FILE (NELLA DIRECTORY DELL'APP) DEI DATI
		static public function SaveDataFile ( data:ByteArray, nameFile:String ) : File {
			
			var targetFile:File = File.documentsDirectory.resolvePath(nameFile);
			
			var fs:FileStream = new FileStream();
			fs.open(targetFile, FileMode.WRITE);
			fs.writeBytes(data);
			fs.close();
			
			return targetFile;
		}
		
		
		
		// CARICA UN DATO DA REMPTO (PER ESEMPIO UN IMMAGINE)
		static private var CallbackFileLoaded:Function = null;
		static public function LoadDataFile ( url:String, callback:Function ) : void {
			var stream:URLStream = new URLStream();
			CallbackFileLoaded = callback;
			stream.addEventListener( Event.COMPLETE, CompleteLoadFile );
			stream.load( new URLRequest(url) );
		}
		static private function CompleteLoadFile( e:Event ):void {
			var stream:URLStream = e.target as URLStream;
			var data:ByteArray = new ByteArray();
			stream.readBytes( data );
			stream.close();
			
			var tmp:Function = CallbackFileLoaded;
			CallbackFileLoaded = null;
			tmp ( data );
		}
		
	}

}