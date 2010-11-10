package ;

import flash.display.Bitmap;
import flash.display.BitmapData;

#if flash9
class ImgSpawnerGibs extends Bitmap{public function new(){super();}}
#elseif iphone
class ImgSpawnerGibs extends Bitmap{public function new(){super(BitmapData.load("spawner_gibs.png"));}}
#elseif cpp
class ImgSpawnerGibs extends Bitmap{public function new(){super(BitmapData.load("/Users/pmilham/Dropbox/Projects/XCode/Flixel/haxe/data/spawner_gibs.png"));}}
#end
