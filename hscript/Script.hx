package hscript;
import hscript.Parser;
import hscript.Interp;

class Script
{
	public static var parser:Parser = new Parser();
	public var interp:Interp;

	public var variables(get, never):Map<String, Dynamic>;
	inline function get_variables():Map<String, Dynamic>
		return interp.variables;

	public function new():Void
	{
		interp  = new Interp();
	}

	public function dispose():Void
	{
		interp.variables.clear();
		interp.variables = null;
		interp = null;
	}

	public function executeString(code:String = ""):Dynamic
	{
		if (code.length <= 0)
			return null;
		
		parser.line = 1;
		parser.allowTypes = true;
		parser.allowJSON = true;
		parser.allowMetadata = true;
		
		return interp.execute(parser.parseString(code));
	}

	inline public function set(varName:String, varValue:Dynamic):Void
	{
		interp.setVar(varName, varValue);
	}

	inline public function get(field:String):Dynamic
	{
		return variables.get(field);
	}

	inline public function exists(field:String):Bool
	{
		return variables.exists(field);
	}

	public function call(method:String, ?args:Array<Dynamic>):Dynamic
	{
		final method:Dynamic = get(method);

		if (method != null)
		{
            if (args == null)
            {
                return method();
            }

			return switch (args.length)
            {                
                case 0: method();
                case 1: method(args[0]);
                case 2: method(args[0], args[1]);
                case 3: method(args[0], args[1], args[2]);
                case 4: method(args[0], args[1], args[2], args[3]);
                case 5: method(args[0], args[1], args[2], args[3], args[4]);
                default: Reflect.callMethod(null, method, args);
            }
		}
        
        return null;
	}
}