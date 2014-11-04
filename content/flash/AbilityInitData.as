package  {
	import flash.display.Bitmap;
	
	public class AbilityInitData 
	{
	
		public var AbilityIcon:Bitmap;
		public var InternalName:String;
		
		public var BlockedBy:Array;
		public var PairedBy:Array;
		public var IndexSpecific:int;

		public function AbilityInitData(icon:Bitmap, abilityName:String, blockedByArray:Array, pairedBy:Array, index:int = -1) : void 
		{
			this.AbilityIcon = icon;
			this.InternalName = abilityName;
			this.BlockedBy = blockedByArray;
			this.PairedBy = pairedBy;
			this.IndexSpecific = index;
		}

	}
	
}
