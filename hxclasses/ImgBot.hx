package ;

import flash.display.Bitmap;
import flash.display.BitmapData;

#if flash9
class ImgBot extends Bitmap{public function new(){super();}}
#elseif iphone
class ImgBot extends Bitmap{public function new(){super(BitmapData.load("bot.png"));}}
#elseif cpp
class ImgBot extends Bitmap{public function new(){super(BitmapData.load("/Users/pmilham/Dropbox/Projects/XCode/Flixel/haxe/data/bot.png"));}}
#end
