package com.hans.core.remoting.core
{
    public interface IRemotingConnection 
    {

        function connectTo(url:String, ... _args):void;
        function  send(request:IRequest):void;

    }
}
