package com.hans.core.remoting.base
{

    
    import com.hans.core.remoting.RequestType;
    import com.hans.core.remoting.core.IRemotingConnection;
    import com.hans.core.remoting.core.IRequest;
    import com.hans.core.utils.Debug;
    import com.zoogaa.dianming.MainContext;
    
    import flash.events.EventDispatcher;
    import flash.events.NetStatusEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.TimerEvent;
    import flash.net.NetConnection;
    import flash.utils.Timer;
    
    import org.hans.Queue;

	
	
	/**
	 *RemotingConnection.as：
	 *<p>主通信类</p>
	 * <code>connectTo:初始化连接</code>
	 * <code>send:发送消息</code>
	 * 已经支持：<p>1：队列发送</p>
	 * <p>2、安全消息发送失败中断游戏</p>
	 * <p>3、消息超时处理</p>
	 * <p>4、消息失败
	 *@author:Hans
	 *@date:2012-3-25
	 */

	public class RemotingConnection extends EventDispatcher implements IRemotingConnection 
    {
		public var connection:NetConnection;
		public var quenedConnection:NetConnection;
		
		private var isConnected:Boolean = false;
		/**有同步操作，连接被锁*/
		public var isLock:Boolean = false;
		
		/**队列等到时间*/
		private var maxWaitTime:uint = 5;
		/**队列长度*/
		private var queneLength:uint = 10;
		/**队列*/
		private var quene:org.hans.Queue;
		/**队列计时器*/
		private var queneTimer:Timer;
		
		/**retry队列*/
		private var retryQuene:Array;
		
		public function RemotingConnection(){
			connection = new NetConnection();
			connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR,handler);
			connection.addEventListener(NetStatusEvent.NET_STATUS,handler);
			
			/**初始化队列*/
			quene = new Queue();
			/**重试消息队列*/
			retryQuene = [];
		}
		/**
		 * netconnection连接方法 
		 * @param url
		 * @param args
		 * 
		 */		
		public function connectTo(url:String, ...args):void
		{
			if(!isConnected)
			{
				connection.client = this;
				connection.connect(url,args);
			}
			isConnected = true;				
			if(maxWaitTime!=0){
				queneTimer = new Timer(1000,maxWaitTime);
				queneTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.sendQuene);
			}

		}
		/**
		 * 发送请求 
		 * @param request
		 * 
		 */		
		public function send(request:IRequest):void
		{
			if(!isConnected) { trace("没有连接到服务器，不允许发消息"+request.remoteCallName);return}
			if(request["retry"]) this.retryQuene[request.remoteCallName] = request;
			if(!isLock)
			{
				var arr:Array = [request.remoteCallName,new SimplerResponser(this,request)];
				arr = arr.concat(request.requestVars);
				/**协议类型*/
				if(request.type == RequestType.AYNC){
					connection.call.apply(null,arr);
				}else if(request.type == RequestType.QUENE){
					queuedRequest(request);
				}else if(request.type == RequestType.SYNC){//
					this.isLock = true;
					connection.call.apply(null,arr);
				}
				Debug.log("请求："+request.remoteCallName);
			}else{//如果有消息没有被发送，那么将消息暂时放置到消息队列中，等待下次发送
				this.queuedRequest(request);
				Debug.log("通信队列被锁,等待下次请求："+request.remoteCallName);
			}
		}
		/**
		 * 队列请求 <code>queuedRequest</code>
		 * <p>一旦队列满则开始请求数据</p>
		 */		
		public function queuedRequest(request:IRequest):void
		{
			quene.add(request);
			/**如果队列计时器没有开始*/
			if(quene.size() == 1 && !queneTimer.running) 
				queneTimer.start();
			if(quene.size() >= this.queneLength)
			{
				sendQuene();
			}
		}
		/**
		 *添加到发送队列 
		 */		
		private function sendQuene(arg:*=null):void
		{
			for(var i:int=0 ; i< this.queneLength ; i++)
			{
				var request:IRequest = quene.poll();
				var arr:Array = [request.remoteCallName,new SimplerResponser(this,request)];
				arr = arr.concat(request.requestVars);
				connection.call.apply(null,arr);					
				if(quene.size() == 0) break;
			}
			queneTimer.stop();

		}
		/**
		 * 消息响应失败 
		 * @param err
		 * 
		 */		
		private function errFormat(err:Object):String
		{
			var str:String = "";
			try
			{
				str += "code : "+err.code+"\n";
				str += "description : "+err.description+"\n";
				str += "details : "+err.details+"\n";
				str += "level : "+err.level+"\n";
			} 
			catch(error:Error) 
			{
				
			}
			return str;
		}
		public function handler(info:Object):void
		{
			MainContext.toastUtil.popToast("通信异常"+errFormat(info.info));

		}
		
    }
}
import com.hans.core.remoting.base.RemotingConnection;
import com.hans.core.remoting.core.IRequest;
import com.hans.core.utils.Debug;
import com.zoogaa.dianming.MainContext;

import flash.net.Responder;

/**
 *  <code>internal建议响应处理器</code>
 * @author hans
 * 
 */	
internal class SimplerResponser extends Responder{
	
	private var request:IRequest;
	private var connection:RemotingConnection;
	
	public function SimplerResponser(connection:RemotingConnection,request:IRequest) {
		this.request = request;
		this.connection = connection;
		super(onSuccess, onFail);
	}
	private function onSuccess(data:Object):void{
		Debug.log("响应："+request.remoteCallName);
		this.request.onResponse(data);
		connection.isLock = false;
		dispose();
	}
	/**
	 * 消息失败处理 
	 * @param err
	 * 
	 */
	private function onFail(err:Object):void
	{
		
		if(request["retry"] && request["retryTime"]>0)
		{
			Debug.log(request.remoteCallName+"请求失败，重在重试："+request["retryTime"]);
			connection.send(this.request);
			request["retryTime"]--;
		}else if(request["retry"] && request["retryTime"]==0){//完全失败，不再重试
			connection.handler(err);
			if(this.request["safe"])
			{
				Debug.error(request.remoteCallName+"请求失败：");
			}else{
				Debug.warning(request.remoteCallName+"请求失败：");
			}
			MainContext.toastUtil.popToast(request.remoteCallName+"请求错误");
			connection.isLock = false;			
			/**不再重试，中断请求*/
		}
		this.dispose();
	}
	private function dispose():void
	{
		this.request = null;
		this.connection = null;

	}
	
}
