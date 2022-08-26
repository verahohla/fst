bool ERROR_CHECK(string ErrTxt){ // Проверка проведения операций с ордерами. Возвращает необходимость повтора торговой операции
   int err=GetLastError(); //
   if (err==0) return(false); // Ошибок нет. Повтор не нужен
   if (err==ERR_NOT_ENOUGH_MONEY && !Real) return(false); // при оптимизации оч много таких ошибок ))
   ErrTxt=ErrTxt+" "+ErrorDescription(err)+"!";
   ERROR_LOG(ErrTxt); // фиксируем ошибки в файл с указанием типа ордера, при котором она возникла
   REPORT(ErrTxt); //
   Alert(ErrTxt);  
   switch (err){   
      case 1:                    return(false); // Expert пытается изменить уже установленные значения такими же значениями. Необходимо изменить одно или несколько значений и повторить попытку.
      case 2:                    return(false); // Общая ошибка. Прекратить все попытки торговых операций до выяснения обстоятельств. Возможно перезагрузить операционную систему и клиентский терминал. 
      case 3:                    return(false); // В торговую функцию переданы неправильные параметры, например, неправильный символ, неопознанная торговая операция, отрицательное допустимое отклонение цены, несуществующий номер тикета и т.п. Необходимо изменить логику программы.
      case 4:                    return(!BUSY());  // Торговый сервер занят. Можно повторить попытку через достаточно большой промежуток времени (от нескольких минут).
      case 5:                    return(false); // Старая версия клиентского терминала. Необходимо установить последнюю версию клиентского терминала.
      case 6:                    return(CONNECT());   // Нет связи с торговым сервером. Необходимо убедиться, что связь не нарушена (например, при помощи функции IsConnected) и через небольшой промежуток времени (от 5 секунд) повторить попытку.
      case 7:                    return(false); // Недостаточно прав
      case 8:    Sleep(5000);    return(true);  // Слишком частые запросы. Необходимо уменьшить частоту запросов, изменить логику программы.
      case 9:                    return(false); // Недопустимая операция нарушающая функционирование сервера
      case 64:                   return(false); //Счет заблокирован/ Необходимо прекратить все попытки торговых операций.
      case 65:                   return(false); //Неправильный номер счета. Необходимо прекратить все попытки торговых операций
      case 128:  Sleep(5000);    ORDER_CHECK(); return(true);   // Истек срок ожидания совершения сделки. Прежде, чем производить повторную попытку (не менее, чем через 1 минуту), необходимо убедиться, что торговая операция действительно не прошла (новая позиция не была открыта, либо существующий ордер не был изменён или удалён, либо существующая позиция не была закрыта)
      case 129:  Sleep(5000);    return(true);   // Неправильная цена bid или ask, возможно, ненормализованная цена. Необходимо после задержки от 5 секунд обновить данные при помощи функции RefreshRates и повторить попытку. Если ошибка не исчезает, необходимо прекратить все попытки торговых операций и изменить логику программы. 
      case 130:  Sleep(5000);    return(true);  // Слишком близкие стопы или неправильно рассчитанные или ненормализованные цены в стопах (или в цене открытия отложенного ордера). Попытку можно повторять только в том случае, если ошибка произошла из-за устаревания цены. Необходимо после задержки от 5 секунд обновить данные при помощи функции RefreshRates и повторить попытку. Если ошибка не исчезает, необходимо прекратить все попытки торговых операций и изменить логику программы.  
      case 131:                  return(false); // Неправильный объем, ошибка в грануляции объема. Необходимо прекратить все попытки торговых операций и изменить логику программы.
      case 132:  Sleep(60000);   return(true);  // Рынок закрыт. Можно повторить попытку через достаточно большой промежуток времени (от нескольких минут).
      case 133:                  return(false); // Торговля запрещена. Необходимо прекратить все попытки торговых операций.
      case 134:                  return(false); // Недостаточно денег для совершения операции. Повторять сделку с теми же параметрами нельзя. Попытку можно повторить после задержки от 5 секунд, уменьшив объем, но надо быть уверенным в достаточности средств для совершения операции.
      case 135:                  return(true);  // Цена изменилась. Можно без задержки обновить данные при помощи функции RefreshRates и повторить попытку.
      case 136:  Sleep(5000);    return(true);  // Нет цен. Брокер по какой-то причине (например, в начале сессии цен нет, неподтвержденные цены, быстрый рынок) не дал цен или отказал. Необходимо после задержки от 5 секунд обновить данные при помощи функции RefreshRates и повторить попытку.
      case 137:  Sleep(5000);    return(true);  // Брокер занят
      case 138:                  return(true);  // Запрошенная цена устарела, либо перепутаны bid и ask. Можно без задержки обновить данные при помощи функции RefreshRates и повторить попытку. Если ошибка не исчезает, необходимо прекратить все попытки торговых операций и изменить логику программы.   
      case 139:                  return(false); // Ордер заблокирован и уже обрабатывается. Необходимо прекратить все попытки торговых операций и изменить логику программы.
      case 140:                  return(false); // Разрешена только покупка. Повторять операцию SELL нельзя.
      case 141:  Sleep(5000);    return(true);   // Слишком много запросов. Необходимо уменьшить частоту запросов, изменить логику программы.
      case 142:  Sleep(5000);    ORDER_CHECK(); return(true); // Ордер поставлен в очередь. Это не ошибка, а один из кодов взаимодействия между клиентским терминалом и торговым сервером. Этот код может быть получен в редком случае, когда во время выполнения торговой операции произошёл обрыв и последующее восстановление связи. Необходимо обрабатывать так же как и ошибку 128.
      case 143:  Sleep(5000);    ORDER_CHECK(); return(true); // Ордер принят дилером к исполнению. Один из кодов взаимодействия между клиентским терминалом и торговым сервером. Может возникнуть по той же причине, что и код 142. Необходимо обрабатывать так же как и ошибку 128.
      case 144:  Sleep(5000);    ORDER_CHECK(); return(true); // Ордер аннулирован самим клиентом при ручном подтверждении сделки. Один из кодов взаимодействия между клиентским терминалом и торговым сервером.
      case 145:  Sleep(5000);    return(true);   // Модификация запрещена, так как ордер слишком близок к рынку и заблокирован из-за возможного скорого исполнения. Можно не ранее, чем через 15 секунд, обновить данные при помощи функции RefreshRates и повторить попытку.
      case 146:                  return(!BUSY()); // Подсистема торговли занята. Повторить попытку только после того, как функция IsTradeContextBusy вернет FALSE. 
      case 147:                  return(false); // Использование даты истечения ордера запрещено брокером. Операцию можно повторить только в том случае, если обнулить параметр expiration.
      case 148:                  return(false); // Количество открытых и отложенных ордеров достигло предела, установленного брокером. Новые открытые позиции и отложенные ордера возможны только после закрытия или удаления существующих позиций или ордеров.
      case 149:                  return(false); // Попытка открыть противоположный ордер в случае, если хеджирование запрещено
      case 150:                  return(false); // Попытка закрыть позицию по инструменту в противоречии с правилом FIFO
      case 4000:                 return(true);  // Нет ошибки
      case 4105:                 return(false); // Ни один ордер не выбран 
      case 4106:                 return(false); // Неизвестный символ
      case 4107:                 return(false); // Неправильный параметр цены для торговой функции
      case 4108:                 return(false); // Неверный номер тикета 
      case 4109:                 return(false); // Торговля не разрешена. Необходимо включить опцию "Разрешить советнику торговать" в свойствах эксперта
      case 4110:                 return(false); // Ордера на покупку не разрешены. Необходимо проверить свойства эксперта
      case 4111:                 return(false); // Ордера на продажу не разрешены. Необходимо проверить свойства эксперта
      default: return(false);
   }  }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
