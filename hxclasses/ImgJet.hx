package ;

import flash.display.Bitmap;
import flash.display.BitmapData;

#if flash9
class ImgJet extends Bitmap{public function new(){super();}}
#elseif iphone
class ImgJet extends Bitmap{public function new(){super(BitmapData.load("jet.png"));}}
#elseif cpp
class ImgJet extends Bitmap{public function new(){super(BitmapData.load("/Users/pmilham/Dropbox/Projects/XCode/Flixel/haxe/data/jet.png"));}}
#end
