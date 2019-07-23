package 
{
	/**
	 *
	 *@author: Sun
	 *Created at 9:06:46 PM Jul 17, 2019
	 **/
	public class Grid
	{
		public function Grid()
		{
		}
		
		public var Width:int;
		public var Height:int;
		public var positions:Array;
		public var XScale:int;
		public var YScale:int;
		
		public function IsFit(xIncrement:int, yIncrement:int, width:int, height:int, gridIntArray:Array):int 
		{
			for (var i:int = 0; i < this.Height; i++) 
			{
				for (var j:int = 0; j < this.Width; j++) 
				{
					var index:int = i*this.Width + j;
					var position:Position = this.positions[index];
					if (position.Value != WordCloudConst.IS_EMPTY)
					{
						position.Xpos = position.XLeiji + xIncrement;
						position.Ypos = position.YLeiji + yIncrement;
						if (position.Xpos < 0 || position.Ypos < 0 || position.Xpos >= width || position.Ypos >= height) 
						{
							return WordCloudConst.OUT_INDEX;
						}
						index = position.Ypos*width + position.Xpos
						if (position.Value != 0 && gridIntArray[index] == position.Value)
						{
							return WordCloudConst.IS_NOT_FIT;
						}
					}
				}
			}
			return WordCloudConst.IS_FIT;
		}
		
		public function SetCollisionMap(collisionMap:Array, width:int, height:int):void
		{
			this.Width = width;
			this.Height = height;
			var index:int = 0;
			for (var y:int = 0; y < height; y++) 
			{
				for (var x:int = 0; x < width; x++) 
				{
					var value:int = collisionMap[index];
					var position:Position = new Position(x, y, value, 0, 0);
					this.positions.push(position);
					index++;
				}
			}
		}
		
		public function Fill(gridIntArrayWidth:int, gridIntArrayHeight:int, gridIntArray:Array):void
		{
			for (var y:int = 0; y < this.Height; y++) 
			{
				for (var x:int = 0; x < this.Width; x++) 
				{
					var index:int = y*this.Width + x;
					var position:Position = this.positions[index];
					index = position.Ypos*gridIntArrayWidth + position.Xpos;
					if (position.Value != WordCloudConst.IS_EMPTY) 
					{
						gridIntArray[index] = position.Value;
					}
				}
			}
		}
	}
}
