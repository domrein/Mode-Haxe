package ;

import flash.display.Bitmap;
import flash.display.BitmapData;

#if flash9
class ImgBullet extends Bitmap{public function new(){super();}}
#elseif iphone
class ImgBullet extends Bitmap{public function new(){super(BitmapData.load("bullet.png"));}}
#elseif cpp
class ImgBullet extends Bitmap{public function new(){super(BitmapData.load("/Users/pmilham/Dropbox/Projects/XCode/Flixel/haxe/data/bullet.png"));}}
#end
