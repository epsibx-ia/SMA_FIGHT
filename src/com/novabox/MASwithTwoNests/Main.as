package com.novabox.MASwithTwoNests
{
	import com.novabox.expertSystem.ExpertSystem;
	import com.novabox.expertSystem.Rule;
	import com.novabox.expertSystem.Fact;
	import fl.controls.Button;
	import fl.controls.CheckBox;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import fl.events.ComponentEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * Cognitive Multi-Agent System Example
	 * Part 2 : Two distinct termite nests
	 * (Termites collecting wood)
	 * 
	 * @author Ophir / Nova-box
	 * @version 1.0
	 */
	public class Main extends Sprite 
	{
		public static var world:World;
		
		protected var paused:Boolean;		
		protected var startFromHome:CheckBox;
		protected var homeGettingBigger:CheckBox;
		protected var pauseButton:Button;
		protected var restartButton:Button;
		protected var botCountField:TextField;
		protected var durationField:TextField;
		protected var timeLeftField:TextField;
		protected var timeLeft:int;
		
		protected var teamScores:Array;
		
		public function Main():void 
		{		
			if (stage) 	InitializeUI(), init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			paused = false;
			if (pauseButton)
			{
				pauseButton.label = "Pause";
			}
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			world = new World();
			
			addChild(world);
		
			if (isNaN(parseInt(botCountField.text)))
			{
				botCountField.text = "50";
			}
			
			World.BOT_COUNT =  parseInt(botCountField.text);
			
			timeLeft = parseInt(durationField.text) * 1000;
			
			world.Initialize();
			
			stage.addEventListener(Event.ENTER_FRAME, Update);
			
		}
		
		private function InitializeUI() : void
		{
			startFromHome = new CheckBox();
			startFromHome.label = "Start from home";
			startFromHome.width = 200;
			startFromHome.x = 680
			startFromHome.y = 0;
			startFromHome.selected = World.BOT_START_FROM_HOME;
			addChild(startFromHome);
			startFromHome.addEventListener(MouseEvent.CLICK, SwitchStartFromHome);
			
			homeGettingBigger = new CheckBox();
			homeGettingBigger.label = "Home expansion";
			homeGettingBigger.selected = World.HOME_GETTING_BIGGER;
			homeGettingBigger.width = 200;
			homeGettingBigger.x = 680;
			homeGettingBigger.y = 20;
			addChild(homeGettingBigger);
			homeGettingBigger.addEventListener(MouseEvent.CLICK, SwitchHomeExpansion);
			
			pauseButton = new Button();
			pauseButton.label = "Pause";
			pauseButton.x = 680;
			pauseButton.y = 45;
			addChild(pauseButton);
			pauseButton.addEventListener(MouseEvent.CLICK, Pause);

			restartButton = new Button();
			restartButton.label = "Restart";
			restartButton.x = 680;
			restartButton.y = 70;
			addChild(restartButton);
			restartButton.addEventListener(MouseEvent.CLICK, Restart);
			
			var botCountLabel:TextField = new TextField();
			botCountLabel.autoSize = TextFieldAutoSize.LEFT;
			botCountLabel.x = 680;
			botCountLabel.y = 100;
			botCountLabel.text = "Bot count : ";
			botCountLabel.setTextFormat(new TextFormat("arial", 11));
			addChild(botCountLabel);
			
			botCountField = new TextField();
			botCountField.border = true;
			botCountField.type = TextFieldType.INPUT;
			botCountField.width = 40;
			botCountField.height = 20;
			//botCountField.label = "Bot count";
			botCountField.x = 738;
			botCountField.y = 100;
			botCountField.setTextFormat(new TextFormat("arial", 11));
			botCountField.text = "50";

			addChild(botCountField);

			var durationLabel:TextField = new TextField();
			durationLabel.autoSize = TextFieldAutoSize.LEFT;
			durationLabel.x = 680;
			durationLabel.y = 130;
			durationLabel.text = "Duration : ";
			durationLabel.setTextFormat(new TextFormat("arial", 11));
			addChild(durationLabel);
			
			durationField = new TextField();
			durationField.border = true;
			durationField.type = TextFieldType.INPUT;
			durationField.width = 40;
			durationField.height = 20;
			//durationField.label = "Bot count";
			durationField.x = 738;
			durationField.y = 130;
			durationField.setTextFormat(new TextFormat("arial", 11));
			durationField.text = "90";

			addChild(durationField);
			
			teamScores = new Array();
			
			for (var i:int = 0; i < World.ALL_TEAMS.length; i++)
			{
				var team:BotTeam = World.ALL_TEAMS[i];
				var teamCheckBox:CheckBox = new CheckBox();
				teamCheckBox.label = team.GetId();
				
				
				if (i < 2)
				{
					teamCheckBox.selected = true;
					if (!World.teams) World.teams = new Array();
					World.teams.push(team);
				}
				
				teamCheckBox.width = 200;
				teamCheckBox.x = 680
				teamCheckBox.y = 160 + i * 50;
				addChild(teamCheckBox);
				
				var teamScoreField:TextField = new TextField();
				teamScoreField.x = 680;
				teamScoreField.y = 180 + i * 50;
				teamScoreField.text = "";
				addChild(teamScoreField);
				
				teamScores.push(teamScoreField);
				
				teamCheckBox.addEventListener(MouseEvent.CLICK, SwitchTeamSelected);
	
				this.graphics.beginFill(team.GetColor());
				this.graphics.drawRect(teamCheckBox.x - 10, teamCheckBox.y + 5 , 10 , 10);
				this.graphics.endFill();

			}
			
			
			timeLeftField = new TextField();
			timeLeftField.x = 690;
			timeLeftField.y = 180 + 50 * World.ALL_TEAMS.length;
			timeLeftField.text = "00:00";
			timeLeftField.setTextFormat(new TextFormat("Arial", 26));
			addChild(timeLeftField);
		}
		
		private function SwitchStartFromHome(_e:Event) : void
		{
			World.BOT_START_FROM_HOME = startFromHome.selected;
		}
		
		private function SwitchTeamSelected(_e:Event) : void
		{
			var checkBox:CheckBox = (_e.currentTarget as CheckBox);
			for each(var team:BotTeam in World.ALL_TEAMS)
			{
				if (team.GetId() == checkBox.label)
				{
					if (!checkBox.selected)
					{
						if (World.teams.indexOf(team) != -1)
						{
							World.teams.splice(World.teams.indexOf(team), 1);
						}
					}
					else
					{
						if (World.teams.indexOf(team) == -1)
						{
							World.teams.push(team);
						}
					}
				}
			}
		}
		
		private function SwitchHomeExpansion(_e:Event) : void
		{
			World.HOME_GETTING_BIGGER = homeGettingBigger.selected;
		}

		private function Pause(_e:Event) : void
		{
			paused = !paused;
			if (paused)
			{
				(_e.currentTarget as Button).label = "Play";
			}
			else
			{
				(_e.currentTarget as Button).label = "Pause";				
			}
		}
		
		private function Restart(_e:Event): void
		{
			stage.removeEventListener(Event.ENTER_FRAME, Update);
			if(world.parent == this) removeChild(world);
	
			
			init(_e);
		}
		
		
		private function Update(_event:Event) : void
		{
			TimeManager.timeManager.Update();
			if (!paused && timeLeft >= 0)
			{
				world.Update();
				UpdateCounters();
				
				timeLeft -= TimeManager.timeManager.GetFrameDeltaTime();
			}
			if (timeLeft < 0)
			{
				ShowWinner();
				paused = true;
			}
		}
		
		private function ShowWinner() : void
		{
			var winText = "";
			
			var maxResource:int = 0;
			var minResource:int = int.MAX_VALUE;
			var winner:BotTeam = null;
			var drawMatch:Boolean = false;
			
			for each(var team:BotTeam in World.teams)
			{
				if (team.home.GetResourceCount() >= maxResource) {
					drawMatch = (team.home.GetResourceCount() == maxResource);
					maxResource = team.home.GetResourceCount();
					winner = team;
				}
				if (team.home.GetResourceCount() < minResource)
				{
					minResource = team.home.GetResourceCount();
				}
			}
			
			if (drawMatch) {
				winText = "Draw match!";
			} else {
				winText = winner.GetId() + " wins!";
				if (minResource == 0) {
					winText += "\nPerfect!";
				}
			}
			
			var winnerField:TextField = new TextField();
			winnerField.text = winText;
			winnerField.setTextFormat(new TextFormat("Arial", 40, 0xFFFFFF, true));
			winnerField.autoSize = TextFieldAutoSize.CENTER;
			winnerField.x = (world.width  - winnerField.textWidth) / 2;
			winnerField.y = (world.height  - winnerField.textHeight) / 2;
			addChild(winnerField);
		}
		
		private function UpdateCounters() : void 
		{
			timeLeftField.text = secondsToString(timeLeft/1000);
			timeLeftField.setTextFormat(new TextFormat("Arial", 26));
			
			for (var i:int = 0; i < World.teams.length; i++ )
			{
				var team:BotTeam = World.teams[i];
				var scoreField:TextField = teamScores[i];
				scoreField.text = "score : " + team.home.GetResourceCount().toString();
				scoreField.setTextFormat(new TextFormat("Arial", 16));
			}
		}
		
		public function secondsToString(_seconds:int) : String {
			var minutes:int = _seconds / 60;
			var seconds:int = _seconds  - minutes * 60;
			
			return zeroPad(minutes, 2) + ":" + zeroPad(seconds, 2);
		}
		
		public function zeroPad(number:int, width:int):String {
		   var ret:String = ""+number;
		   while( ret.length < width )
			   ret="0" + ret;
		   return ret;
		}
	}
	
}