package com.hans.run.integrations.action
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2World;

	/**
	 *Battle.as：
	 *<p></p>
	 *@author:Hans
	 *@date:2013-5-26
	 */
	public class Battle
	{
		private var _world:b2World;
		
		public function Battle()
		{
			
		}
		private function initBattle():void
		{
			world=new b2World(new b2Vec2(0,0.98),true);
			world.SetWarmStarting(false);
		}

		public function get world():b2World
		{
			return _world;
		}

		public function set world(value:b2World):void
		{
			_world = value;
		}

	}
}