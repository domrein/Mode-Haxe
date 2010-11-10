package ;

import flash.Lib;
import flash.text.TextField;
import flash.display.BitmapData;
import flash.display.Bitmap;
#if flash
#else
import flash.display.FPS;
#end

/**
 * ...
 * @author Paul Milham
 */

class Main {
	public static var debugTextField:TextField;
	
	public function new() {
		debugTextField = new TextField();
		debugTextField.width = 320;
		debugTextField.height = 480;
		debugTextField.text = "";
		debugTextField.textColor = 0xFFFFFF;
		
		flash.Lib.current.addChild(new Mode());
		#if flash9
		#else
		flash.Lib.current.addChild(new FPS(5, 5, 0xFFFFFF));
		#end
		flash.Lib.current.addChild(debugTextField);
	}
	
	public static function main() {
		#if flash9
		new Main();
		#elseif iphone
		new Main();
		#elseif cpp
		Lib.create(function(){new Main();},640,480,60,0xccccff,(1*Lib.HARDWARE) | Lib.RESIZABLE);
		#end
	}
}