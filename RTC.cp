#line 1 "C:/Users/Mohamed/OneDrive/Documents/WorkSpace/RTC/RTC/RTC.c"

sbit LCD_RS at RB2_bit;
sbit LCD_EN at RB3_bit;
sbit LCD_D4 at RB4_bit;
sbit LCD_D5 at RB5_bit;
sbit LCD_D6 at RB6_bit;
sbit LCD_D7 at RB7_bit;

sbit LCD_RS_Direction at TRISB2_bit;
sbit LCD_EN_Direction at TRISB3_bit;
sbit LCD_D4_Direction at TRISB4_bit;
sbit LCD_D5_Direction at TRISB5_bit;
sbit LCD_D6_Direction at TRISB6_bit;
sbit LCD_D7_Direction at TRISB7_bit;




unsigned short read_ds1307(unsigned short address)
{
 unsigned short r_data;
 I2C1_Start();
 I2C1_Wr(0xD0);
 I2C1_Wr(address);
 I2C1_Repeated_Start();
 I2C1_Wr(0xD1);
 r_data=I2C1_Rd(0);
 I2C1_Stop();
 return(r_data);
}


void write_ds1307(unsigned short address,unsigned short w_data)
{
 I2C1_Start();

 I2C1_Wr(0xD0);
 I2C1_Wr(address);
 I2C1_Wr(w_data);
 I2C1_Stop();
}


unsigned char BCD2UpperCh(unsigned char bcd)
{
 return ((bcd >> 4) + '0');
}


unsigned char BCD2LowerCh(unsigned char bcd)
{
 return ((bcd & 0x0F) + '0');
}


int Binary2BCD(int a)
{
 int t1, t2;
 t1 = a%10;
 t1 = t1 & 0x0F;
 a = a/10;
 t2 = a%10;
 t2 = 0x0F & t2;
 t2 = t2 << 4;
 t2 = 0xF0 & t2;
 t1 = t1 | t2;
 return t1;
}


int BCD2Binary(int a)
{
 int r,t;
 t = a & 0x0F;
 r = t;
 a = 0xF0 & a;
 t = a >> 4;
 t = 0x0F & t;
 r = t*10 + r;
 return r;
}



int second;
int minute;
int hour;
int hr;
int day;
int dday;
int month;
int year;
int ap;

unsigned short set_count = 0;
short set;

char time[] = "00:00:00 PM";
char date[] = "00-00-00";

void main()
{
 I2C1_Init(100000);

 ADCON1 = 0x06;

 TRISA = 0x07;
 PORTA = 0x00;

 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_out(1,1,"Time:");
 Lcd_out(2,1,"Date:");

 TRISC7_bit =1;
 UART1_Init(9600);
 delay_ms(100);
 UART1_Write_Text("Start");
 for(;;){
 second = read_ds1307(0);
 minute = read_ds1307(1);
 hour = read_ds1307(2);
 hr = hour & 0b00011111;
 ap = hour & 0b00100000;
 dday = read_ds1307(3);
 day = read_ds1307(4);
 month = read_ds1307(5);
 year = read_ds1307(6);


 time[0] = BCD2UpperCh(hr);
 time[1] = BCD2LowerCh(hr);
 time[3] = BCD2UpperCh(minute);
 time[4] = BCD2LowerCh(minute);
 time[6] = BCD2UpperCh(second);
 time[7] = BCD2LowerCh(second);

 date[0] = BCD2UpperCh(day);
 date[1] = BCD2LowerCh(day);
 date[3] = BCD2UpperCh(month);
 date[4] = BCD2LowerCh(month);
 date[6] = BCD2UpperCh(year);
 date[7] = BCD2LowerCh(year);

 if(ap)
 {
 time[9] = 'P';
 time[10] = 'M';
 }
 else
 {
 time[9] = 'A';
 time[10] = 'M';
 }
 UART1_Write_Text(time);
 UART1_Write(10);
 UART1_Write(13);
 delay_ms(1000);
 Lcd_out(1, 6, time);
 Lcd_out(2, 6, date);
 }
}
