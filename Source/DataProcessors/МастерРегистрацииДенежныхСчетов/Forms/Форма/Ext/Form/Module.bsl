&НаКлиенте
Перем ЭтапРегистрации;

&НаСервере
Функция ЗаписатьРеквизитыДенежногоСчёта()
	Для Каждого Стр Из РеквизитыДенежногоСчета Цикл
		МенеджерЗаписи = РегистрыСведений.ФинансоваяИнформацияДенежныхСчетов.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Период = ТекущаяДата();
		МенеджерЗаписи.ДенежныйСчёт = ДенежныйСчёт;
		МенеджерЗаписи.ВидИнформации = Стр.ВидИнформацииДенежногоСчета;
		МенеджерЗаписи.Значение = Стр.Значение;
		МенеджерЗаписи.Записать();
	КонецЦикла;
КонецФункции

&НаСервере
Функция СоздатьДенежныйСчёт()
	Спр = Справочники.ДенежныеСчета.СоздатьЭлемент();
	Спр.Наименование = НаименованиеДенежногоСчёта;
	Если ФизическийСчёт Тогда
		Спр.ТипДенежногоСчёта = Перечисления.ТипыДенежныхСчетов.Физический;
	ИначеЕсли БанковскийСчёт Тогда
		Спр.ТипДенежногоСчёта = Перечисления.ТипыДенежныхСчетов.БанковскийСчёт;
	ИначеЕсли ЭлектронныйКошелёк Тогда
		Спр.ТипДенежногоСчёта = Перечисления.ТипыДенежныхСчетов.ЭлектронныйКошелёк;
	КонецЕсли;
	Спр.Записать();
	Возврат Спр.Ссылка;
КонецФункции

&НаСервере
Процедура УстановитьРеквизитыДенежногоСчета()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВидыИнформацииДенежныхСчетов.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.ВидыИнформацииДенежныхСчетов КАК ВидыИнформацииДенежныхСчетов
	               |ГДЕ
	               |	ВидыИнформацииДенежныхСчетов.Родитель = &Родитель";
	Если ФизическийСчёт Тогда
		Запрос.УстановитьПараметр("Родитель",Справочники.ВидыИнформацииДенежныхСчетов.НайтиПоКоду("000000001"));
	ИначеЕсли БанковскийСчёт Тогда
		Запрос.УстановитьПараметр("Родитель",Справочники.ВидыИнформацииДенежныхСчетов.НайтиПоКоду("000000003"));
	ИначеЕсли ЭлектронныйКошелёк Тогда
		Запрос.УстановитьПараметр("Родитель",Справочники.ВидыИнформацииДенежныхСчетов.НайтиПоКоду("000000004"));
	КонецЕсли;
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаЗапроса = РезультатЗапроса.Выбрать();
	Пока ВыборкаЗапроса.Следующий() Цикл
		ТЧ = РеквизитыДенежногоСчета.Добавить();
		ТЧ.ВидИнформацииДенежногоСчета = ВыборкаЗапроса.Ссылка;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда)
	Если ЭтапРегистрации = 0 Тогда
		ЭтаФорма.Элементы.ГруппаНачальныйЭкран.Видимость = Ложь;
		ЭтаФорма.Элементы.ГруппаОсновнаяИнформация.Видимость = Истина;
	ИначеЕсли ЭтапРегистрации = 1 Тогда
		ДенежныйСчёт = СоздатьДенежныйСчёт();
		//
		УстановитьРеквизитыДенежногоСчета();
		//
		ЭтаФорма.Элементы.ГруппаОсновнаяИнформация.Видимость = Ложь;
		ЭтаФорма.Элементы.ГруппаРеквизитыДенежногоСчёта.Видимость = Истина;
	ИначеЕсли ЭтапРегистрации = 2 Тогда
		ЗаписатьРеквизитыДенежногоСчёта();
		//
		ЭтаФорма.Элементы.ГруппаРеквизитыДенежногоСчёта.Видимость = Ложь;
		ЭтаФорма.Элементы.ГруппаЗавершение.Видимость = Истина;
		//
		ЭтаФорма.Элементы.Далее.Заголовок = "Закрыть";
	ИначеЕсли ЭтапРегистрации = 3 Тогда
		ЭтаФорма.Закрыть();
		Оповестить("ДенежныйСчётСоздан",Ложь,ЭтаФорма);
	КонецЕсли;
	//
	ЭтапРегистрации = ЭтапРегистрации + 1;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ЭтапРегистрации = 0;
КонецПроцедуры
