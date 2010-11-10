package ;

import flash.display.Bitmap;
import flash.display.BitmapData;

#if flash9
class ImgNotch extends Bitmap{public function new(){super();}}
#elseif iphone
class ImgNotch extends Bitmap{public function new(){super(BitmapData.load("notch.png"));}}
#elseif cpp
class ImgNotch extends Bitmap{public function new(){super(BitmapData.load("/Users/pmilham/Dropbox/Projects/XCode/Flixel/haxe/data/notch.png"));}}
#end
