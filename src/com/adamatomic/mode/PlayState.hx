package com.adamatomic.mode;

import org.flixel.FlxState;
import org.flixel.FlxGroup;
import org.flixel.FlxEmitter;
import org.flixel.FlxText;
import org.flixel.FlxSprite;
import org.flixel.FlxObject;
import org.flixel.FlxG;
import org.flixel.FlxU;
import org.flixel.FlxTileBlock;
import org.flixel.FlxPoint;

import flash.display.Bitmap;
import flash.display.BitmapData;

private class ImgTech extends Bitmap{public function new(){super(BitmapData.load("/Users/pmilham/Dropbox/Projects/XCode/Flixel/haxe/data/tech_tiles.png"));}}
private class ImgDirtTop extends Bitmap{public function new(){super(BitmapData.load("/Users/pmilham/Dropbox/Projects/XCode/Flixel/haxe/data/dirt_top.png"));}}
private class ImgDirt extends Bitmap{public function new(){super(BitmapData.load("/Users/pmilham/Dropbox/Projects/XCode/Flixel/haxe/data/dirt.png"));}}
private class ImgNotch extends Bitmap{public function new(){super(BitmapData.load("/Users/pmilham/Dropbox/Projects/XCode/Flixel/haxe/data/notch.png"));}}
private class ImgGibs extends Bitmap{public function new(){super(BitmapData.load("/Users/pmilham/Dropbox/Projects/XCode/Flixel/haxe/data/gibs.png"));}}
private class ImgSpawnerGibs extends Bitmap{public function new(){super(BitmapData.load("/Users/pmilham/Dropbox/Projects/XCode/Flixel/haxe/data/spawner_gibs.png"));}}

class PlayState extends FlxState
{
	//[Embed(source="../../../data/tech_tiles.png")] private var ImgTech:Class;
	//[Embed(source="../../../data/dirt_top.png")] private var ImgDirtTop:Class;
	//[Embed(source="../../../data/dirt.png")] private var ImgDirt:Class;
	//[Embed(source="../../../data/notch.png")] private var ImgNotch:Class;
	//[Embed(source="../../../data/mode.mp3")] private var SndMode:Class;
	//[Embed(source="../../../data/countdown.mp3")] private var SndCount:Class;
	//[Embed(source="../../../data/gibs.png")] private var ImgGibs:Class;
	//[Embed(source="../../../data/spawner_gibs.png")] private var ImgSpawnerGibs:Class;
	
	//major game objects
	private var _blocks:FlxGroup;
	private var _decorations:FlxGroup;
	private var _bullets:FlxGroup;
	private var _player:Player;
	private var _bots:FlxGroup;
	private var _spawners:FlxGroup;
	private var _botBullets:FlxGroup;
	private var _littleGibs:FlxEmitter;
	private var _bigGibs:FlxEmitter;
	
	//meta groups, to help speed up collisions
	private var _objects:FlxGroup;
	private var _enemies:FlxGroup;
	
	//HUD
	private var _score:FlxText;
	private var _score2:FlxText;
	private var _scoreTimer:Float;
	private var _jamTimer:Float;
	private var _jamBar:FlxSprite;
	private var _jamText:FlxText;
	private var _notches:Array<Dynamic>;
	
	//just to prevent weirdness during level transition
	private var _fading:Bool;
	
	//used to safely reload the playstate after dying
	public var reload:Bool;
	
