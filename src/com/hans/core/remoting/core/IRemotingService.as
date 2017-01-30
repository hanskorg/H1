package com.hans.core.remoting.core
{
	import com.hans.core.remoting.core.IRequest;

    public interface IRemotingService 
    {

        function request(request:IRequest):void;
        function get gateway():IRemotingConnection;

    }
}
