package com.adamatomic.mode;

import org.flixel.FlxState;
import org.flixel.FlxEmitter;
import org.flixel.FlxG;
import org.flixel.FlxText;

import flash.display.Bitmap;
import flash.display.BitmapData;

class VictoryState extends FlxState
{
	//[Embed(source="../../../data/spawner_gibs.png")] private var ImgGibs:Class;
	//[Embed(source="../../../data/menu_hit_2.mp3")] private var SndMenu:Class;
	
	private var _timer:Float;
	private var _fading:Bool;

	override public function create():Void {
		_timer = 0;
		_fading = false;
		FlxG.flash.start(0xffd8eba2);
		
		//Gibs emitted upon death
		var gibs:FlxEmitter = new FlxEmitter(0,-50);
		gibs.setSize(FlxG.width,0);
		gibs.setXSpeed();
		gibs.setYSpeed(0,100);
		gibs.setRotation(-360,360);
		gibs.gravity = 80;
		gibs.createSprites(ImgGibs,800,32);
		add(gibs);
		gibs.start(false,0.005);
		
		add((new FlxText(0,FlxG.height/2-35,FlxG.width,"VICTORY\n\nSCORE: "+FlxG.score)).setFormat(null,16,0xd8eba2,"center"));
	}

	override public function update():Void
	{
		super.update();
		if(!_fading)
		{
			_timer += FlxG.elapsed;
			if((_timer > 0.35) && ((_timer > 10) || FlxG.keys.justPressed("X") || FlxG.keys.justPressed("C")))
			{
				_fading = true;
				//FlxG.play(SndMenu); //TODO: get sounds embedding/playing correctly
				FlxG.fade.start(0xff131c1b,2,onPlay);
			}
		}
	}
	
	private function onPlay():Void 
	{
		FlxG.state = new PlayState();
	}
}
