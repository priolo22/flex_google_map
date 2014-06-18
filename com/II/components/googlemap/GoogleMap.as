package com.II.components.googlemap 
{
	import com.adobe.images.BitString;
	import com.II.Utils;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.GeolocationEvent;
	import flash.events.LocationChangeEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.net.URLVariables;
	import flash.sensors.Geolocation;
	
	import models.App;
	
	import mx.collections.ArrayList;
	import mx.core.BitmapAsset;
	import mx.core.UIComponent;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.MoveEvent;
	import mx.utils.MatrixUtil;
	
	import spark.primitives.BitmapImage;
	import spark.components.Image;
	
	import components.popup.PopUpWait
	/**
	 * ...
	 * @author 
	 */
	[Event(name = "mapReady", type = "flash.events.Event")]
	[Event(name = "mapClick", type = "com.II.components.googlemap.MapLocationEvent")]
	[Event(name = "mapCenterChange", type = "flash.events.Event")]
	[Event(name = "mapClickInfo", type = "com.II.components.googlemap.MarkerEvent")]
	public class GoogleMap extends UIComponent {
		
		
		public static const EVENT_READY:String = "mapReady";
		public static const EVENT_CENTER_CHANGE:String = "mapCenterChange";
		
		
		
		// PROPERTIES //
		
		/** IL CENTRO DELLA MAPPA **/
		public function set center ( value:Location ) : void {
			_center = value;
			this.webView.loadURL("javascript:setCenter("+_center.latitude+","+_center.longitude+")");
		}
		public function get center () : Location {
			return _center;
		}
		private var _center:Location = null;

		/** LIVELLO DI ZOOM APPLICATO ALLA MAPPA **/
		public function set zoom ( value:Number ) :void {
			_zoom = value;
			this.webView.loadURL("javascript:setZoom("+_zoom+")");
		}
		public function get zoom() :  Number {
			return _zoom;
		}
		private var _zoom:Number = 0;
		
		/**
		 * Contenitore della pagina web
		 */
		public var webView:StageWebView = new StageWebView();
		
		/**
		 * Per le funzioni di geolocalizzazione
		 */
		protected var geolocation:Geolocation = new Geolocation();
				
		/**
		 * Congela la mappa (la pagina web) in questa maniera è possibile far uscire un popup
		 */
		public function set freezeMap ( value:Boolean ) : void {
			if ( value == _freezeMap ) return;
			_freezeMap = value;
			if ( _freezeMap == true ) {
				if ( this.webView.viewPort != null ) {
					if ( this.bdFreeze == null ) {
						this.bdFreeze = new BitmapData(this.webView.viewPort.width, this.webView.viewPort.height);
					}
					this.webView.drawViewPortToBitmapData(this.bdFreeze);
					this.webView.stage = null;
				}
			} else {
				this.updatePosMap();
				this.webView.stage = stage;
				this.bdFreeze = null;
			}
			this.invalidateDisplayList();
		}
		override public function invalidateDisplayList():void {
			super.invalidateDisplayList();
			
			if ( this.markers.length == 0 && App.DisplayType==App.DISPLAY_TABLET ) {
				this.setStartBounds();
			}
		}
		public function get freezeMap () : Boolean {
			return _freezeMap;
		}
		private var _freezeMap:Boolean = false;
		
		/**
		 * Contiene la bitmap da utilizzare per il freeze
		 */
		private var bdFreeze:BitmapData = null;
		
		/**
		 * Markers presenti in mappa
		 */
		public function get markers():ArrayList {
			if ( _markers == null ) {
				_markers = new ArrayList();
				_markers.addEventListener (CollectionEvent.COLLECTION_CHANGE, onMarkersChange );
			}
			return _markers;
		}
		public function set markers(value:ArrayList):void {
			if ( value == _markers ) {
				return;
			}
			_markers = value;
			this.updateMarkers();
		}
		private var _markers:ArrayList = null;
		private function onMarkersChange ( e:CollectionEvent ) : void {
			switch ( e.kind ) {
				case CollectionEventKind.ADD:
					for each ( var m1:Marker in e.items ) {
						m1.parent = this;
					}
				break;
				case CollectionEventKind.REMOVE:
					for each ( var m2:Marker in e.items ) {
						m2.parent = null;
					}
				break;
			}
		}
		
		// PROPERTIES //
		
		
		
		// CONSTRUCTOR //
		
		public function GoogleMap() {
			this.addEventListener ( Event.ADDED_TO_STAGE, onAddedToStage );
			this.addEventListener ( Event.REMOVED_FROM_STAGE, onRemovedToStage );
		}
		
		
		
		
		// CONSTRUCTOR //
		
		public function onAddedToStage ( e:Event ) : void {
			this.createMap();
		}
		
		public function onRemovedToStage ( e:Event ) : void {
			this.geoRemove();
			this.removeMap();
		}
		
		// CONSTRUCTOR
		
		
		
		
		
		// METHODS
		
		public function setBounds ( lat1:Number, lng1:Number, lat2:Number, lng2:Number ) : void {
			this.webView.loadURL("javascript:setBounds("+lat1+","+lng1+","+lat2+","+lng2+")");
		}
		
		public function setStartBounds () : void {
			this.webView.loadURL("javascript:setStartBounds()");
		}
		
		public function geocodingAddress ( address:String ) : void {
			this.webView.loadURL("javascript:geocodeAddress('"+address+"')");
		}
		
		// METHODS
		
		
		
		// OVERRIDING UICOMPONENT //
		
		override public function set x(value:Number):void {
			super.x = value;
			this.updatePosMap();
		}
		
		override public function set y(value:Number):void {
			super.y = value;
			this.updatePosMap();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void  {
			super.updateDisplayList(unscaledWidth, unscaledHeight);

			graphics.clear();
			
			graphics.beginFill ( 0x000000 );
			graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
			graphics.endFill();
			
			if ( this.freezeMap == true ) {
				if ( this.bdFreeze == null ) return;
				var mtx:Matrix = new Matrix();
				mtx.scale ( unscaledWidth / this.bdFreeze.width, unscaledHeight / this.bdFreeze.height );
				graphics.beginBitmapFill(this.bdFreeze, mtx );
				graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
				graphics.endFill();
			} else {
				this.updatePosMap();
			}
		}

		// OVERRIDING UICOMPONENT //
		
		
		
		// MARKER //
		
		public function markersClear() : void {
			for each ( var m:Marker in this.markers.source ) {
				m.parent = null;
			}
			this.markers.removeAll();
		}		
		
		private function clearMarkers ():void {
			var url:String = "javascript:clearMarkers()";
			this.webView.loadURL( url );
		}
		
		private function updateMarkers():void {
			this.clearMarkers();
			for each ( var m:Marker in this.markers.source ) {
				m.parent = this;
			}
		}
		
		public function showAllMarkers():void {
			webView.loadURL("javascript:updateBounds()");
		}
		
		public function findMarker ( id:String ) : Marker {
			for each ( var m:Marker in this.markers.source ) {
				if ( m.id == id ) return m;
			}
			return null;
		}
		
		// MARKER //
		
		
		
		// MAPPA //
		
		/**
		 * Creo il web stage
		 */
		private function createMap ():void {
			this.webView = new StageWebView();
			this.updatePosMap();
			webView.stage = stage;
			//var params:String = "la=" + this.resultData.latitudine + "&ln=" + this.resultData.longitudine;
			//var params:String = this.item.query;
			//webView.loadURL("http://priolo22.altervista.org/map.html?"+params);
			this.webView.loadURL("http://priolo22.altervista.org/eliminacode/map/map.html");

			this.webView.addEventListener(Event.COMPLETE, this.onWebComplete );
			this.webView.addEventListener(LocationChangeEvent.LOCATION_CHANGING, onLocationChanging);
		}
		
		/**
		 * rimuovo il web stage
		 */
		private function removeMap ():void {
			if ( this.webView == null ) return;
			this.webView.viewPort = null;
			this.webView.dispose();
			this.webView = null;
		}
		
		/**
		 * aggiorno il riquadro nella mappa rispetto a quello occupato da questo componente
		 */
		private function updatePosMap () : void {
			if ( this.webView == null ) return;
			if ( this.visible == false || this.freezeMap == true ) {
				this.webView.viewPort = null;
			} else {
				var rct:Rectangle = this.getBounds(stage);
				if ( rct.isEmpty() == false ) {
					this.webView.viewPort = rct;
				} else {
					this.webView.viewPort = null;
				}
			}
		}
		
		// la pagina web è stata completamente caricata... inizializzo.
		private function onWebComplete ( e:Event ) : void {
			this.updateMarkers();
			//this.dispatchEvent(new Event(GoogleMap.EVENT_READY));
		}

		// funzione richiamata da StageWebView quando clicco sul dettaglio di un marker
		private function onLocationChanging(e:LocationChangeEvent):void {
			// ricavo il codice del marker selezionato e annullo la navigazione
			var arr:Array = e.location.split(".html?");
			var vars:URLVariables = new URLVariables(arr[1]);
			webView.historyBack();
			e.preventDefault();
			
			var pos:Location = null;
			
			switch ( vars.action ) {
				case "geocoding_address":
					pos = new Location(vars.lat, vars.lng);
					this.dispatchEvent(new MapLocationEvent(pos, MapLocationEvent.GEOCODING_ADDRESS));
				break;
				case "map_ready":
					this.dispatchEvent(new Event(GoogleMap.EVENT_READY));
				break;
				case "map_click":
					pos = new Location(vars.lat, vars.lng);
					this.dispatchEvent(new MapLocationEvent(pos, MapLocationEvent.MAP_CLICK));
				break;
				case "map_center_changed":
					this.center = new Location(vars.lat, vars.lng);
					this.dispatchEvent(new Event(GoogleMap.EVENT_CENTER_CHANGE));
				break;
				case "click_info":
					var m1:Marker = this.findMarker ( vars.id );
					this.dispatchEvent ( new MarkerEvent ( m1, MarkerEvent.CLICK_INFO ) );
				break;
				case "click_marker":
					var m2:Marker = this.findMarker ( vars.id );
					this.dispatchEvent ( new MarkerEvent ( m2, MarkerEvent.CLICK_MARKER ) );
				break;
				case "map_ready":
					trace ( "mappa ready" );
				break;
			}
		}
		
		// MAPPA //		
		
		
		
		
		
		// GEOLOCATION //

		private var myPosMarker:Marker = null;
		private var myPosCenter:Boolean = true;
		private var myPosLocation:Location = null;
		
		protected function geoStart () : void {
			if (Geolocation.isSupported == true) { 
				geoCountUpdate = 0; 
				this.geolocation.setRequestedUpdateInterval(500); 
				this.geolocation.addEventListener(GeolocationEvent.UPDATE, this.geoUpdate);
				this.freezeMap = true;
				var self:* = this;
				PopUpWait.Open(null, 
					function():void {
						self.freezeMap = false;
						self.geoRemove();
					},
					"Ricerca GPS"
				);
			} else {
				trace ( "Geolocation is not supported on this device." );
				Utils.Alert ( "Geolocation is not supported on this device." );
			}
		}
		private var geoCountUpdate:int = 0;
		protected function geoUpdate(event:GeolocationEvent):void {
			//Utils.Alert("("+event.latitude + ", " + event.longitude + ") (" + event.horizontalAccuracy + ", "+ event.verticalAccuracy+")");
			//PopUpWait.ChangeMessage( "GPS: tentativo "+geoCountUpdate+" su 2\n\r ("+event.latitude + ", " + event.longitude + ") (" + event.horizontalAccuracy + ", "+ event.verticalAccuracy+")" )
			geoCountUpdate++;
			//if ( geoCountUpdate < 2 ) return;
			
			//this.geoRemove();
			PopUpWait.Close();
			this.freezeMap = false;
			
			this.myPosLocation = new Location ( event.latitude, event.longitude );
			
			if ( this.myPosMarker == null ) {
				this.myPosMarker = new Marker("my_marker", this.myPosLocation, "marker_me.png", "", "" ); 
			}
			this.myPosMarker.parent = this;
			
			this.center = this.myPosLocation;
        }
		
		protected function geoRemove() : void {
			this.geolocation.removeEventListener(GeolocationEvent.UPDATE, this.geoUpdate);
		}
		
		public function showMyPosition( marker:Marker=null, center:Boolean=true ) :void {
			this.myPosCenter = center;
			this.myPosMarker = marker;
			this.geoStart();
		}
		
		// GEOLOCATION //
		
		
	}

}