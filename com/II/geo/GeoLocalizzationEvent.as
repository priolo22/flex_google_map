package com.II.geo 
{
	import com.II.components.googlemap.Location;
	import flash.events.Event;
	/**
	 * ...
	 * @author 
	 */
	public class GeoLocalizzationEvent extends Event {
	
		public static const EVENT_UPDATE:String = "event_geo_localizzation_update";
		
		public function get location():Location {
			return _location;
		}
		private var _location:Location = null;
		
		public function GeoLocalizzationEvent ( location:Location, type:String=EVENT_UPDATE, bubbles:Boolean = false, cancelable:Boolean = false ) {
			super(type, bubbles, cancelable);
			this._location = location;
		}
		
	}

}