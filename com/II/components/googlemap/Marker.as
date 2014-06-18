package com.II.components.googlemap 
{
	/**
	 * ...
	 * @author 
	 */
	public class Marker 
	{
		
		public function get location():Location {
			return _location;
		}
		public function set location(value:Location):void {
			if ( _parent != null ) {
				_parent.webView.loadURL("javascript:updateMarker('" + this.id + "'," + value.latitude+"," + value.longitude+")");
			}
			_location = value;
		}
		protected var _location:Location = null;
		
		
		public var id:String = null;
		
		public var title:String = null;
		
		public var subtitle:String = null;
		
		public var icon:String = "";
		
		
		/**
		 * provvede a settare la mappa che contiene questo marker 
		 * e a inserire il marker nella mappa javascript
		 */
		public function get parent():GoogleMap {
			return _parent;
		}
		public function set parent(value:GoogleMap):void {
			var url:String = null;
			if ( _parent == value ) return;
			if ( _parent != null ) {
				//_parent.markers.removeItem(this);
				url = "javascript:removeMarker('"+this.id+"')";
				_parent.webView.loadURL( url );
			}
			_parent = value;
			if ( _parent != null ) {
				url = "javascript:addMarker(" 
					+ this.location.latitude + "," + this.location.longitude
					+ ",'" + this.icon + "'"
					+ ",'" + this.title + "','" + this.subtitle + "','" + this.id + "'"
					+ ")";
				_parent.webView.loadURL( url );
			}
		}
		private var _parent:GoogleMap = null;
		
		
		/**
		 * indica se ci sono le info aperte o no per questo marker
		 */
		public function get isInfoInShow():Boolean {
			return LastInfoInShow == this;
		}
		public function set isInfoInShow(value:Boolean):void {
			if ( this.isInfoInShow == value ) return;
			if ( _parent.webView == null ) return;
			
			LastInfoInShow = value == true? this : null;
			
			var url:String = "javascript:showInfoWithId('"
				+ (value == true? this.id : "")
				+"')";
			_parent.webView.loadURL( url );
		}
		private static var LastInfoInShow:Marker = null;
		
		
		public function Marker(id:String, loc:Location, icon:String="", title:String=null, subtitle:String=null) {
			this.id = id;
			this.location = loc;
			this.icon = icon;
			this.title = title;
			this.subtitle = subtitle;
		}
		
		
		
		
		
	}

}