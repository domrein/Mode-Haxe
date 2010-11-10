package com.adamatomic.mode;

import flash.geom.Point;

import org.flixel.FlxSprite;
import org.flixel.FlxEmitter;
import org.flixel.FlxG;
import org.flixel.FlxU;
import org.flixel.FlxPoint;
import org.flixel.FlxObject;

import flash.display.Bitmap;
import flash.display.BitmapData;

class Bot extends FlxSprite {
	//[Embed(source="../../../data/bot.png")] private var ImgBot:Class;
	//[Embed(source="../../../data/jet.png")] private var ImgJet:Class;
	//[Embed(source="../../../data/asplode.mp3")] private var SndExplode:Class;
	//[Embed(source="../../../data/hit.mp3")] private var SndHit:Class;
	//[Embed(source="../../../data/jet.mp3")] private var SndJet:Class;
	
	private var _gibs:FlxEmitter;
	private var _jets:FlxEmitter;
	private var _player:Player;
	private var _timer:Float;
	private var _b:Array<BotBullet>;
	static private var _cb:Int = 0;
	private var _shotClock:Float;
	
	public function new(xPos:Int,yPos:Int,Bullets:Array<BotBullet>,Gibs:FlxEmitter,ThePlayer:Player)
	{
		super(xPos,yPos);
		loadRotatedGraphic(ImgBot,32,0);
		_player = ThePlayer;
		_b = Bullets;
		_gibs = Gibs;
		
		width = 12;
		height = 12;
		offset.x = 2;
		offset.y = 2;
		maxAngular = 120;
		angularDrag = 400;
		maxThrust = 100;
		drag.x = 80;
		drag.y = 80;
		
		//Jet effect that shoots out from behind the bot
		_jets = new FlxEmitter();
		_jets.setRotation();
		_jets.gravity = 0;
		_jets.createSprites(ImgJet,15,0,false);

		reset(x,y);
	}
	
	override public function update():Void
	{			
		var ot:Float = _timer;
		//if((_timer == 0) && onScreen()) FlxG.play(SndJet); //TODO: get sound embedding/playing correctly
		_timer += FlxG.elapsed;
		if((ot < 8) && (_timer >= 8))
			_jets.stop(0.1);

		//Aiming
		var dx:Float = x-_player.x;
		var dy:Float = y-_player.y;
		var da:Float = FlxU.getAngle(dx,dy);
		if(da < 0)
			da += 360;
		var ac:Float = angle;
		if(ac < 0)
			ac += 360;
		if(da < angle)
			angularAcceleration = -angularDrag;
		else if(da > angle)
			angularAcceleration = angularDrag;
		else
			angularAcceleration = 0;

		//Jets
		thrust = 0;
		if(_timer > 9)
			_timer = 0;
		else if(_timer < 8)
		{
			thrust = 40;
			var v:FlxPoint = FlxU.rotatePoint(thrust,0,0,0,angle);
			_jets.at(this);
			_jets.setXSpeed(v.x-30,v.x+30);
			_jets.setYSpeed(v.y-30,v.y+30);
			if(!_jets.on)
				_jets.start(false,0.01,0);
		}

		//Shooting
		if(onScreen())
		{
			var os:Float = _shotClock;
			_shotClock += FlxG.elapsed;
			if((os < 4.0) && (_shotClock >= 4.0))
			{
				_shotClock = 0;
				shoot();
			}
			else if((os < 3.5) && (_shotClock >= 3.5))
				shoot();
			else if((os < 3.0) && (_shotClock >= 3.0))
				shoot();
		}
		
		_jets.update();
		super.update();
	}
	
	override public function render():Void
	{
		_jets.render();
		super.render();
	}
	
	override public function hurt(Damage:Float):Void
	{
		//FlxG.play(SndHit); //TODO: get sounds embedding/playing correctly
		flicker(0.2);
		FlxG.score += 10;
		super.hurt(Damage);
	}
	
	override public function kill():Void
	{
		if(dead)
			return;
		//FlxG.play(SndExplode); //TODO: get sounds embedding/playing correctly
		super.kill();
		flicker(-1);
		_jets.kill();
		_gibs.at(this);
		_gibs.start(true,0,20);
		FlxG.score += 200;
	}
	
	override public function reset(X:Float, Y:Float):Void
	{
		super.reset(X,Y);
		thrust = 0;
		velocity.x = 0;
		velocity.y = 0;
		angle = Math.random()*360 - 180;
		health = 2;
		_timer = 0;
		_shotClock = 0;
	}
	
	private function shoot():Void
	{
		var ba:FlxPoint = FlxU.rotatePoint(-120,0,0,0,angle);
		_b[_cb].shoot(Math.floor(x+width/2-2),Math.floor(y+height/2-2),Math.floor(ba.x),Math.floor(ba.y));
		if(++_cb >= _b.length) _cb = 0;
	}
}
