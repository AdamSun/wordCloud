package 
{
	/**
	 *
	 *@author: Sun
	 *Created at 9:03:47 PM Jul 17, 2019
	 **/
	public class Position
	{
		public function Position(xpos:int, ypos:int, value:int, xleiji:int, yleiji:int)
		{
			Xpos = xpos;
			Ypos = ypos;
			Value = value;
			XLeiji = xleiji;
			YLeiji = yleiji;
		}
		
		public var Xpos:int;
		public var Ypos:int;
		public var Value:int;
		public var XLeiji:int;
		public var YLeiji:int;
	}
}