bool CONNECT(){ // Проверка связи длится 5 минут, потом решаем что ее нет////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   TerminalFree(); // освобождение торгового потока на время ожидания
   datetime  StartWaiting=TimeLocal(); 
   while (!IsConnected()){
      Sleep(1000); 
      if (TimeLocal()-StartWaiting>120) {REPORT("Connect Waiting Time > 2 minutes!");  return(false);} // ждали 2 мин, не дождались
      }////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   return(true); // связь есть
   }  
   
bool BUSY(){ // проверяет поток для выполнения торговых операций
   TerminalFree();   // освобождение торгового потока на время ожидания
   datetime  StartWaiting=TimeLocal();   
   while (IsTradeContextBusy()){ // Повторить попытку только после того, как функция IsTradeContextBusy вернет FALSE.
      Sleep(1000);                              
      if (TimeLocal()-StartWaiting>300) {REPORT("ContextBusy Waiting Time > 5 minutes!");  return(true);} // ждали 5 минут, не дождались
      }//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
   return(false); // поток не занят
   }   
   
void ERROR_LOG(string ErrOrder){
   string sB, sBS, sBP, sS, sSS, sSP, ServerTime, ErrorFileName,Expir,  ChkRsk;
   int ErrorFile;
   double Stop=0;
   ErrorFileName="ERROR_"+DoubleToStr(Magic,0)+"_"+ExpertName+".csv"; 
   ErrorFile=FileOpen(ErrorFileName, FILE_READ|FILE_WRITE, ';');  if(ErrorFile<0) {REPORT("ERROR! ErrorCheck(): Не могу открыть файл "+ErrorFileName); return;} 
   Expir =DoubleToStr(ExpirHours,0)+" ("+TimeToStr(ExpirHours,TIME_DATE|TIME_MINUTES)+")";
   if (Buy.New>0){ // момент открытия позы в лонг
      Stop=Buy.New-Buy.Stp;
      sB ="set"+DoubleToStr(Buy.New,DIGITS); 
      sBS="set"+DoubleToStr(Buy.Stp,DIGITS); 
      sBP="set"+DoubleToStr(Buy.Prf,DIGITS);} 
   else { // поза в лонг уже открыта
      sB =DoubleToStr(BUY+BUYSTOP+BUYLIMIT,DIGITS); 
      sBS=DoubleToStr(STOP_BUY,DIGITS); 
      sBP=DoubleToStr(PROFIT_BUY,DIGITS);}
   if (Sel.New>0){// момент открытия позы в шорт
      Stop=Sel.Stp-Sel.New;
      sS ="set"+DoubleToStr(Sel.New,DIGITS); 
      sSS="set"+DoubleToStr(Sel.Stp,DIGITS); 
      sSP="set"+DoubleToStr(Sel.Prf,DIGITS);} 
   else { // поза в шорт уже открыта
      sS =DoubleToStr(SELL+SELLSTOP+SELLLIMIT,DIGITS); 
      sSS=DoubleToStr(STOP_SELL,DIGITS); 
      sSP=DoubleToStr(PROFIT_SELL,DIGITS);}
   ChkRsk=S2(RiskChecker(Lot,Stop,SYMBOL));
   ServerTime="-"+TimeToStr(Time[0],TIME_DATE|TIME_MINUTES);
   if (FileReadString(ErrorFile)=="")// прописываем заголовки столбцов 
      FileWrite (ErrorFile,"ServerTime", "Ask/Bid" ,"StpLev" ,"Spred","Ticket","BUY","StpBUY","PrfBUY","SELL","StpSELL","PrfSELL","Expir","Lot",     "Sym/SYM"     ,"CheckRisk","Err");
   FileSeek(ErrorFile,0,SEEK_END);     // перемещаемся в конец
   FileWrite    (ErrorFile, ServerTime ,S4(Ask)+"/"+S4(Bid), S4(StopLevel), Spred , S0(OrderTicket()) , sB  ,  sBS   ,  sBP   ,  sS  ,   sSS   ,  sSP    , Expir , Lot ,Symbol()+"/"+SYMBOL,  ChkRsk   , ErrOrder);
   FileClose(ErrorFile);
   }////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
   
   // if (err==134) return; // 134-самая распространенная ошибка при оптимизации, 130-на NDD счетах, где стопы=0
   /*if (err==3){// Исключение ошибки тестера, когда сделки совершаются (в 14:28 на М30) или (в 13:59 на Н1).   
      temp=1.0/Period()*Minute(); // Для этого выделяем разницу между временем сделки и временем ТФ 
      temp-=MathRound(temp);      // (должна равняться 0), 
      if (temp!=0) return; // и игнорируем ошибку, если есть эта разница
      }*/