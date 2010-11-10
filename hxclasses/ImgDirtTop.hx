package ;

import flash.display.Bitmap;
import flash.display.BitmapData;

#if flash9
class ImgDirtTop extends Bitmap{public function new(){super();}}
#elseif iphone
class ImgDirtTop extends Bitmap{public function new(){super(BitmapData.load("dirt_top.png"));}}
#elseif cpp
class ImgDirtTop extends Bitmap{public function new(){super(BitmapData.load("/Users/pmilham/Dropbox/Projects/XCode/Flixel/haxe/data/dirt_top.png"));}}
#end
