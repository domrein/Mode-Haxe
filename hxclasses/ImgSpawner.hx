package ;

import flash.display.Bitmap;
import flash.display.BitmapData;

#if flash9
class ImgSpawner extends Bitmap{public function new(){super();}}
#elseif iphone
class ImgSpawner extends Bitmap{public function new(){super(BitmapData.load("spawner.png"));}}
#elseif cpp
class ImgSpawner extends Bitmap{public function new(){super(BitmapData.load("/Users/pmilham/Dropbox/Projects/XCode/Flixel/haxe/data/spawner.png"));}}
#end
