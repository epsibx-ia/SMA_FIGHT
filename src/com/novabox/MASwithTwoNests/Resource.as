package com.novabox.MASwithTwoNests 
{
	import flash.geom.Point;
	
	/**
	 * Cognitive Multi-Agent System Example
	 * Part 2 : Two distinct termite nests
	 * (Termites collecting wood)
	 * 
	 * @author Ophir / Nova-box
	 * @version 1.0
	 */
	public class Resource extends Agent
	{
		private var life:Number;
		
		private var  speed:Number;
		private var direction:Point;
		private var changeDirectionDelay:Number;

		public function Resource() 
		{
			super(AgentType.AGENT_RESOURCE);
			life = 0;
			changeDirectionDelay = 0;
		}
		
		public function Initialize(_life:Number) : void
		{
			var startLife:Number = _life;
			
			if (World.RESOURCE_RANDOM_START_LIFE)
			{
				startLife = startLife * Math.random() + World.RESOURCE_UPDATE_VALUE;
			}
			
			SetLife(startLife);
			
			DrawSprite();
		}
		
		public function SetLife(_life:Number) : void
		{
			life = _life;
			if (life < 0)
			{
				life = 0;
			}
		}
		
		public function GetLife() : Number
		{
			return life;
		}
		
		public function DecreaseLife() : void
		{
			SetLife(life - World.RESOURCE_UPDATE_VALUE);			
		}
		
		public function IncreaseLife() : void
		{
			SetLife(life + World.RESOURCE_UPDATE_VALUE);			
		}
		
		override public function Update() : void
		{
			DrawSprite();
			ProcessPosition();
		}
		
		private function ProcessPosition() : void 
		{
			changeDirectionDelay -= TimeManager.timeManager.GetFrameDeltaTime();
			if (changeDirectionDelay <= 0) {
				speed = (World.RESOURCE_MIN_SPEED + Math.random() * (World.RESOURCE_MAX_SPEED - World.RESOURCE_MIN_SPEED)) / 1000;
				var newTarget:Point = new Point(World.WORLD_WIDTH * Math.random(), World.WORLD_HEIGHT * Math.random());
				direction = newTarget.subtract(targetPoint);
				changeDirectionDelay = direction.length / speed;
				direction.normalize(1);
			}
			
			var positionOffset:Point = direction.clone();
			positionOffset.normalize(TimeManager.timeManager.GetFrameDeltaTime() * speed);
			targetPoint = targetPoint.add(positionOffset);
		}
		
		protected function DrawSprite() : void
		{
			this.graphics.clear();
			if (life > 0)
			{
				this.graphics.beginFill(0xCCCCCC, 1);
					this.graphics.drawCircle(0, 0, World.RESOURCE_LIFE_RADIUS_COEFF * life);
				this.graphics.endFill();
			}
		}
	}
	
}