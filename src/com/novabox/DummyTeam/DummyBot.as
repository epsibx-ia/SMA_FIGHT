package com.novabox.DummyTeam 
{
	import com.novabox.MASwithTwoNests.Agent;
	import com.novabox.MASwithTwoNests.AgentCollideEvent;
	import com.novabox.MASwithTwoNests.AgentType;
	import com.novabox.MASwithTwoNests.Bot;
	import com.novabox.MASwithTwoNests.BotHome;
	import com.novabox.MASwithTwoNests.Resource;
	import com.novabox.MASwithTwoNests.TimeManager;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * Reactive Multi-Agent System Example 
	 * (Termites collecting wood)
	 * 
	 * @author Ophir / Nova-box
	 * @version 1.0
	 */
	public class DummyBot extends Bot
	{		
		protected var updateTime:Number = 0;
		
		public function DummyBot(_type:AgentType) 
		{
			super(_type);
	
			updateTime = 0;
		}
		
		override public function Update() : void
		{
			var elapsedTime:Number = TimeManager.timeManager.GetFrameDeltaTime();
			
			updateTime += elapsedTime;
				
			if (updateTime >=  directionChangeDelay)
			{
				ChangeDirection();
				updateTime = 0;
			}
			
			
			 targetPoint.x = x + direction.x * speed * elapsedTime / 1000 ;
			 targetPoint.y = y + direction.y * speed * elapsedTime / 1000;
					
		}
		
		override public function onAgentCollide(_event:AgentCollideEvent) : void
		{
			var collidedAgent:Agent = _event.GetAgent();
			
			if (collidedAgent.GetType() == AgentType.AGENT_RESOURCE)
			{
				if (!HasResource())
				{
					(collidedAgent as Resource).DecreaseLife();
					SetResource(true);
				}
				else
				{
					(collidedAgent as Resource).IncreaseLife();
					SetResource(false);			
				}
				ChangeDirection();
			}
			else if (collidedAgent.GetType() == AgentType.AGENT_BOT_HOME)
			{
				if (HasResource())
				{
					(collidedAgent as BotHome).AddResource();
					SetResource(false);
				}
			}
		}
		
	}
	
}