package com.adamatomic.mode;

import org.flixel.FlxSprite;
import org.flixel.FlxObject;
import org.flixel.FlxG;

import flash.display.Bitmap;
import flash.display.BitmapData;

class BotBullet extends FlxSprite {
	//[Embed(source="../../../data/bot_bullet.png")] private var ImgBullet:Class;
	//[Embed(source="../../../data/jump.mp3")] private var SndHit:Class;
	//[Embed(source="../../../data/enemy.mp3")] private var SndShoot:Class;
	
	public function new()
	{
		super();
		loadGraphic(ImgBotBullet,true);
		addAnimation("idle",[0, 1], 50);
		addAnimation("poof",[2, 3, 4], 50, false);
		exists = false;
	}
	
	override public function update():Void
	{
		if(dead && finished) exists = false;
		else super.update();
	}

	override public function hitLeft(Contact:FlxObject,Velocity:Float):Void { kill(); }
	override public function hitRight(Contact:FlxObject,Velocity:Float):Void { kill(); }
	override public function hitBottom(Contact:FlxObject,Velocity:Float):Void { kill(); }
	override public function hitTop(Contact:FlxObject,Velocity:Float):Void { kill(); }
	override public function kill():Void
	{
		if(dead) return;
		velocity.x = 0;
		velocity.y = 0;
		//if(onScreen()) FlxG.play(SndHit); //TODO: get sound embedding/playing correctly
		dead = true;
		solid = false;
		play("poof");
	}
	
	public function shoot(X:Int, Y:Int, VelocityX:Int, VelocityY:Int):Void
	{
		//FlxG.play(SndShoot,0.5); //TODO: get sound embedding/playing correctly
		super.reset(X,Y);
		solid = true;
		velocity.x = VelocityX;
		velocity.y = VelocityY;
		play("idle");
	}
}
