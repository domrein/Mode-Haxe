package ;

import flash.display.Bitmap;
import flash.display.BitmapData;

#if flash9
class ImgDirt extends Bitmap{public function new(){super();}}
#elseif iphone
class ImgDirt extends Bitmap{public function new(){super(BitmapData.load("dirt.png"));}}
#elseif cpp
class ImgDirt extends Bitmap{public function new(){super(BitmapData.load("/Users/pmilham/Dropbox/Projects/XCode/Flixel/haxe/data/dirt.png"));}}
#end
