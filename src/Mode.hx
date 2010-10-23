package ;

import org.flixel.FlxGame;
import org.flixel.FlxState;

//import com.adamatomic.mode.MenuState;
import com.adamatomic.mode.PlayState;

//[SWF(width="640", height="480", backgroundColor="#000000")]
//[Frame(factoryClass="Preloader")]

class Mode extends FlxGame {
	public function new() {
		super(320,240,PlayState);
		FlxState.bgColor = 0xff131c1b;
		useDefaultHotKeys = true;
	}
}
