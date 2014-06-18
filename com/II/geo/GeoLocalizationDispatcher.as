package com.II.geo 
{
	import com.II.components.googlemap.Location;
	import com.II.Utils;
	import components.popup.PopUpWait;
	import flash.events.ActivityEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.GeolocationEvent;
	import flash.sensors.Geolocation;
	/**
	 * ...
	 * @author 
	 */
	public class GeoLocalizationDispatcher extends EventDispatcher {
		
		
		
		public function GeoLocalizationDispatcher() {
			this.geo = new Geolocation();
		}
		
		[Bindable(event="GeoMyPosChange")]
		/**
		 * Ultima geolocalizzazione rilevata dell'utente
		 */
		public var geoMyPos:Location = null;
		
		/**
		 * Per le funzioni di geolocalizzazione
		 */
		private var geo:Geolocation = null;
		
		/**
		 * Numero di eventi di aggiornamento posizione arrivati dalla geolocalizzazione
		 */
		private var geoCountUpdate:int = 0;
		
		private var callbackUpdate:Function = null;
		
		public function geoStart ( callback:Function=null ) : Boolean {
			if (Geolocation.isSupported == true) { 
				this.callbackUpdate = callback;
				geoCountUpdate = 0; 
				geo.setRequestedUpdateInterval(500);  
				geo.addEventListener(GeolocationEvent.UPDATE, this.geoUpdate);
/*
				PopUpWait.Open(null, 
					function():void {
						App.GeoStop();
					},
					"Ricerca GPS"
				);
*/	

			} else {
				trace ( "Geolocation is not supported on this device." );
				Utils.Alert ( "Geolocation is not supported on this device." );
				
				this.geoMyPos = new Location ( 44, 11 );
				this.dispatchEvent ( new GeoLocalizzationEvent( this.geoMyPos ) );
				if ( this.callbackUpdate != null ) this.callbackUpdate ( this );
				
				return false;
			}
			
			return true;
		}
		
		public function geoStop() : void {
			this.callbackUpdate = null;
			geo.removeEventListener(GeolocationEvent.UPDATE, this.geoUpdate);
		}
		
		private function geoUpdate(event:GeolocationEvent):void {
			//Utils.Alert("("+event.latitude + ", " + event.longitude + ") (" + event.horizontalAccuracy + ", "+ event.verticalAccuracy+")");
			//PopUpWait.ChangeMessage( "GPS: tentativo "+geoCountUpdate+" su 2\n\r ("+event.latitude + ", " + event.longitude + ") (" + event.horizontalAccuracy + ", "+ event.verticalAccuracy+")" )
			this.geoCountUpdate++;

			//PopUpWait.Close();
			
			this.geoMyPos = new Location ( event.latitude, event.longitude );
			this.dispatchEvent ( new GeoLocalizzationEvent( this.geoMyPos ) );
			if ( this.callbackUpdate != null ) this.callbackUpdate ( this );
			
        }
		
	}

}