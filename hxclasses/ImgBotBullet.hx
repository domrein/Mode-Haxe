package ;

import flash.display.Bitmap;
import flash.display.BitmapData;

#if flash9
class ImgBotBullet extends Bitmap{public function new(){super();}}
#elseif iphone
class ImgBotBullet extends Bitmap{public function new(){super(BitmapData.load("bot_bullet.png"));}}
#elseif cpp
class ImgBotBullet extends Bitmap{public function new(){super(BitmapData.load("/Users/pmilham/Dropbox/Projects/XCode/Flixel/haxe/data/bot_bullet.png"));}}
#end
