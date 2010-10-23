package com.adamatomic.mode;

import org.flixel.FlxSprite;
import org.flixel.FlxEmitter;
import org.flixel.FlxObject;
import org.flixel.FlxG;

import flash.display.Bitmap;
import flash.display.BitmapData;

private class ImgSpaceman extends Bitmap{public function new(){super(BitmapData.load("/Users/pmilham/Dropbox/Projects/XCode/Flixel/haxe/data/spaceman.png"));}}

class Player extends FlxSprite {
	//[Embed(source="../../../data/spaceman.png")] private var ImgSpaceman:Class;
	//[Embed(source="../../../data/jump.mp3")] private var SndJump:Class;
	//[Embed(source="../../../data/land.mp3")] private var SndLand:Class;
	//[Embed(source="../../../data/asplode.mp3")] private var SndExplode:Class;
	//[Embed(source="../../../data/menu_hit_2.mp3")] private var SndExplode2:Class;
	//[Embed(source="../../../data/hurt.mp3")] private var SndHurt:Class;
	//[Embed(source="../../../data/jam.mp3")] private var SndJam:Class;
	
	private var _jumpPower:Int;
	private var _bullets:Array<Dynamic>;
	private var _curBullet:Int;
	private var _bulletVel:Int;
	private var _up:Bool;
	private var _down:Bool;
	private var _restart:Float;
	private var _gibs:FlxEmitter;
	
	public function new(X:Int,Y:Int,Bullets:Array<Dynamic>,Gibs:FlxEmitter)
	{
		super(X,Y);
		loadGraphic(ImgSpaceman,true,true,8);
		_restart = 0;
		
		//bounding box tweaks
		width = 6;
		height = 7;
		offset.x = 1;
		offset.y = 1;
		
		//basic player physics
		var runSpeed:Int = 80;
		drag.x = runSpeed*8;
		acceleration.y = 420;
		_jumpPower = 200;
		maxVelocity.x = runSpeed;
		maxVelocity.y = _jumpPower;
		
		//animations
		addAnimation("idle", [0]);
		addAnimation("run", [1, 2, 3, 0], 12);
		addAnimation("jump", [4]);
		addAnimation("idle_up", [5]);
		addAnimation("run_up", [6, 7, 8, 5], 12);
		addAnimation("jump_up", [9]);
		addAnimation("jump_down", [10]);
		
		//bullet stuff
		_bullets = Bullets;
		_curBullet = 0;
		_bulletVel = 360;
		
		//Gibs emitted upon death
		_gibs = Gibs;
	}
	
	override public function update():Void
	{
		//game restart timer
		if(dead)
		{
			_restart += FlxG.elapsed;
			if(_restart > 2)
				cast(FlxG.state, PlayState).reload = true;
			return;
		}
		
		//MOVEMENT
		acceleration.x = 0;
		if(FlxG.keys.LEFT)
		{
			facing = FlxSprite.LEFT;
			acceleration.x -= drag.x;
		}
		else if(FlxG.keys.RIGHT)
		{
			facing = FlxSprite.RIGHT;
			acceleration.x += drag.x;
		}
		if(FlxG.keys.justPressed("X") && velocity.y == 0)
		{
			velocity.y = -_jumpPower;
			//FlxG.play(SndJump); // TODO: get sound embedding/playing correctly
		}
		
		//AIMING
		_up = false;
		_down = false;
		if(FlxG.keys.UP) _up = true;
		else if(FlxG.keys.DOWN && velocity.y != 0) _down = true;
		
		//ANIMATION
		if(velocity.y != 0)
		{
			if(_up) play("jump_up");
			else if(_down) play("jump_down");
			else play("jump");
		}
		else if(velocity.x == 0)
		{
			if(_up) play("idle_up");
			else play("idle");
		}
		else
		{
			if(_up) play("run_up");
			else play("run");
		}
		
		//SHOOTING
		if(!flickering() && FlxG.keys.justPressed("C"))
		{
			var bXVel:Int = 0;
			var bYVel:Int = 0;
			var bX:Int = Math.floor(x);
			var bY:Int = Math.floor(y);
			if(_up)
			{
				bY -= _bullets[_curBullet].height - 4;
				bYVel = -_bulletVel;
			}
			else if(_down)
			{
				bY += Math.floor(height - 4);
				bYVel = _bulletVel;
				velocity.y -= 36;
			}
			else if(facing == FlxSprite.RIGHT)
			{
				bX += Math.floor(width - 4);
				bXVel = _bulletVel;
			}
			else
			{
				bX -= _bullets[_curBullet].width - 4;
				bXVel = -_bulletVel;
			}
			_bullets[_curBullet].shoot(bX,bY,bXVel,bYVel);
			if(++_curBullet >= _bullets.length)
				_curBullet = 0;
		}
			
		//UPDATE POSITION AND ANIMATION
		super.update();

		//Jammed, can't fire!
		if(flickering())
		{
			//if(FlxG.keys.justPressed("C"))
				//FlxG.play(SndJam); //TODO: get sounds embedding/playing correctly
		}
	}
	
	override public function hitBottom(Contact:FlxObject,Velocity:Float):Void
	{
		//if(velocity.y > 50)
		//	FlxG.play(SndLand); //TODO: get sounds embedding/playing correctly
		onFloor = true;
		return super.hitBottom(Contact,Velocity);
	}
	
	override public function hurt(Damage:Float):Void
	{
		Damage = 0;
		if(flickering())
			return;
		//FlxG.play(SndHurt); //TODO: get sounds embedding/playing correctly
		flicker(1.3);
		if(FlxG.score > 1000) FlxG.score -= 1000;
		if(velocity.x > 0)
			velocity.x = -maxVelocity.x;
		else
			velocity.x = maxVelocity.x;
		super.hurt(Damage);
	}
	
	override public function kill():Void
	{
		if(dead)
			return;
		solid = false;
		//FlxG.play(SndExplode); //TODO: get sounds embedding/playing correctly
		//FlxG.play(SndExplode2); //TODO: get sounds embedding/playing correctly
		super.kill();
		flicker(-1);
		exists = true;
		visible = false;
		FlxG.quake.start(0.005,0.35);
		FlxG.flash.start(0xffd8eba2,0.35);
		if(_gibs != null)
		{
			_gibs.at(this);
			_gibs.start(true,0,50);
		}
	}
}
