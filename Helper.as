package 
{
	/**
	 *
	 *@author: Sun
	 *Created at 9:18:07 PM Jul 17, 2019
	 **/
	public class Helper
	{
		public function Helper()
		{
		}
		
		public static function TwoByBlock(width:int, height:int):Object 
		{
			var positions:Array = [];
			var maxX:int = width / WordCloudConst.XUNIT;
			var maxY:int = height / WordCloudConst.YUNIT;
			//maxX += 2
			//maxY += 2
			
			for (var y:int = 0; y < maxY; y++) {
				for (var x:int = 0; x < maxX; x++) {
					var position:Position = new Position(x, y, WordCloudConst.IS_NOT_FIT, 0, 0);
					positions.push(position);
				}
			}
			return {positions:positions, maxX:maxX, maxY:maxY};
		}
		
		public static function Rotate(grid:Grid, angle:Number, centerX:int, centerY:int):void
		{
			var maxX:int = grid.Width;
			var maxY:int = grid.Height;
			var width:int = maxX * WordCloudConst.XUNIT;
			var height:int = maxY * WordCloudConst.YUNIT;
			var halfX:int = width / 2;
			var halfY:int = height / 2;
			var tempX:int = 0;
			var tempY:int = 0;
			var gridData:Array = grid.positions;
//			var sinPi:Number = SinT(angle);
//			var cosPi:Number = CosT(angle)
			for (var y:int= 0; y < maxY; y++) {
				for (var x:int = 0; x < maxX; x++) {
					var index:int = y*maxX + x;
					var position:Position = gridData[index];
					position.Xpos = x;
					position.Ypos = y;
					position.Xpos = position.Xpos*WordCloudConst.XUNIT - halfX;
					position.Ypos = position.Ypos*WordCloudConst.YUNIT - halfY;
//					tempX = position.Xpos;
//					tempY = position.Ypos;
//					position.Xpos = int(tempX * cosPi - tempY *sinPi);
//					position.Ypos = int(tempX * sinPi + tempY *cosPi);
					position.Xpos /= WordCloudConst.XUNIT;
					position.Ypos /= WordCloudConst.YUNIT;
					
					position.Xpos += centerX;
					position.Ypos += centerY;
					
					position.XLeiji = position.Xpos;
					position.YLeiji = position.Ypos;
				}
			}
		}
		
		public static function CeilT(value:Number):Number {
			return Math.ceil(value);
		}
		
		public static function CosT(angle:Number):Number {
			angle = angle / WordCloudConst.DEGREE_180 * Math.PI
			return Math.cos(angle)
		}
		
		public static function SinT(angle:Number):Number {
			angle = angle / WordCloudConst.DEGREE_180 * Math.PI
			return Math.sin(angle)
		}
		
		public static function Angle2Pi(angle:Number):Number {
			return angle / WordCloudConst.DEGREE_180 * Math.PI
		}
	}
}