	override public function create():Void
	{
		FlxG.mouse.hide();
		reload = false;
		
		//get the gibs set up and out of the way
		_littleGibs = new FlxEmitter();
		_littleGibs.delay = 3;
		_littleGibs.setXSpeed(-150,150);
		_littleGibs.setYSpeed(-200,0);
		_littleGibs.setRotation(-720,-720);
		_littleGibs.createSprites(ImgGibs,100,10,true,0);
		//_littleGibs.createSprites(ImgGibs,100,10,true,0.5,0.65);
		_bigGibs = new FlxEmitter();
		_bigGibs.setXSpeed(-200,200);
		_bigGibs.setYSpeed(-300,0);
		_bigGibs.setRotation(-720,-720);
		_bigGibs.createSprites(ImgSpawnerGibs,50,20,true,0);
		//_bigGibs.createSprites(ImgSpawnerGibs,50,20,true,0.5,0.35);
		
		//level generation needs to know about the spawners (and thusly the bots, players, etc)
		_blocks = new FlxGroup();
		_decorations = new FlxGroup();
		_bullets = new FlxGroup();
		_player = new Player(316,300,_bullets.members,_littleGibs);
		_bots = new FlxGroup();
		_botBullets = new FlxGroup();
		_spawners = new FlxGroup();
		
		//simple procedural level generation
		var i:Int;
		var r:Int = 160;
		var b:FlxTileblock;
		
		b = new FlxTileblock(0,0,640,16);
		b.loadGraphic(ImgTech);
		_blocks.add(b);
		
		b = new FlxTileblock(0,16,16,640-16);
		b.loadGraphic(ImgTech);
		_blocks.add(b);
		
		b = new FlxTileblock(640-16,16,16,640-16);
		b.loadGraphic(ImgTech);
		_blocks.add(b);
		
		b = new FlxTileblock(16,640-24,640-32,8);
		b.loadGraphic(ImgDirtTop);
		_blocks.add(b);
		
		b = new FlxTileblock(16,640-16,640-32,16);
		b.loadGraphic(ImgDirt);
		_blocks.add(b);
		
		buildRoom(r*0,r*0,true);
		buildRoom(r*1,r*0);
		buildRoom(r*2,r*0);
		buildRoom(r*3,r*0,true);
		buildRoom(r*0,r*1,true);
		buildRoom(r*1,r*1);
		buildRoom(r*2,r*1);
		buildRoom(r*3,r*1,true);
		buildRoom(r*0,r*2);
		buildRoom(r*1,r*2);
		buildRoom(r*2,r*2);
		buildRoom(r*3,r*2);
		buildRoom(r*0,r*3,true);
		buildRoom(r*1,r*3);
		buildRoom(r*2,r*3);
		buildRoom(r*3,r*3,true);
		
		//Add bots and spawners after we add blocks to the state,
		// so that they're drawn on top of the level, and so that
		// the bots are drawn on top of both the blocks + the spawners.
		add(_spawners);
		add(_littleGibs);
		add(_bigGibs);
		add(_blocks);
		add(_decorations);
		add(_bots);
		
		//actually create the bullets now
		for (i in 0 ... 50)
			_botBullets.add(new BotBullet());
		for (i in 0 ... 8)
			_bullets.add(new Bullet());

		//add player and set up scrolling camera
		add(_player);
		FlxG.follow(_player,2.5);
		FlxG.followAdjust(0.5,0.0);
		FlxG.followBounds(0,0,640,640);
		
		//add gibs + bullets to scene here, so they're drawn on top of pretty much everything
		add(_botBullets);
		add(_bullets);
		
		//finally we are going to sort things into a couple of helper groups.
		//we don't add these to the state, we just use them for collisions later!
		_enemies = new FlxGroup();
		_enemies.add(_botBullets);
		_enemies.add(_spawners);
		_enemies.add(_bots);
		_objects = new FlxGroup();
		_objects.add(_botBullets);
		_objects.add(_bullets);
		_objects.add(_bots);
		_objects.add(_player);
		_objects.add(_littleGibs);
		_objects.add(_bigGibs);
		
		//HUD - score
		var ssf:FlxPoint = new FlxPoint(0,0);
		_score = new FlxText(0,0,FlxG.width);
		_score.color = 0xd8eba2;
		_score.size = 16;
		_score.alignment = "center";
		_score.scrollFactor = ssf;
		_score.shadow = 0x131c1b;
		add(_score);
		if(FlxG.scores.length < 2)
		{
			FlxG.scores.push(0);
			FlxG.scores.push(0);
		}
		
		//HUD - highest and last scores
		_score2 = new FlxText(FlxG.width/2,0,Math.floor(FlxG.width/2));
		_score2.color = 0xd8eba2;
		_score2.alignment = "right";
		_score2.scrollFactor = ssf;
		_score2.shadow = _score.shadow;
		add(_score2);
		if(FlxG.score > FlxG.scores[0])
			FlxG.scores[0] = FlxG.score;
		if(FlxG.scores[0] != 0)
			_score2.text = "HIGHEST: "+FlxG.scores[0]+"\nLAST: "+FlxG.score;
		FlxG.score = 0;
		_scoreTimer = 0;
		
		//HUD - the "number of spawns left" icons
		_notches = new Array();
		var tmp:FlxSprite;
		for (i in 0 ... 6) {
			tmp = new FlxSprite(4+i*10,4);
			tmp.loadGraphic(ImgNotch,true);
			tmp.scrollFactor.x = tmp.scrollFactor.y = 0;
			tmp.addAnimation("on",[0]);
			tmp.addAnimation("off",[1]);
			tmp.moves = false;
			tmp.solid = false;
			tmp.play("on");
			_notches.push(this.add(tmp));
		}
		
		//HUD - the "gun jammed" notification
		_jamBar = cast this.add((new FlxSprite(0,FlxG.height-22)).createGraphic(FlxG.width,24,0xff131c1b));
		_jamBar.scrollFactor.x = _jamBar.scrollFactor.y = 0;
		_jamBar.visible = false;
		_jamText = new FlxText(0,FlxG.height-22,FlxG.width,"GUN IS JAMMED");
		_jamText.color = 0xd8eba2;
		_jamText.size = 16;
		_jamText.alignment = "center";
		_jamText.scrollFactor = ssf;
		_jamText.visible = false;
		add(_jamText);
		
		//FlxG.playMusic(SndMode); //TODO: get sounds embedding/playing correctly
		FlxG.flash.start(0xff131c1b);
		_fading = false;
	}

