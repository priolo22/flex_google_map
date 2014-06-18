flex_google_map
===============
Typical usage:


<s:View xmlns:fx="http://ns.adobe.com/mxml/2009" xmlns:s="library://ns.adobe.com/flex/spark"
	xmlns:c="com.II.components.googlemap.*"
	>


	<fx:Script>
		<![CDATA[
		
		import com.II.components.googlemap.Location;
		import com.II.components.googlemap.MapLocationEvent;
		import com.II.components.googlemap.Marker;
		import flash.events.Event;
		import flash.events.MouseEvent;


		
		private var marker:Marker = null;

		
		
		public function onMapReady ( e:Event ) : void {
		
			// set position of map
			this.map.center = new Location(44,11);
			this.map.zoom = 13;
			
			// create marker
			this.marker = new Marker("my_marker", this.map.center);
			this.map.markers.addItem ( marker );
			
			this.item.location = this.marker.location;
			this.map.center = this.marker.location;
			
			this.map.addEventListener ( MapLocationEvent.GEOCODING_ADDRESS, function(e:MapLocationEvent):void {
				marker.location = e.location;
				map.center = e.location;
			});
			
			this.map.addEventListener ( MapLocationEvent.MAP_CLICK, function (e:MapLocationEvent):void {
				item.location = e.location;
				marker.location = e.location;
				map.center = e.location;
			});
		}
		
		
		
		// EVENTS
		
		public function onMapCenterChange ( e:Event ) :void {
			trace ( "map change center" );
		}

		public function onAddressChange ( e:Event ) : void {
			this.map.geocodingAddress ( this.txtAddress.text );
		}

		private function onClickBack ( e:MouseEvent = null ) : void {
			// this transform map (web stage) in a static image, 
			// In this way I can show a popup or make an animation
			this.map.freezeMap = true;
			this.navigator.popView();
		}

		]]>
	</fx:Script>	


	...

	<s:TextInput width="100%" enter="onAddressChange(event)" />

	...

	<c:GoogleMap id="map" width="100%" height="100%" 
	mapReady="onMapReady(event)" 
	mapCenterChange="onMapCenterChange(event)"
	/>
	
	...
	
	</s:View>
