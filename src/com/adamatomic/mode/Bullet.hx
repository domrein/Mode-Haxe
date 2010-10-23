package com.adamatomic.mode;

import org.flixel.FlxSprite;
import org.flixel.FlxObject;
import org.flixel.FlxG;

import flash.display.Bitmap;
import flash.display.BitmapData;

private class ImgBullet extends Bitmap{public function new(){super(BitmapData.load("/Users/pmilham/Dropbox/Projects/XCode/Flixel/haxe/data/bullet.png"));}}

class Bullet extends FlxSprite {
	//[Embed(source="../../../data/bullet.png")] private var ImgBullet:Class;
	//[Embed(source="../../../data/jump.mp3")] private var SndHit:Class;
	//[Embed(source="../../../data/shoot.mp3")] private var SndShoot:Class;
	
	public function new()
	{
		super();
		loadGraphic(ImgBullet,true);
		width = 6;
		height = 6;
		offset.x = 1;
		offset.y = 1;
		exists = false;
		
		addAnimation("up",[0]);
		addAnimation("down",[1]);
		addAnimation("left",[2]);
		addAnimation("right",[3]);
		addAnimation("poof",[4, 5, 6, 7], 50, false);
	}
	
	override public function update():Void
	{
		if(dead && finished) exists = false;
		else super.update();
	}
	
	override public function render():Void
	{
		super.render();
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
		//FlxG.play(SndShoot); //TODO: get sound embedding/playing correctly
		super.reset(X,Y);
		solid = true;
		velocity.x = VelocityX;
		velocity.y = VelocityY;
		if(velocity.y < 0)
			play("up");
		else if(velocity.y > 0)
			play("down");
		else if(velocity.x < 0)
			play("left");
		else if(velocity.x > 0)
			play("right");
	}
}
