
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	#Область РазмещениеРеквизитов
	//--{ Khrom 01.05.2023 18:02:55  -- 
	ИмяГруппы = "ГруппаСкидка";
	ГруппаСкидка = ЭтаФорма.Элементы.Добавить(ИмяГруппы, Тип("ГруппаФормы"),Элементы.ГруппаШапкаЛево);
	ГруппаСкидка.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаСкидка.Заголовок = "Согласовання скидка";
	
	ПолеСкидки = Элементы.Добавить("МГ_Скидка", Тип("ПолеФормы"), ГруппаСкидка);
	ПолеСкидки.Вид = ВидПоляФормы.ПолеВвода;
	ПолеСкидки.ПутьКДанным = "Объект.МГ_Скидка";
	
	Элементы.МГ_Скидка.УстановитьДействие("ПриИзменении", "МГ_СкидкаПриИзменении");
	
	МГ_Пересчитать = Команды.Добавить("МГ_Пересчитать");
	МГ_Пересчитать.Заголовок = "Пересчитать";
	МГ_Пересчитать.Действие = "МГ_Пересчитать";
	
	КнопкаМГ_Пересчитать = Элементы.Добавить("МГ_Пересчитать", Тип("КнопкаФормы"), ГруппаСкидка);
	КнопкаМГ_Пересчитать.ИмяКоманды = "МГ_Пересчитать";
	//-- Khrom 01.05.2023 18:02:48  }--
	#КонецОбласти
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
    ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	РассчитатьСуммуСтроки(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЦенаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	РассчитатьСуммуСтроки(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура УслугиКоличествоПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Услуги.ТекущиеДанные;
	
	РассчитатьСуммуСтроки(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура УслугиЦенаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Услуги.ТекущиеДанные;
	
	РассчитатьСуммуСтроки(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриИзменении(Элемент)
	РассчитатьСуммуДокумента();
КонецПроцедуры

&НаКлиенте
Процедура УслугиПриИзменении(Элемент)
	РассчитатьСуммуДокумента();
КонецПроцедуры

&НаКлиенте
Процедура МГ_СкидкаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Товары) Или ЗначениеЗаполнено(Объект.Услуги) Тогда
		ПересчитатьСуммуСУчетомСикдки()
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура РассчитатьСуммуСтроки(ТекущиеДанные)
	
	//--{ Khrom 01.05.2023 20:15:13  -- 
	//Типовой Код начало.
	//ТекущиеДанные.Сумма = ТекущиеДанные.Цена * ТекущиеДанные.Количество;
	//Типовой Код конец.
	
	//-- Khrom 01.05.2023 20:18:12  }--
	//Пересчёт суммы строки с учётом скидки.
	Если Объект.МГ_Скидка > 0 Тогда
		ТекущиеДанные.Сумма = ТекущиеДанные.Цена * ТекущиеДанные.Количество - (ТекущиеДанные.Цена * ТекущиеДанные.Количество * Объект.МГ_Скидка / 100);
	Иначе
		ТекущиеДанные.Сумма = ТекущиеДанные.Цена * ТекущиеДанные.Количество;
	КонецЕсли;
	//-- Khrom 01.05.2023 20:20:00  }--
	
	РассчитатьСуммуДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСуммуДокумента()
	
	Объект.СуммаДокумента = Объект.Товары.Итог("Сумма") + Объект.Услуги.Итог("Сумма");
	
КонецПроцедуры

//--{ Khrom 01.05.2023 20:43:56  -- 
&НаКлиенте
Асинх Процедура ПересчитатьСуммуСУчетомСикдки()
	
	Ответы = Новый СписокЗначений;
	Ответы.Добавить("Да");
	Ответы.Добавить("Нет");
	
	ОтветАсинх = ВопросАсинх("Пересчитать сумму документа с учетом скидки?", Ответы);
	
	Ответ = Ждать ОтветАсинх;
	
	Если Ответ = "Да" Тогда
		
		Если ЗначениеЗаполнено(Объект.Товары) Тогда
			ПересчитатьСуммуПоТаблице(Объект.Товары);
		КонецЕсли;
			
		Если ЗначениеЗаполнено(Объект.Услуги) Тогда
			ПересчитатьСуммуПоТаблице(Объект.Услуги);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьСуммуПоТаблице(ТаблицаДляПересчета)

Для каждого СтрокаТаблицы Из ТаблицаДляПересчета Цикл
	СтрокаТаблицы.Сумма = СтрокаТаблицы.Цена * СтрокаТаблицы.Количество - (СтрокаТаблицы.Цена * СтрокаТаблицы.Количество * Объект.МГ_Скидка / 100);
КонецЦикла;

КонецПроцедуры 

//-- Khrom 01.05.2023 20:44:02  }--

#Область ПодключаемыеКоманды

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
    ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
    ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

//--{ Khrom 01.05.2023 20:56:40  -- 
&НаКлиенте
Процедура МГ_Пересчитать(Команда)
	
	Если ЗначениеЗаполнено(Объект.Товары) Или ЗначениеЗаполнено(Объект.Услуги) Тогда
		ПересчитатьСуммуСУчетомСикдки()
	Иначе
		Сообщить("В документе нет товаров и услуг");
	КонецЕсли;
	
КонецПроцедуры
//-- Khrom 01.05.2023 20:56:46  }--

#КонецОбласти

#КонецОбласти
