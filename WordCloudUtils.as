package 
{
	import flash.display.BitmapData;
	import flash.display.PNGEncoderOptions;
	import flash.display3D.Context3D;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;

	/**
	 * 
	 *@author: Sun
	 *Created at 5:10:40 PM Jul 23, 2019
	 **/
	public class WordCloudUtils
	{
		public function WordCloudUtils()
		{
		}
		
		/** http://forum.starling-framework.org/topic/taking-a-screenshot-and-save-it-to-the-camera-roll
		 */
		public static function copyAsBitmapData(displayObject:starling.display.DisplayObject, transparentBackground:Boolean = true, backgroundColor:uint = 0xcccccc):BitmapData
		{
			if (displayObject == null || isNaN(displayObject.width)|| isNaN(displayObject.height))
				return null;
			var resultRect:Rectangle = new Rectangle();
			displayObject.getBounds(displayObject, resultRect);
			
			var result:BitmapData = new BitmapData(displayObject.width, displayObject.height, transparentBackground, backgroundColor);
			var context:Context3D = Starling.context;
			var support:RenderSupport = new RenderSupport();
			RenderSupport.clear();
			support.setOrthographicProjection(0,0, Starling.current.stage.stageWidth, Starling.current.stage.stageHeight);
			support.applyBlendMode(true);
			support.translateMatrix( -resultRect.x, -resultRect.y);
			support.pushMatrix();
			//support.pushBlendMode();
			support.blendMode = displayObject.blendMode;
			displayObject.render(support, 1.0);
			support.popMatrix();
			//support.popBlendMode();
			support.finishQuadBatch();
			context.drawToBitmapData(result);
			return result;
		}
		
		public static function savePng(bitmapData:BitmapData, fileName:String):void
		{
			var targetBytes:ByteArray = bitmapData.encode(new Rectangle(0,0,bitmapData.width,bitmapData.height), new PNGEncoderOptions());
			var applicationDirectoryPath:File = File.applicationDirectory;
			var nativePathToApplicationDirectory:String = applicationDirectoryPath.nativePath.toString();
			nativePathToApplicationDirectory += "/" + fileName + ".png";
			var targetFile:File = new File(nativePathToApplicationDirectory);
			var targetStream:FileStream = new FileStream();
			targetStream.open(targetFile, FileMode.WRITE);
			targetStream.writeBytes(targetBytes);
			targetStream.close();
		}
	}
}
