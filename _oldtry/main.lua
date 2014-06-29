-- $Name: Приключения Андрея Шапкина$
-- $Version: 0.1$
-- $Author: А.Дудченко, m1kc$

instead_version "1.9.1"

require "para" -- красивые отступы;
require "dash" -- замена символов два минуса на тире;
require "quotes" -- замена простых кавычек "" на типографские «»;

require "dbg" -- для отладки

game.codepage = "cp1251";

game.act = 'Что?';
game.use = 'Что?';
game.inv = 'Что?';

function init()
	-- добавим в инвентарь нож и бумагу
	--take('knife');
	--take('paper');
end

main = room {
	nam = [[TKR-INSTEAD]];
	dsc = [[Это интерпретатор квестов в формате Текстово-квестового редактора Александра Дудченко.]];
	obj = { 'button' };
}

button = obj {
	nam = [[Кнопка запуска]];
	dsc = [[Перед вами {кнопка запуска}.]];
	act = function()
		--parse 'data/Room1.txt';
		--walk 'room1';
	end
}
