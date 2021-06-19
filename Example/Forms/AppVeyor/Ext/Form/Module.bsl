﻿&НаКлиенте
Перем ИдентификаторКомпоненты, HTTPСоединение, НаборТестов;

&НаКлиенте
Перем ЕстьПроблема, ЕстьОшибка, ЕстьОшибкиПроблемы;

#Область СобытияФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	МакетКомпоненты = ОбработкаОбъект.ПолучитьМакет("TesseractOCR1C");
	МестоположениеКомпоненты = ПоместитьВоВременноеХранилище(МакетКомпоненты, УникальныйИдентификатор);
	
	ФайлОбработки = Новый Файл(ОбработкаОбъект.ИспользуемоеИмяФайла);
	ИмяФайлаОбработки = ФайлОбработки.Имя;
	ТекущийКаталог = ФайлОбработки.Путь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИдентификаторКомпоненты = "_" + СтрЗаменить(Новый УникальныйИдентификатор, "-", "");
	ВыполнитьПодключениеВнешнейКомпоненты(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПодключениеВнешнейКомпоненты(ДополнительныеПараметры) Экспорт
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПодключениеВнешнейКомпонентыЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	НачатьПодключениеВнешнейКомпоненты(ОписаниеОповещения, МестоположениеКомпоненты, ИдентификаторКомпоненты, ТипВнешнейКомпоненты.Native);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключениеВнешнейКомпонентыЗавершение(Подключение, ДополнительныеПараметры) Экспорт
	
	Если Подключение Тогда
		СоздатьСоединение();
		ВыполнитьТесты();
		ПодключитьОбработчикОжидания("ЗавершитьРаботу", 1, Истина);
	ИначеЕсли ДополнительныеПараметры = Истина Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьПодключениеВнешнейКомпоненты", ЭтотОбъект, Ложь);
		НачатьУстановкуВнешнейКомпоненты(ОписаниеОповещения, МестоположениеКомпоненты);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРаботу()
	
	ЗавершитьРаботуСистемы(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область МетодыAppVeyor

&НаКлиенте
Процедура СоздатьСоединение()
	
	ЧтениеТекста = Новый ЧтениеТекста(ТекущийКаталог + "app_port.txt");
	Порт = Число(ЧтениеТекста.Прочитать());
	HTTPСоединение = Новый HTTPСоединение("localhost", Порт);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьСообщение(Сообщение, Статус, ПОдробно = "")
	
	Структура = Новый Структура;
	Структура.Вставить("message", Строка(Сообщение));
	Структура.Вставить("category", Строка(Статус));
	Структура.Вставить("details", Строка(ПОдробно));
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(ЗаписьJSON, Структура);
	ТекстJSON = ЗаписьJSON.Закрыть();
	
	HTTPЗапрос = Новый HTTPЗапрос("/api/build/messages");
	HTTPЗапрос.УстановитьТелоИзСтроки(ТекстJSON);
	HTTPЗапрос.Заголовки.Вставить("Content-type", "application/json");
	HTTPСоединение.ОтправитьДляОбработки(HTTPЗапрос);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьТест(HTTPМетод, ИмяТеста, Статус, Длительность = 0, Подробно = "")
	
	Структура = Новый Структура;
	Структура.Вставить("outcome", Статус);
	Структура.Вставить("testName", ИмяТеста);
	Структура.Вставить("fileName", ИмяФайлаОбработки);
	Структура.Вставить("ErrorMessage", Подробно);
	Структура.Вставить("durationMilliseconds", Длительность);
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(ЗаписьJSON, Структура);
	ТекстJSON = ЗаписьJSON.Закрыть();
	
	HTTPЗапрос = Новый HTTPЗапрос("/api/tests");
	HTTPЗапрос.УстановитьТелоИзСтроки(ТекстJSON);
	HTTPЗапрос.Заголовки.Вставить("Content-type", "application/json");
	HTTPСоединение.ВызватьHTTPМетод(HTTPМетод, HTTPЗапрос);
	
КонецПроцедуры

#КонецОбласти

#Область ЭкспортныеМетоды

&НаКлиенте
Процедура Добавить(Знач ИмяМетода, Знач Представление) Экспорт
	
	НаборТестов.Вставить(Представление, ИмяМетода);
	ОтправитьТест("POST", Представление, "Running");
	
КонецПроцедуры

&НаКлиенте
Функция ДобавитьШаг(ТекущаяГруппа, Представление) Экспорт
	
	Возврат Новый Структура("Наименование,Результат,Эталон", Представление);
	
КонецФункции	

&НаКлиенте
Функция ЗаписатьПроблему(ТекущаяГруппа, ТекущаяСтрока, ТекстПроблемы) Экспорт

	ЕстьПроблема = Истина;
	ЕстьОшибкиПроблемы = Истина; 
	
	Если ТекущаяСтрока = Неопределено Тогда
		Наименование = "Неизвестная проблема";
	Иначе
		Наименование = ТекущаяСтрока.Наименование;
	КонецЕсли;
	
	ОтправитьСообщение(Наименование, "Warning", ТекстПроблемы);
	
	Возврат ЭтаФорма;
	
КонецФункции

&НаКлиенте
Функция ПрерватьТест(ТекущаяГруппа, ТекущаяСтрока, Результат, Подробности) Экспорт
	
	ЕстьОшибка = Истина;
	ЕстьОшибкиПроблемы = Истина; 
	
	Если ТекущаяСтрока = Неопределено Тогда
		Наименование = "Неизвестная проблема";
	Иначе
		Наименование = ТекущаяСтрока.Наименование;
	КонецЕсли;
	
	ОтправитьСообщение(ТекущаяСтрока.Наименование, "Error", 
		Строка(Подробности) + Символы.ПС + Строка(Результат));
	
	Возврат ЭтаФорма;
	
КонецФункции

#КонецОбласти

#Область СлужебныеФункции

&НаКлиенте
Функция ПолучитьФормуПоИмени(НовоеИмя, ФормаВладелец)
	
	ПозицияРазделителя = СтрНайти(ИмяФормы, ".", НаправлениеПоиска.СКонца);
	НовоеИмяФормы = Лев(ИмяФормы, ПозицияРазделителя) + НовоеИмя;
	Возврат ПолучитьФорму(НовоеИмяФормы, Неопределено, ФормаВладелец, Новый УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьТест(ТекущийТест)
	
	ЕстьОшибка = Ложь;
	ЕстьПроблема = Ложь;
	
	xUnitBDD = ПолучитьФормуПоИмени("xUnitBDD", ЭтаФорма);
	xUnitBDD.Инициализация(ИдентификаторКомпоненты, ТекущийТест);
	Автотесты = ПолучитьФормуПоИмени("Autotests", xUnitBDD);
	ВремяСтарта = ТекущаяУниверсальнаяДатаВМиллисекундах();
	
	Попытка
		Выполнить("Автотесты." + ТекущийТест.ИмяМетода + "(xUnitBDD)");
	Исключение
		Информация = ИнформацияОбОшибке();
		Результат = КраткоеПредставлениеОшибки(Информация);
		Подробности = ПодробноеПредставлениеОшибки(Информация);
		ПрерватьТест(ТекущийТест, Неопределено, Результат, Подробности);
	КонецПопытки;
	
	Статус = ?(ЕстьОшибка ИЛИ ЕстьПроблема, "Failed", "Passed");
	Длительность = ТекущаяУниверсальнаяДатаВМиллисекундах() - ВремяСтарта;
	ОтправитьТест("PUT", ТекущийТест.Наименование, Статус, Длительность);
	
КонецПроцедуры	
 
&НаКлиенте
Процедура ВыполнитьТесты()
	
	НаборТестов = Новый Соответствие;
	Автотесты = ПолучитьФормуПоИмени("Autotests", ЭтаФорма);
	Автотесты.ЗаполнитьНаборТестов(ЭтаФорма);
	
	ЕстьОшибкиПроблемы = Ложь;
	Для каждого ЭлементСписка Из НаборТестов Цикл
		ТекущийТест = Новый Структура;
		ТекущийТест.Вставить("Наименование", ЭлементСписка.Ключ);
		ТекущийТест.Вставить("ИмяМетода", ЭлементСписка.Значение);
		ВыполнитьТест(ТекущийТест);
	КонецЦикла;
	
	Если Не ЕстьОшибкиПроблемы Тогда
		ЗаписьТекста = Новый ЗаписьТекста(ТекущийКаталог + "success.txt");
		ЗаписьТекста.ЗаписатьСтроку(ТекущаяУниверсальнаяДатаВМиллисекундах());
		ЗаписьТекста.Закрыть();
	КонецЕсли;
	
КонецПроцедуры	

#КонецОбласти
