package handlers;

import flixel.util.FlxColor;
import openfl.Assets;
import haxe.Json;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import handlers.CoolUtil;

using StringTools;

typedef CharJson = {
	var Img:String;

	var idleAnim:String;
	var idleLeftAnim:String;
	var idleRightAnim:String;
	var upAnim:String;
	var downAnim:String;
	var leftAnim:String;
	var rightAnim:String;
	var hpColor:String;
	var hpIcon:String;
	var gfDance:Bool;
	var flipX:Bool;
	var flipY:Bool;
	var x:Float;
	var y:Float;
	var camX:Float;
	var camY:Float;
	var isGfChar:Bool;
}

class Character extends FlxSprite {
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';
	public var specialAnim = false;

	public var hpColor:FlxColor = FlxColor.RED;
	public var char:CharJson;
	public var healthIcon:String;

	public var gfDance:Bool;
	public var isGfChar:Bool;

	public var camX:Float;
	public var camY:Float;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false) {
		animOffsets = new Map<String, Array<Dynamic>>();
		super(x, y);

		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = true;

		switch (curCharacter) {
			case 'gf':
				// GIRLFRIEND CODE
				tex = FlxAtlasFrames.fromSparrow('assets/images/GF_assets.png', 'assets/images/GF_assets.xml');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);

				addOffset('scared');

				playAnim('danceRight');

				healthIcon = 'icons/icon-gf';

				gfDance = true;
				isGfChar = true;

			case 'monster':
				tex = FlxAtlasFrames.fromSparrow('assets/images/Monster_Assets.png', 'assets/images/Monster_Assets.xml');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle');
				addOffset("singUP", -20, 50);
				addOffset("singRIGHT", -51);
				addOffset("singLEFT", -30);
				addOffset("singDOWN", -30, -40);
				playAnim('idle');

				healthIcon = 'icons/icon-monster';
			case 'bf':
				var tex = FlxAtlasFrames.fromSparrow('assets/images/BOYFRIEND.png', 'assets/images/BOYFRIEND.xml');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);
				playAnim('idle');

				antialiasing = true;

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -4);
			default:
				if (Assets.exists('assets/images/characters/$curCharacter/data.json')) {
					char = loadCharFromJson('data', curCharacter);

					tex = FlxAtlasFrames.fromSparrow('assets/images/characters/$curCharacter/${char.Img}.png',
						'assets/images/characters/$curCharacter/${char.Img}.xml');
					frames = tex;

					if (char.gfDance) {
						animation.addByPrefix('danceLeft', char.idleLeftAnim, 24);
						animation.addByPrefix('danceRight', char.idleRightAnim, 24);
					} else
						animation.addByPrefix('idle', char.idleAnim, 24);

					animation.addByPrefix('singUP', char.upAnim, 24);
					animation.addByPrefix('singRIGHT', char.rightAnim, 24);
					animation.addByPrefix('singDOWN', char.downAnim, 24);
					animation.addByPrefix('singLEFT', char.leftAnim, 24);

					if (!char.gfDance)
						playAnim('idle');
					else
						playAnim('danceLeft');

					if (char.hpColor != null)
						hpColor = FlxColor.fromString(char.hpColor);

					if (Assets.exists('assets/images/characters/$curCharacter/offsets.txt'))
						loadOffsetFile('offsets');

					gfDance = char.gfDance;

					healthIcon = char.hpIcon;

					flipX = char.flipX;
					flipY = char.flipY;

					this.y += char.y;
					this.x += char.x;

					this.camX = char.camX;
					this.camY = char.camY;
				} else {
					tex = FlxAtlasFrames.fromSparrow('assets/images/DADDY_DEAREST.png', 'assets/images/DADDY_DEAREST.xml');
					frames = tex;
					animation.addByPrefix('idle', 'Dad idle dance', 24);
					animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
					animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
					animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
					animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);
					playAnim('idle');

					addOffset('idle');
					addOffset("singUP", -6, 50);
					addOffset("singRIGHT", 0, 27);
					addOffset("singLEFT", -10, 10);
					addOffset("singDOWN", 0, -30);
				}
		}

		if (healthIcon == null)
			healthIcon = 'icons/icon-$curCharacter';
	}

	private var danced:Bool = false;

	public function dance() {
		if (!debugMode) {
			danced = !danced;

			if (gfDance) {
				if (danced)
					playAnim('danceRight');
				else
					playAnim('danceLeft');
			} else
				playAnim('idle');
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, ?specialAnim:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void {
		this.specialAnim = specialAnim;
		if (animation.exists(AnimName)) {
			animation.play(AnimName, Force, Reversed, Frame);

			var daOffset = animOffsets.get(animation.curAnim.name);
			if (animOffsets.exists(animation.curAnim.name)) {
				offset.set(daOffset[0], daOffset[1]);
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0) {
		animOffsets[name] = [x, y];
	}

	public static function loadCharFromJson(jsonInput:String, ?folder:String):CharJson {
		var rawJson = Assets.getText('assets/images/characters/' + folder.toLowerCase() + '/' + jsonInput.toLowerCase() + '.json').trim();

		while (!rawJson.endsWith("}")) {
			rawJson = rawJson.substr(0, rawJson.length - 1);
		}

		var swagShit:CharJson = cast Json.parse(rawJson);
		return swagShit;
	}

	private function loadOffsetFile(offsetCharacter:String) {
		var daFile:Array<String> = CoolUtil.loadText('assets/images/characters/$curCharacter/offsets.txt');

		for (i in daFile) {
			var splitWords:Array<String> = i.split(" ");
			addOffset(splitWords[0], Std.parseInt(splitWords[1]), Std.parseInt(splitWords[2]));

			trace(splitWords);
		}
	}
}
