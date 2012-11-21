package com.novabox.MASwithTwoNests 
{
	import com.novabox.MASwithTwoNests.AgentFacts;
	import com.novabox.expertSystem.ExpertSystem;
	import com.novabox.expertSystem.Fact;
	import com.novabox.expertSystem.Rule;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * Cognitive Multi-Agent System Example
	 * Part 2 : Two distinct termite nests
	 * (Termites collecting wood)
	 * 
	 * @author Ophir / Nova-box
	 * @version 1.1
	 */
	public class Bot extends Agent
	{
		//Sprite
		protected var botSprite:Sprite;

		//Bot properties
		protected var radius:Number;
		protected var speed:Number;
		protected var directionChangeDelay:Number;
		protected var direction:Point;
		protected var perceptionRadius:Number;
		
		protected var teamId:String;
		private var color:int;
		
		private var hasResource:Boolean;
				
		public function Bot(_type:AgentType) 
		{
			super(_type);
			
			radius = 0;
			speed = 0;
			directionChangeDelay = 0;
			direction = null;

		}
		
		public function initialize(_teamId:String, _color:int, _radius:Number, _speed:Number, _directionChangeDelay:Number, _perceptionRadius:Number) : void
		{		
			teamId = _teamId;
			color = _color;
			
			speed = _speed;
			radius = _radius;
			direction = new Point();
		
			hasResource = false;
			
			perceptionRadius = _perceptionRadius;
			directionChangeDelay = _directionChangeDelay;
			
			InitSprites();
			DrawSprite();
		
			addEventListener(AgentCollideEvent.AGENT_COLLIDE, onAgentCollide);

			
			ChangeDirection();
			
		}
		
		
		public function GetTeamId() : String
		{
			return teamId;
		}
		

				
		public function	InitSprites() : void
		{
			this.graphics.beginFill(0XAAAAAA, 0.);
				this.graphics.drawCircle(0, 0, perceptionRadius);
			this.graphics.endFill();
			
			
			botSprite = new Sprite();
			addChild(botSprite);
			
			
		}
		
		protected function DrawSprite() : void
		{
			var botColor:int = color;
			
			if (hasResource)
			{
				botColor =  color + 0x555555; //0X228822;
			}
			
			botSprite.graphics.clear();
			botSprite.graphics.beginFill(botColor, 1);
				botSprite.graphics.drawCircle(0, 0, radius);
			botSprite.graphics.endFill();
		}

		override public function Update() : void
		{
			DrawSprite();
			Move();

		}

		
		public function IsCollided(_agent:Agent) : Boolean
		{
			return botSprite.hitTestObject(_agent);
		}
		
		public function IsPercieved(_agent:Agent) : Boolean
		{
			return this.hitTestObject(_agent);
		}
		
		public function onAgentCollide(_event:AgentCollideEvent) : void
		{
			var collidedAgent:Agent = _event.GetAgent();
			
			if (IsCollided(collidedAgent))
			{
				//Bot collision
				
			}
			else
			{
				//Perception
				
	
			}
		}


			
		public function Move() : void
		{
			var elapsedTime:Number = TimeManager.timeManager.GetFrameDeltaTime();
			
			var botSpeed:Number = speed;
			if (hasResource)
			{
				botSpeed *= World.BOT_WITH_RESOURCE_SPEED_COEFF;
			}
			
			 targetPoint.x = x + direction.x * botSpeed * elapsedTime / 1000 ;
			 targetPoint.y = y + direction.y * botSpeed * elapsedTime / 1000;			
		}
				
		public function GetDirection() : Point
		{
			return direction;
		}
		
		public function SetDirection(_direction:Point) : void
		{
			direction = new Point(_direction.x, _direction.y);
		}
		
		public function ChangeDirection() : void
		{
				direction.x = Math.random();
				direction.y = Math.random();
			
				if (Math.random() < 0.5)
				{
					direction.x *= -1;
				}
				if (Math.random() < 0.5)
				{
					direction.y *= -1;				
				}
			
				direction.normalize(1);
				
		}
		
		public function HasResource() : Boolean
		{
			return hasResource;
		}
		
		public function SetResource(_value:Boolean) : void
		{
			hasResource = _value;
		}
		
		public function StealResource(_bot:Bot) : void
		{
			_bot.SetResource(false);
			SetResource(true);
		}
		
		public function Drop(_agent:Agent) : void
		{
			_agent.SetTargetPoint(new Point(targetPoint.x, targetPoint.y));
			Main.world.AddAgent(_agent);
		}
		
	}
	
}