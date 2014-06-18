package com.II.components.googlemap 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author 
	 */
	public class MarkerEvent extends Event {
		
		static public const CLICK_INFO:String = "markerClickInfo";
		static public const CLICK_MARKER:String = "markerClick";
		
		public var marker:Marker = null;
		
		public function MarkerEvent (m:Marker, type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			this.marker = m;
		}
		
	}

}