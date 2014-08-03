-- $Name:Тестовая реализация ТКР-Instead$
-- $Version:1.0.0$

instead_version "1.6.0"

-- stub for older versions
if stead.version < "1.5.3" then
	walk = _G["goto"]
	walkin = goin
	walkout = goout
	walkback = goback
end

-- common modules
require "dbg"
require "xact"
require "hideinv"

-- typography
require "para"
require "dash"
require "quotes"

-- encoding
game.codepage="UTF-8";

-- default reactions, TODO: redefine
game.act = 'Не получается.';
game.inv = 'Гм... Странная штука...';
game.use = 'Не сработает...';

-- Basic TKR things

_vars = {};

function init()
	for i = 1,2000 do
		_vars[i] = false;
	end
end

function checkLogic(logic)
	local result = true;
	for i = 1,#logic do
		local index = logic[i];
		local target = true;
		if index < 0 then
			target = false;
			index = -index;
		end;
		if _vars[index] ~= target then
			result = false;
		end;
	end;
	return result;
end

function setLogic(logic)
	for i = 1,#logic do
		local index = logic[i];
		local target = true;
		if index < 0 then
			target = false;
			index = -index;
		end;
		_vars[index] = target;
	end;
end

showInv = menu {
	nam = 'Инвентарь';
	inv = function()
		p 'У тебя в инвентаре:';
		local count = 0;
		if _vars[4] == true then count=count+1; p '^-- Меч'; end;
		if count == 0 then
			p '^...ничего нет.';
		end;
	end;
};
take(showInv);

showHint = menu {
	nam = 'Подсказки';
	inv = function()
		if checkLogic {-2} then
			p 'Очаровательную принцессу Елену Прекрасную удерживает у себя злобный дракон. Поговорите с ним по душам -- может быть, вам удастся его переубедить?';
		end;
	end;
};
take(showHint);

-- Aaaaand here we go.

main = room {
	nam = 'Ущелье дракона';
	forcedsc = true;
	dsc = function()
		result = '';
		-- get description
		desc = 'Серые, мрачные осенние тучи несутся над проклятым ущельем, подгоняемые неистовым северным ветром.^^Но ты почему-то твердо уверен, что ты сумеешь одолеть коварного дракона и спасти свою любимую. Интересно только, почему...';
		if checkLogic {4} then
			desc = 'Серые, мрачные осенние тучи несутся над проклятым ущельем, подгоняемые неистовым северным ветром. Но у тебя есть меч, поэтому ты пиздат, как Чак Норрис.';
		end;
		-- ok, set it
		result = result.. desc;
		result = result.. '^';
		-- actions
		if checkLogic {-4} then
			result = result.. '^~ {qq1|Взять меч}';
		end;
		if checkLogic {} then
			result = result.. '^~ {qq2|Пощекотать дракону яйца}';
		end;
		if checkLogic {} then
			result = result.. '^~ {qq3|Поговорить с драконом}';
		end;
		-- ok, we're done
		return result;
	end;
	obj = {
		xact('qq1', code [[ setLogic {4}; return 'Ты с гордым видом берёшь в руки меч.'; ]] );
		xact('qq2', code [[ return 'Дракон дико хохочет.'; ]] );
		xact('qq3', code [[ walk(dragondlg); ]] );
	};
};

dragondlg = room {
	nam = 'Душевный разговор с драконом';
	forcedsc = true;
	dsc = function()
		result = '';
		-- get description
		desc = '-- Эй, рыцарь!';
		-- ok, set it
		result = result.. desc;
		result = result.. '^';
		-- actions
		if checkLogic {} then
			result = result.. '^{qq10|-- Дракон, я твой дом труба шатал.}';
		end;
		if checkLogic {} then
			result = result.. '^{qq11|-- Ты кто?}';
		end;
		if checkLogic {-4} then
			result = result.. '^{qq12|-- Дракон, а ты случайно не знаешь, где мой меч? -- спрашиваешь ты.}';
		end;
		-- end dialog
		result = result.. '^~ {exit|Закончить диалог}';
		-- ok, we're done
		return result;
	end;
	obj = {
		xact('qq10', code [[ return '-- А я твой мама вот так-то и вот так-то.'; ]] );
		xact('qq11', code [[ return '-- Ну я дракон, типа. Древний, как говно мамонта, и столь же ужасающий.'; ]] );
		xact('qq12', code [[ return '-- Эх, ну и рыцари пошли в наше время, ха-ха-ха, -- громогласно повторяет дракон, медленно и торжественно разевая свою полутораметровую пасть, -- За своим мечом надо следить. Думаю, ты его уронил где-то тут неподалеку... Вон, кстати, по-моему в кустах что-то блестит...'; ]] );
		xact('exit', code [[ back(); ]] );
	};
};

oldmain = dlg {
	nam = 'Ущелье дракона';
	entered = code [[
p('we are not here!');
_vars[1] = true;
_vars[2] = false;
_vars[3] = true;
p(checkLogic({1,-2,3}));
p(checkLogic({1,-2,-3}));
setLogic {1,-2,-3};
p(checkLogic({1,-2,-3}));
]];
	forcedsc = true;
	dsc = function()
		if checkLogic{2} then return 'Не, всё норм.'; end
		return string.gsub([[    Серые, мрачные осенние тучи несутся над проклятым ущельем, подгоняемые неистовым северным ветром.^^Но ты почему-то твердо уверен, что ты сумеешь одолеть коварного дракона и спасти свою любимую. Интересно только, почему...]], '\n', '^^');
	end;
--	obj = {
--		[1] = phr('Мне вот этих зелененьких... Ага -- и бобов!', 'На здоровье!', [[ pon() ]]);
--		[2] = phr('Картошку с салом, пожалуйста!', 'Приятного аппетита!');
--		[3] = phr('Две порции чесночного супа!!!', 'Прекрасный выбор!');
--		[4] = phr('Мне что-нибудь легонькое, у меня язва...', 'Овсянка!');
--		[5] = phr('Сказать фразу, и пусть она не исчезает!', 'Аминь!', [[ if true then pon(); end ]]);
--		[6] = phr('Сказать фразу, и пусть она исчезнет нахуй!', 'Так точно!', [[ _vars[1] = true; if _vars[1]==false and true then pon(); end ]]);
--		[7] = phr('Взять меч', 'Ну типа взял.', [[ _vars[4] = true; if _vars[4] == false and true then pon(); end; ]]);
--	};
	phr = {
		{ always = true, 'Пыщ-пыщ!', 'Ололо!'};
		{ 'Взять меч', 'Ну типа взял.', code [[
-- set vars
setLogic {4};
-- switch on?
if checkLogic {-4} then pon(); end
]] };
	};
};