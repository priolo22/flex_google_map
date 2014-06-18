package com.II.http 
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	/**
	 * ...
	 * @author ...
	 */
	public class Query 
	{
		
		public function Query(url:String, data:String, callback:Function) : void {
			
			var request:URLRequest = new URLRequest(url);
			request.data = data;
			request.contentType = "application/json";
			request.cacheResponse = false;
			request.method = URLRequestMethod.POST;
			
			var loader:URLLoader = new URLLoader ();
			loader.addEventListener (
				Event.COMPLETE, 
				function ( e:Event ) : void {
					if ( callback!=null ) callback(e.target.data);
				}
			);
			loader.load (request);
		}
		
	}

}