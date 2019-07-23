package com.mvc.views.mediator.mainCity.summary
{
	import com.core.util.getcommon.Common;
	
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	
	/**
	 * 云词容器
	 *@author: Sun Fanglv
	 *Created at 6:22:34 PM Jul 17, 2019
	 **/
	public class WordCloudContainer extends Sprite
	{
		public function WordCloudContainer()
		{
			super();
			
			var bg:Quad = new Quad(300, 300, 0x000000);
			bg.alpha = alpha;
			this.addChild(bg);
		}
		
		public var MaxFontSize:int;
		public var MinFontSize:int;
		public var TextList:Array;
		public var Colors:Array;
		public var worldMap:WorldMap;
		public var Angles:Array = [0];
		
		private var _currentFontSize:int;
		
		private var _currentColor:uint;
		
		private var _helpTextField:TextField;
		
		private var m_stHelpRect:Rectangle = new Rectangle;  
		private var m_stHelpMatrix:Matrix = new Matrix;
		
		/**
		 *生成云词 
		 * @param labelArr 用来生成云词的文本数组
		 * @param colorArr 文本的颜色
		 * @param imgDataArr 形状图片数据
		 * 
		 */		
		public function create(labelArr:Array, colorArr:Array, imgDataArr:Array, imgWidth:int, imgHeight:int, maxFontSize:int, minFontSize:int):void
		{
			MaxFontSize = maxFontSize;
			MinFontSize = minFontSize;
			_helpTextField = Common.getText(0, 0, 100, 100, "", MaxFontSize, 0xffffff, null);
			_helpTextField.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			TextList = labelArr;
			Colors = colorArr;
			worldMap = new WorldMap();
			worldMap.CollisionMap = imgDataArr;
			worldMap.RealImageWidth = imgWidth;
			worldMap.RealImageHeight = imgHeight;
			worldMap.Width = imgWidth / WordCloudConst.XUNIT;
			worldMap.Height = imgHeight / WordCloudConst.YUNIT;
			startDraw();
		}
		
		private function startDraw():void
		{
			var currentFontSize:int = this.MaxFontSize;
			var currentTextIdx:int = 0;
			var colorIdx:int = 0;
			var checkRet:CheckResult = new CheckResult();
			
			var itemGrid:Grid = new Grid();
			var bigestSizeCnt:int = 0;
			UpdateFontSize(currentFontSize);
			
			while (true) {
				var msg:String = this.TextList[currentTextIdx];
				currentTextIdx++;
				currentTextIdx = currentTextIdx % this.TextList.length;
				
				var color:uint = this.Colors[colorIdx];
				_currentColor = color;
				colorIdx++;
				colorIdx = colorIdx % this.Colors.length;
				var xscale:int = 0;
				var yscale:int = 0;
				_helpTextField.text = msg;
				var w:int = _helpTextField.textBounds.width;
				var h:int = _helpTextField.textBounds.height;
				itemGrid.XScale = int(xscale)
				itemGrid.YScale = int(yscale)
				if (w % 2 != 0) 
				{
//					w += WordCloudConst.XUNIT + 35;
					w += 1;
				}
				if (h % 2 != 0)
				{
//					h += WordCloudConst.YUNIT + 35;
					h += 1;
				}
				var block:Object = Helper.TwoByBlock(w, h);
				var positions:Array = block.positions;
				var w1:int = block.maxX;
				var h1:int = block.maxY;
				itemGrid.Width = int(w1);
				itemGrid.Height = int(h1);
				itemGrid.positions = positions;
				var isFound:Boolean = this.collisionCheck(0, this.worldMap, itemGrid, checkRet, this.Angles);
				if (isFound) 
				{
					DrawText(msg, (checkRet.Xpos+itemGrid.XScale/2), (checkRet.Ypos+itemGrid.YScale/2), Helper.Angle2Pi((checkRet.Angle)))
					if (currentFontSize == this.MaxFontSize) 
					{
						bigestSizeCnt++;
						if (bigestSizeCnt > this.TextList.length) 
						{
							this.UpdateFontSize(MaxFontSize);
						}
					}
				} 
				else
				{
					currentFontSize -= 6;
					if (currentFontSize < this.MinFontSize)
					{
						break;
					}
					this.UpdateFontSize(currentFontSize);
				}
			}
		}
		
		private function UpdateFontSize(currentFontSize:int):void 
		{
			_currentFontSize = currentFontSize;
			_helpTextField.fontSize = _currentFontSize;
		}
		
		private function DrawText(text:String, xpos:int, ypos:int, rotation:int):void 
		{
			var textfield:TextField = Common.getText(xpos, ypos, 10, 10, "", _currentFontSize, _currentColor, this);
			textfield.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			textfield.text = text;
			textfield.x = int(xpos - (textfield.textBounds.width / 2));
			textfield.y = int(ypos - (textfield.textBounds.height / 2));
			trace("draw text", textfield.x, textfield.y, text, _currentFontSize, _currentColor);
		}
		
		private function collisionCheck(lastCheckAngle:int, worldMap:WorldMap, itemGrid:Grid, ret:CheckResult, tryAngles:Array):Boolean 
		{
			var centerX:int = worldMap.Width / 2;
			var centerY:int = worldMap.Height / 2;
			var isFound:Boolean= true;
			var xDistanceToCenter:int = 0;
			var yDistanceToCenter:int = 0;
			var tempXpos:int = 0;
			var tempYpos:int = 0;
							
			var angleMark:int = 0;
			var currentAngleIdx:int = 0;
			for (var angle:int = lastCheckAngle; angle <= WordCloudConst.DEGREE_360; angle += 8) {
				currentAngleIdx = 0;
				angleMark = tryAngles[currentAngleIdx];
				currentAngleIdx++;
				Helper.Rotate(itemGrid, angleMark, centerX, centerY);
				var xDiff:Number = Helper.CosT(angle) * 1;
				var yDiff:Number = Helper.SinT(angle) * 1;
				tempXpos = 0;
				tempYpos = 0;
				var xLeiji:Number = xDiff;
				var yLeiji:Number = yDiff;
				xDistanceToCenter = 0;
				yDistanceToCenter = 0;
				var result:int = WordCloudConst.IS_NOT_FIT;
				while (true) 
				{
					result = WordCloudConst.IS_NOT_FIT;
					if (xDistanceToCenter != tempXpos || yDistanceToCenter != tempYpos) 
					{
						tempXpos = xDistanceToCenter;
						tempYpos = yDistanceToCenter;
						result = itemGrid.IsFit(xDistanceToCenter, yDistanceToCenter, worldMap.Width, worldMap.Height, worldMap.CollisionMap);
						if (result == WordCloudConst.OUT_INDEX) 
						{
							if (currentAngleIdx < tryAngles.length) 
							{
								angleMark = tryAngles[currentAngleIdx];
								currentAngleIdx++;
								Helper.Rotate(itemGrid, angleMark, centerX, centerY);
								xLeiji = xDiff;
								yLeiji = yDiff;
								tempXpos = 0;
								tempYpos = 0;
								xDistanceToCenter = 0;
								yDistanceToCenter = 0;
							} 
							else 
							{
								ret.Angle = 0;
								isFound = false;
								break;
							}
						} 
						else if (result == WordCloudConst.IS_FIT) 
						{
							isFound = true;
							itemGrid.Fill(worldMap.Width, worldMap.Height, worldMap.CollisionMap);
							ret.Angle = angleMark;
							ret.Xpos = (xDistanceToCenter + centerX) * WordCloudConst.XUNIT;
							ret.Ypos = (yDistanceToCenter + centerY) * WordCloudConst.YUNIT;
							ret.LastCheckAngle = int(angle);
							break
						}
					}
					xLeiji += xDiff;
					yLeiji += yDiff;
					xDistanceToCenter = int(Helper.CeilT(xLeiji));
					yDistanceToCenter = int(Helper.CeilT(yLeiji));
				}
				if (angle >= WordCloudConst.DEGREE_360) 
				{
					ret.Angle = 0;
					isFound = false;
					break
				}
				
				if (result == WordCloudConst.IS_FIT) 
				{
					break
				}
			}
			return isFound;
		}
		
		/** 
		 * 获取对象Texture。 disp是拷贝对象，scale是缩放倍数  
		 */  
		public function copyToTexure(canves:RenderTexture=null,result:Texture=null):Texture  
		{ 
			m_stHelpRect = new Rectangle(0, 0, worldMap.RealImageWidth, worldMap.RealImageHeight);
			this.getBounds(this, m_stHelpRect);  
			m_stHelpMatrix.identity();  
			m_stHelpMatrix.translate(-m_stHelpRect.x, -m_stHelpRect.y);  
			m_stHelpMatrix.scale(scale,scale);  
			if(canves == null)  
			{  
				canves = new RenderTexture(m_stHelpRect.width*scale,m_stHelpRect.height*scale,false);  
				result = canves;  
			}  
			canves.draw(this,m_stHelpMatrix);  
			if(result == null)  
			{  
				m_stHelpRect.y = 0;  
				m_stHelpRect.x = 0;  
				result = Texture.fromTexture(canves,m_stHelpRect);  
			}  
			return result;  
		} 
		
		override public function dispose():void
		{
			super.dispose();
			if (worldMap && worldMap.CollisionMap)
			{
				worldMap.CollisionMap.length = 0;
				worldMap = null;
			}
		}
		
		
	}
}