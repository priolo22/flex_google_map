package com.II.components.googlemap 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author 
	 */
	public class MapLocationEvent extends Event {
		
		static public const MAP_CLICK:String = "mapClick";
		static public const GEOCODING_ADDRESS:String = "geocodingAddress";
		
		public var location:Location = null;
		
		public function MapLocationEvent (location:Location, type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			this.location = location;
		}
		
	}

}