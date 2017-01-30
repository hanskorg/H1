package com.hans.core.remoting.core
{
    import flash.events.*;

    public interface IRequest 
    {

        function onResponse(respose:Object):void;
        function onFault(respose:String):void;
        function get remoteCallName():String;
        function get requestVars():Array;
        function set requestVars(args:Array):void;
		function set type(value:String):void;
		function get type():String;

    }
}