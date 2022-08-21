#property copyright "Hohla"
#property link      "hohla@mail.ru"

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 SkyBlue
#property indicator_color2 RoyalBlue
#property strict // Указание компилятору на применение особого строгого режима проверки ошибок 

extern int a=4;
extern int A=95; 
double atr[],ATR[],HL[];

int OnInit(void){//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
   string short_name;
   IndicatorBuffers(3); // т.к. temp[] тоже считается
   SetIndexStyle(0,DRAW_LINE); 
   SetIndexBuffer(0,atr);
   SetIndexStyle(1,DRAW_LINE); 
   SetIndexBuffer(1,ATR);
   SetIndexBuffer(2,HL); 
   short_name="atr("+DoubleToStr(a,0)+"), ATR("+DoubleToStr(A,0)+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name);
   return (INIT_SUCCEEDED); // "0"-Успешная инициализация.
   }//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ

int start(){//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
   int i,BarsToCount=Bars-IndicatorCounted()-1;
   //Print("Start ATR(",a,",",A,") Bars=",Bars," IndicatorCounted=",IndicatorCounted()," BarsToCount=",BarsToCount);
   for (i=BarsToCount; i>0; i--){
      HL[i]=High[i]-Low[i]; 
      //if (i>BarsToCount-2 || i<3) Print("HL[",i,"]=",DoubleToStr(HL[i],Digits-1)," Time[",i,"]=",TimeToStr(Time[i],TIME_DATE | TIME_MINUTES));
      }
   for (i=BarsToCount; i>0; i--){
      atr[i]=iMAOnArray(HL,0,a,0,MODE_SMA,i); // Быстрый
      ATR[i]=iMAOnArray(HL,0,A,0,MODE_SMA,i); // Мэдлэнный
      //if (i>BarsToCount-2 || i<3) Print("atr[",i,"]=",DoubleToStr(atr[i],Digits-1)," ATR[",i,"]=",DoubleToStr(ATR[i],Digits-1));
      }
   return(0);   
   }//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
  
   

