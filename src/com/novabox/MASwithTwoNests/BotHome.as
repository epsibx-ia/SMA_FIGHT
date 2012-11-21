package com.novabox.MASwithTwoNests 
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.ui.ContextMenuBuiltInItems;
	/**
	 * Cognitive Multi-Agent System Example
	 * Part 2 : Two distinct termite nests
	 * (Termites collecting wood)
	 * 
	 * @author Ophir / Nova-box
	 * @version 1.0
	 */
	public class BotHome extends Agent
	{

		private var teamId:String;
		private var resourceCount:int;
		private var color:int;
		
		private var countText:TextField;
		
		private var  speed:Number;
		private var direction:Point
		private var changeDirectionDelay:Number;
		
		public function BotHome(_teamId:String, _color:int) 
		{
			super(AgentType.AGENT_BOT_HOME);
			resourceCount = 0;
			teamId = _teamId;
			color = _color;
			
			countText = new TextField();
			countText.autoSize = TextFieldAutoSize.CENTER;			
			addChild(countText);
			
			changeDirectionDelay = 0;
		}
		
		public function GetTeamId() : String
		{
			return teamId;
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
			var homeRadius:Number = World.HOME_RADIUS;
			if (World.HOME_GETTING_BIGGER)
			{
				homeRadius = resourceCount * 1 + World.HOME_RADIUS;
			}
			
			
			this.graphics.clear();
			this.graphics.beginFill(color, 0.5);
				this.graphics.drawCircle(0, 0, homeRadius);
			this.graphics.endFill();
		
			countText.text = resourceCount.toString();
			countText.x = -countText.textWidth/2;
			countText.y = -countText.textHeight/2;
		}		
		
		public function AddResource() : void
		{
			resourceCount++;
		}
		
		public function TakeResource() : void 
		{
			resourceCount--;
			if (resourceCount < 0) resourceCount = 0;
		}
		
		public function HasResource() : Boolean
		{
			return (resourceCount > 0);
		}
		
		public function GetResourceCount() : int
		{
			return resourceCount;
		}
		
	}

}