	override public function update():Void
	{
		var os:Int = FlxG.score;
		
		super.update();
		
		//collisions with environment
		FlxU.collide(_blocks,_objects);
		FlxU.overlap(_enemies,_player,overlapped);
		FlxU.overlap(_bullets,_enemies,overlapped);
		
		//Jammed message
		if(FlxG.keys.justPressed("C") && _player.flickering())
		{
			_jamTimer = 1;
			_jamBar.visible = true;
			_jamText.visible = true;
		}
		if(_jamTimer > 0)
		{
			if(!_player.flickering()) _jamTimer = 0;
			_jamTimer -= FlxG.elapsed;
			if(_jamTimer < 0)
			{
				_jamBar.visible = false;
				_jamText.visible = false;
			}
		}

		if(!_fading)
		{
			//Score + countdown stuffs
			if(os != FlxG.score) _scoreTimer = 2;
			_scoreTimer -= FlxG.elapsed;
			if(_scoreTimer < 0)
			{
				if(FlxG.score > 0) 
				{
					//FlxG.play(SndCount); //TODO: get sounds embedding/playing correctly
					if(FlxG.score > 100) FlxG.score -= 100;
					else { FlxG.score = 0; _player.kill(); }
					_scoreTimer = 1;
					//if(FlxG.score < 600)
					//	FlxG.play(SndCount); //TODO: get sounds embedding/playing correctly
					//if(FlxG.score < 500)
					//	FlxG.play(SndCount); //TODO: get sounds embedding/playing correctly
					//if(FlxG.score < 400)
					//	FlxG.play(SndCount); //TODO: get sounds embedding/playing correctly
					//if(FlxG.score < 300)
					//	FlxG.play(SndCount); //TODO: get sounds embedding/playing correctly
					//if(FlxG.score < 200)
					//	FlxG.play(SndCount); //TODO: get sounds embedding/playing correctly
				}
			}
		
			//Fade out to victory screen stuffs
			var spawnerCount:Int = _spawners.countLiving();
			if(spawnerCount <= 0)
			{
				_fading = true;
				FlxG.fade.start(0xffd8eba2,3,onVictory);
			}
			else
			{
				var l:Int = _notches.length;
				for (i in 0 ... l) {
					if(i < spawnerCount)
						_notches[i].play("on");
					else
						_notches[i].play("off");
				}
			}
		}
		
		//actually update score text if it changed
		if(os != FlxG.score)
		{
			if(_player.dead) FlxG.score = 0;
			_score.text = "" + FlxG.score;
		}
		
		if(reload)
			FlxG.state = new PlayState();
		
		//Toggle the bounding box visibility
		if(FlxG.keys.justPressed("B"))
			FlxG.showBounds = !FlxG.showBounds;
	}

