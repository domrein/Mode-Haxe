package ;

import flash.display.Bitmap;
import flash.display.BitmapData;

#if flash9
class ImgGibs extends Bitmap{public function new(){super();}}
#elseif iphone
class ImgGibs extends Bitmap{public function new(){super(BitmapData.load("gibs.png"));}}
#elseif cpp
class ImgGibs extends Bitmap{public function new(){super(BitmapData.load("/Users/pmilham/Dropbox/Projects/XCode/Flixel/haxe/data/gibs.png"));}}
#end
