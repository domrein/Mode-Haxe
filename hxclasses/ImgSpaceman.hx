package ;

import flash.display.Bitmap;
import flash.display.BitmapData;

#if flash9
class ImgSpaceman extends Bitmap{public function new(){super();}}
#elseif iphone
class ImgSpaceman extends Bitmap{public function new(){super(BitmapData.load("spaceman.png"));}}
#elseif cpp
class ImgSpaceman extends Bitmap{public function new(){super(BitmapData.load("/Users/pmilham/Dropbox/Projects/XCode/Flixel/haxe/data/spaceman.png"));}}
#end