	private function overlapped(Object1:FlxObject,Object2:FlxObject):Void
	{
		if(Std.is(Object1, BotBullet) || Std.is(Object1, Bullet))
			Object1.kill();
		Object2.hurt(1);
	}
	
	private function onVictory():Void
	{
		FlxG.music.stop();
		FlxG.state = new VictoryState();
	}
	
	//Just plops down a spawner and some blocks - haphazard and crappy atm but functional!
	private function buildRoom(RX:Int,RY:Int,Spawners:Bool=false):Void
	{
		//first place the spawn point (if necessary)
		var rw:Int = 20;
		var sx:Int = 0;
		var sy:Int = 0;
		if(Spawners)
		{
			sx = Math.floor(2+FlxU.random()*(rw-7));
			sy = Math.floor(2+FlxU.random()*(rw-7));
		}
		
		//then place a bunch of blocks
		var numBlocks:Int = Math.floor(3+FlxU.random()*4);
		if(!Spawners) numBlocks++;
		var maxW:Int = 10;
		var minW:Int = 2;
		var maxH:Int = 8;
		var minH:Int = 1;
		var bx:Int;
		var by:Int;
		var bw:Int;
		var bh:Int;
		var check:Bool;
		for (i in 0 ... numBlocks) {
			check = false;
			do
			{
				//keep generating different specs if they overlap the spawner
				bw = Math.floor(minW + FlxU.random()*(maxW-minW));
				bh = Math.floor(minH + FlxU.random()*(maxH-minH));
				bx = Math.floor(-1 + FlxU.random()*(rw+1-bw));
				by = Math.floor(-1 + FlxU.random()*(rw+1-bh));
				if(Spawners)
					check = ((sx>bx+bw) || (sx+3<bx) || (sy>by+bh) || (sy+3<by));
				else
					check = true;
			} while(!check);
			
			var b:FlxTileblock;
			
			b = new FlxTileblock(RX+bx*8,RY+by*8,bw*8,bh*8);
			b.loadGraphic(ImgTech);
			_blocks.add(b);
			
			//If the block has room, add some non-colliding "dirt" graphics for variety
			if((bw >= 4) && (bh >= 5))
			{
				b = new FlxTileblock(RX+bx*8+8,RY+by*8,bw*8-16,8);
				b.loadGraphic(ImgDirtTop);
				_decorations.add(b);
				
				b = new FlxTileblock(RX+bx*8+8,RY+by*8+8,bw*8-16,bh*8-24);
				b.loadGraphic(ImgDirt);
				_decorations.add(b);
			}
		}
		
		//Finally actually add the spawner
		if(Spawners)
			_spawners.add(new Spawner(RX+sx*8,RY+sy*8,_bigGibs,_bots,_botBullets.members,_littleGibs,_player));
	}
}
