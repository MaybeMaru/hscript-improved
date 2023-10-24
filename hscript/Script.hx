package hscript;
import hscript.Parser;
import hscript.Interp;

class Script {
    public static var parser:Parser = new Parser();
	public var interp:Interp;
    public var variables(get, never):Map<String, Dynamic>;
	public function get_variables() return interp.variables;

    public function new() {
        interp  = new Interp();
    }

    public function executeString(code:String = "") {
        if (code.length <= 0) return null;
		parser.line = 1;
		parser.allowTypes = true;
        parser.allowJSON = true;
        parser.allowMetadata = true;
		return interp.execute(parser.parseString(code));
    }

	inline public function set(varName:String, varValue:Dynamic):Void {
		interp.setVar(varName, varValue);
	}

	inline public function get(field:String):Dynamic {
		return interp.variables.get(field);
	}

	inline public function exists(field:String):Bool {
		return interp.variables.exists(field);
	}

    inline public function call(method:String, ?args:Array<Dynamic>):Dynamic {
        if (!exists(method)) return null;
        return Reflect.callMethod(this, get(method), args == null ? [] : args);
	}
}