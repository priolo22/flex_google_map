package com.II.components.googlemap 
{
	/**
	 * ...
	 * @author 
	 */
	public class Location 
	{
		
		public var latitude:Number = 0;
		public var longitude:Number = 0;
		
		public function Location( latitude:Number=0, longitude:Number=0 ) {
			this.latitude = latitude;
			this.longitude = longitude;
		}
		
		public function get forMapUrl ():String {
			return this.latitude+"," + this.longitude;
		}
		
		// SHARED OBJECT //
		
		public function get sharedObject():Object {
			var prop:Object = new Object();
			prop.latitude = this.latitude;
			prop.longitude = this.longitude;
			return prop;
		}
		
		public function set sharedObject(value:Object):void {
			this.latitude = value.latitude;
			this.longitude = value.longitude;
		}
		
		// SHARED OBJECT //
		
		
		private const RADIUS_OF_EARTH_IN_MILES:int = 3963;
		private const RADIUS_OF_EARTH_IN_FEET:int =20925525;
		private const RADIUS_OF_EARTH_IN_KM:int =6378;
		private const RADIUS_OF_EARTH_IN_M:int =6378000;
		 
		public function distance( loc:Location, units:String="km"):Number{
		 
			var R:int = RADIUS_OF_EARTH_IN_MILES;
			if (units == "km"){
				R = RADIUS_OF_EARTH_IN_KM;
			}
			if (units == "meters"){
				R = RADIUS_OF_EARTH_IN_M;
			}
			if (units =="feet"){
				R= RADIUS_OF_EARTH_IN_FEET;
			}
		 
			var dLat:Number = (loc.latitude-this.latitude) * Math.PI/180;
			var dLon:Number = (loc.longitude-this.longitude) * Math.PI/180;
		 
			var lat1inRadians:Number = this.latitude * Math.PI/180;
			var lat2inRadians:Number = loc.latitude * Math.PI/180;
		 
			var a:Number = Math.sin(dLat/2) * Math.sin(dLat/2) + 
						   Math.sin(dLon/2) * Math.sin(dLon/2) * 
						   Math.cos(lat1inRadians) * Math.cos(lat2inRadians);
			var c:Number = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
			var d:Number = R * c;
		 
			return d;
		}
		
		
		public function clone():Location {
			var c:Location = new Location();
			c.sharedObject = this.sharedObject;
			return c;
		}
		
		public function equals ( l:Location ) : Boolean {
			if ( l == null ) return false;
			if ( l.latitude == this.latitude && l.longitude == this.longitude ) return true;
			return false;
		}
		
		public function set ( l:Location ) : void {
			this.sharedObject = l.sharedObject;
		}
		
	}

}