package com.adamatomic.mode;

import org.flixel.FlxSprite;
import org.flixel.FlxGroup;
import org.flixel.FlxEmitter;
import org.flixel.FlxG;

import flash.display.Bitmap;
import flash.display.BitmapData;

private class ImgSpawner extends Bitmap{public function new(){super(BitmapData.load("/Users/pmilham/Dropbox/Projects/XCode/Flixel/haxe/data/spawner.png"));}}

class Spawner extends FlxSprite {
	//[Embed(source="../../../data/spawner.png")] private var ImgSpawner:Class;
	//[Embed(source="../../../data/asplode.mp3")] private var SndExplode:Class;
	//[Embed(source="../../../data/menu_hit_2.mp3")] private var SndExplode2:Class;
	//[Embed(source="../../../data/hit.mp3")] private var SndHit:Class;
	
	private var _timer:Float;
	private var _bots:FlxGroup;
	private var _botBullets:Array<Dynamic>;
	private var _botGibs:FlxEmitter;
	private var _gibs:FlxEmitter;
	private var _player:Player;
	private var _open:Bool;
	
	public function new(X:Int, Y:Int,Gibs:FlxEmitter,Bots:FlxGroup,BotBullets:Array<Dynamic>,BotGibs:FlxEmitter,ThePlayer:Player)
	{
		super(X,Y);
		loadGraphic(ImgSpawner,true);
		_gibs = Gibs;
		_bots = Bots;
		_botBullets = BotBullets;
		_botGibs = BotGibs;
		_player = ThePlayer;
		_timer = Math.random()*20;
		_open = false;
		health = 8;

		addAnimation("open", [1, 2, 3, 4, 5], 40, false);
		addAnimation("close", [4, 3, 2, 1, 0], 40, false);
		addAnimation("dead", [6]);
	}
	
	override public function update():Void
	{
		_timer += FlxG.elapsed;
		var limit:Int = 20;
		if(onScreen())
			limit = 4;
		if(_timer > limit)
		{
			_timer = 0;
			makeBot();
		}
		else if(_timer > limit - 0.35)
		{
			if(!_open)
			{
				_open = true;
				play("open");
			}
		}
		else if(_timer > 1)
		{
			if(_open)
			{
				play("close");
				_open = false;
			}
		}
			
		super.update();
	}
	
	override public function hurt(Damage:Float):Void
	{
		//FlxG.play(SndHit); //TODO: get sounds embedding/playing correctly
		flicker(0.2);
		FlxG.score += 50;
		super.hurt(Damage);
	}
	
	override public function kill():Void
	{
		if(dead)
			return;
		//FlxG.play(SndExplode); //TODO: get sounds embedding/playing correctly
		//FlxG.play(SndExplode2); //TODO: get sounds embedding/playing correctly
		super.kill();
		active = false;
		exists = true;
		solid = false;
		flicker(-1);
		play("dead");
		FlxG.quake.start(0.005,0.35);
		FlxG.flash.start(0xffd8eba2,0.35);
		makeBot();
		_gibs.at(this);
		_gibs.start(true,3,0);
		FlxG.score += 1000;
	}
	
	private function makeBot():Void
	{
		//Try to recycle a dead bot
		if(_bots.resetFirstAvail(Math.floor(x + width/2 - 6), Math.floor(y + height/2 - 6)))
			return;
		
		//If there weren't any non-existent ones to respawn, just add a new one instead
		var bot:Bot = new Bot(Math.floor(x + width/2), Math.floor(y + height/2), _botBullets, _botGibs, _player);
		bot.x -= bot.width/2;
		bot.y -= bot.height/2;
		_bots.add(bot);
	}
}
