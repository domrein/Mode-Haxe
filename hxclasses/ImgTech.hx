package ;

import flash.display.Bitmap;
import flash.display.BitmapData;

#if flash9
class ImgTech extends Bitmap{public function new(){super();}}
#elseif iphone
class ImgTech extends Bitmap{public function new(){super(BitmapData.load("tech_tiles.png"));}}
#elseif cpp
class ImgTech extends Bitmap{public function new(){super(BitmapData.load("/Users/pmilham/Dropbox/Projects/XCode/Flixel/haxe/data/tech_tiles.png"));}}
#end
