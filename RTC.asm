
_read_ds1307:

;RTC.c,19 :: 		unsigned short read_ds1307(unsigned short address)
;RTC.c,22 :: 		I2C1_Start();
	CALL        _I2C1_Start+0, 0
;RTC.c,23 :: 		I2C1_Wr(0xD0); //address 0x68 followed by direction bit (0 for write, 1 for read) 0x68 followed by 0 --> 0xD0
	MOVLW       208
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;RTC.c,24 :: 		I2C1_Wr(address);
	MOVF        FARG_read_ds1307_address+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;RTC.c,25 :: 		I2C1_Repeated_Start();
	CALL        _I2C1_Repeated_Start+0, 0
;RTC.c,26 :: 		I2C1_Wr(0xD1); //0x68 followed by 1 --> 0xD1
	MOVLW       209
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;RTC.c,27 :: 		r_data=I2C1_Rd(0);
	CLRF        FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVF        R0, 0 
	MOVWF       read_ds1307_r_data_L0+0 
;RTC.c,28 :: 		I2C1_Stop();
	CALL        _I2C1_Stop+0, 0
;RTC.c,29 :: 		return(r_data);
	MOVF        read_ds1307_r_data_L0+0, 0 
	MOVWF       R0 
;RTC.c,30 :: 		}
L_end_read_ds1307:
	RETURN      0
; end of _read_ds1307

_write_ds1307:

;RTC.c,33 :: 		void write_ds1307(unsigned short address,unsigned short w_data)
;RTC.c,35 :: 		I2C1_Start(); // issue I2C start signal
	CALL        _I2C1_Start+0, 0
;RTC.c,37 :: 		I2C1_Wr(0xD0); // send byte via I2C (device address + W)
	MOVLW       208
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;RTC.c,38 :: 		I2C1_Wr(address); // send byte (address of DS1307 location)
	MOVF        FARG_write_ds1307_address+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;RTC.c,39 :: 		I2C1_Wr(w_data); // send data (data to be written)
	MOVF        FARG_write_ds1307_w_data+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;RTC.c,40 :: 		I2C1_Stop(); // issue I2C stop signal
	CALL        _I2C1_Stop+0, 0
;RTC.c,41 :: 		}
L_end_write_ds1307:
	RETURN      0
; end of _write_ds1307

_BCD2UpperCh:

;RTC.c,44 :: 		unsigned char BCD2UpperCh(unsigned char bcd)
;RTC.c,46 :: 		return ((bcd >> 4) + '0');
	MOVF        FARG_BCD2UpperCh_bcd+0, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	MOVLW       48
	ADDWF       R0, 1 
;RTC.c,47 :: 		}
L_end_BCD2UpperCh:
	RETURN      0
; end of _BCD2UpperCh

_BCD2LowerCh:

;RTC.c,50 :: 		unsigned char BCD2LowerCh(unsigned char bcd)
;RTC.c,52 :: 		return ((bcd & 0x0F) + '0');
	MOVLW       15
	ANDWF       FARG_BCD2LowerCh_bcd+0, 0 
	MOVWF       R0 
	MOVLW       48
	ADDWF       R0, 1 
;RTC.c,53 :: 		}
L_end_BCD2LowerCh:
	RETURN      0
; end of _BCD2LowerCh

_Binary2BCD:

;RTC.c,56 :: 		int Binary2BCD(int a)
;RTC.c,59 :: 		t1 = a%10;
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FARG_Binary2BCD_a+0, 0 
	MOVWF       R0 
	MOVF        FARG_Binary2BCD_a+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       Binary2BCD_t1_L0+0 
	MOVF        R1, 0 
	MOVWF       Binary2BCD_t1_L0+1 
;RTC.c,60 :: 		t1 = t1 & 0x0F;
	MOVLW       15
	ANDWF       R0, 0 
	MOVWF       Binary2BCD_t1_L0+0 
	MOVF        R1, 0 
	MOVWF       Binary2BCD_t1_L0+1 
	MOVLW       0
	ANDWF       Binary2BCD_t1_L0+1, 1 
;RTC.c,61 :: 		a = a/10;
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FARG_Binary2BCD_a+0, 0 
	MOVWF       R0 
	MOVF        FARG_Binary2BCD_a+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Binary2BCD_a+0 
	MOVF        R1, 0 
	MOVWF       FARG_Binary2BCD_a+1 
;RTC.c,62 :: 		t2 = a%10;
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
;RTC.c,63 :: 		t2 = 0x0F & t2;
	MOVLW       15
	ANDWF       R0, 0 
	MOVWF       R3 
	MOVF        R1, 0 
	MOVWF       R4 
	MOVLW       0
	ANDWF       R4, 1 
;RTC.c,64 :: 		t2 = t2 << 4;
	MOVLW       4
	MOVWF       R2 
	MOVF        R3, 0 
	MOVWF       R0 
	MOVF        R4, 0 
	MOVWF       R1 
	MOVF        R2, 0 
L__Binary2BCD12:
	BZ          L__Binary2BCD13
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	ADDLW       255
	GOTO        L__Binary2BCD12
L__Binary2BCD13:
;RTC.c,65 :: 		t2 = 0xF0 & t2;
	MOVLW       240
	ANDWF       R0, 1 
	MOVLW       0
	ANDWF       R1, 1 
;RTC.c,66 :: 		t1 = t1 | t2;
	MOVF        Binary2BCD_t1_L0+0, 0 
	IORWF       R0, 1 
	MOVF        Binary2BCD_t1_L0+1, 0 
	IORWF       R1, 1 
	MOVF        R0, 0 
	MOVWF       Binary2BCD_t1_L0+0 
	MOVF        R1, 0 
	MOVWF       Binary2BCD_t1_L0+1 
;RTC.c,67 :: 		return t1;
;RTC.c,68 :: 		}
L_end_Binary2BCD:
	RETURN      0
; end of _Binary2BCD

_BCD2Binary:

;RTC.c,71 :: 		int BCD2Binary(int a)
;RTC.c,74 :: 		t = a & 0x0F;
	MOVLW       15
	ANDWF       FARG_BCD2Binary_a+0, 0 
	MOVWF       BCD2Binary_r_L0+0 
	MOVF        FARG_BCD2Binary_a+1, 0 
	MOVWF       BCD2Binary_r_L0+1 
	MOVLW       0
	ANDWF       BCD2Binary_r_L0+1, 1 
;RTC.c,75 :: 		r = t;
;RTC.c,76 :: 		a = 0xF0 & a;
	MOVLW       240
	ANDWF       FARG_BCD2Binary_a+0, 0 
	MOVWF       R3 
	MOVF        FARG_BCD2Binary_a+1, 0 
	MOVWF       R4 
	MOVLW       0
	ANDWF       R4, 1 
	MOVF        R3, 0 
	MOVWF       FARG_BCD2Binary_a+0 
	MOVF        R4, 0 
	MOVWF       FARG_BCD2Binary_a+1 
;RTC.c,77 :: 		t = a >> 4;
	MOVLW       4
	MOVWF       R2 
	MOVF        R3, 0 
	MOVWF       R0 
	MOVF        R4, 0 
	MOVWF       R1 
	MOVF        R2, 0 
L__BCD2Binary15:
	BZ          L__BCD2Binary16
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	BTFSC       R1, 6 
	BSF         R1, 7 
	ADDLW       255
	GOTO        L__BCD2Binary15
L__BCD2Binary16:
;RTC.c,78 :: 		t = 0x0F & t;
	MOVLW       15
	ANDWF       R0, 1 
	MOVLW       0
	ANDWF       R1, 1 
;RTC.c,79 :: 		r = t*10 + r;
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16x16_U+0, 0
	MOVF        BCD2Binary_r_L0+0, 0 
	ADDWF       R0, 1 
	MOVF        BCD2Binary_r_L0+1, 0 
	ADDWFC      R1, 1 
	MOVF        R0, 0 
	MOVWF       BCD2Binary_r_L0+0 
	MOVF        R1, 0 
	MOVWF       BCD2Binary_r_L0+1 
;RTC.c,80 :: 		return r;
;RTC.c,81 :: 		}
L_end_BCD2Binary:
	RETURN      0
; end of _BCD2Binary

_main:

;RTC.c,101 :: 		void main()
;RTC.c,103 :: 		I2C1_Init(100000); //DS1307 I2C is running at 100KHz
	MOVLW       10
	MOVWF       SSPADD+0 
	CALL        _I2C1_Init+0, 0
;RTC.c,105 :: 		ADCON1 = 0x06;  // To turn off analog to digital converters
	MOVLW       6
	MOVWF       ADCON1+0 
;RTC.c,107 :: 		TRISA = 0x07;
	MOVLW       7
	MOVWF       TRISA+0 
;RTC.c,108 :: 		PORTA = 0x00;
	CLRF        PORTA+0 
;RTC.c,110 :: 		Lcd_Init();                        // Initialize LCD
	CALL        _Lcd_Init+0, 0
;RTC.c,111 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;RTC.c,112 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;RTC.c,113 :: 		Lcd_out(1,1,"Time:");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_RTC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_RTC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;RTC.c,114 :: 		Lcd_out(2,1,"Date:");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_RTC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_RTC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;RTC.c,116 :: 		TRISC7_bit =1;
	BSF         TRISC7_bit+0, BitPos(TRISC7_bit+0) 
;RTC.c,117 :: 		UART1_Init(9600);
	MOVLW       25
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;RTC.c,118 :: 		delay_ms(100);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_main0:
	DECFSZ      R13, 1, 1
	BRA         L_main0
	DECFSZ      R12, 1, 1
	BRA         L_main0
	NOP
	NOP
;RTC.c,119 :: 		UART1_Write_Text("Start");
	MOVLW       ?lstr3_RTC+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr3_RTC+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;RTC.c,120 :: 		for(;;){
L_main1:
;RTC.c,121 :: 		second = read_ds1307(0);
	CLRF        FARG_read_ds1307_address+0 
	CALL        _read_ds1307+0, 0
	MOVF        R0, 0 
	MOVWF       _second+0 
	MOVLW       0
	MOVWF       _second+1 
;RTC.c,122 :: 		minute = read_ds1307(1);
	MOVLW       1
	MOVWF       FARG_read_ds1307_address+0 
	CALL        _read_ds1307+0, 0
	MOVF        R0, 0 
	MOVWF       _minute+0 
	MOVLW       0
	MOVWF       _minute+1 
;RTC.c,123 :: 		hour = read_ds1307(2);
	MOVLW       2
	MOVWF       FARG_read_ds1307_address+0 
	CALL        _read_ds1307+0, 0
	MOVF        R0, 0 
	MOVWF       _hour+0 
	MOVLW       0
	MOVWF       _hour+1 
;RTC.c,124 :: 		hr = hour & 0b00011111;
	MOVLW       31
	ANDWF       _hour+0, 0 
	MOVWF       _hr+0 
	MOVF        _hour+1, 0 
	MOVWF       _hr+1 
	MOVLW       0
	ANDWF       _hr+1, 1 
;RTC.c,125 :: 		ap = hour & 0b00100000;
	MOVLW       32
	ANDWF       _hour+0, 0 
	MOVWF       _ap+0 
	MOVF        _hour+1, 0 
	MOVWF       _ap+1 
	MOVLW       0
	ANDWF       _ap+1, 1 
;RTC.c,126 :: 		dday = read_ds1307(3);
	MOVLW       3
	MOVWF       FARG_read_ds1307_address+0 
	CALL        _read_ds1307+0, 0
	MOVF        R0, 0 
	MOVWF       _dday+0 
	MOVLW       0
	MOVWF       _dday+1 
;RTC.c,127 :: 		day = read_ds1307(4);
	MOVLW       4
	MOVWF       FARG_read_ds1307_address+0 
	CALL        _read_ds1307+0, 0
	MOVF        R0, 0 
	MOVWF       _day+0 
	MOVLW       0
	MOVWF       _day+1 
;RTC.c,128 :: 		month = read_ds1307(5);
	MOVLW       5
	MOVWF       FARG_read_ds1307_address+0 
	CALL        _read_ds1307+0, 0
	MOVF        R0, 0 
	MOVWF       _month+0 
	MOVLW       0
	MOVWF       _month+1 
;RTC.c,129 :: 		year = read_ds1307(6);
	MOVLW       6
	MOVWF       FARG_read_ds1307_address+0 
	CALL        _read_ds1307+0, 0
	MOVF        R0, 0 
	MOVWF       _year+0 
	MOVLW       0
	MOVWF       _year+1 
;RTC.c,132 :: 		time[0] = BCD2UpperCh(hr);
	MOVF        _hr+0, 0 
	MOVWF       FARG_BCD2UpperCh_bcd+0 
	CALL        _BCD2UpperCh+0, 0
	MOVF        R0, 0 
	MOVWF       _time+0 
;RTC.c,133 :: 		time[1] = BCD2LowerCh(hr);
	MOVF        _hr+0, 0 
	MOVWF       FARG_BCD2LowerCh_bcd+0 
	CALL        _BCD2LowerCh+0, 0
	MOVF        R0, 0 
	MOVWF       _time+1 
;RTC.c,134 :: 		time[3] = BCD2UpperCh(minute);
	MOVF        _minute+0, 0 
	MOVWF       FARG_BCD2UpperCh_bcd+0 
	CALL        _BCD2UpperCh+0, 0
	MOVF        R0, 0 
	MOVWF       _time+3 
;RTC.c,135 :: 		time[4] = BCD2LowerCh(minute);
	MOVF        _minute+0, 0 
	MOVWF       FARG_BCD2LowerCh_bcd+0 
	CALL        _BCD2LowerCh+0, 0
	MOVF        R0, 0 
	MOVWF       _time+4 
;RTC.c,136 :: 		time[6] = BCD2UpperCh(second);
	MOVF        _second+0, 0 
	MOVWF       FARG_BCD2UpperCh_bcd+0 
	CALL        _BCD2UpperCh+0, 0
	MOVF        R0, 0 
	MOVWF       _time+6 
;RTC.c,137 :: 		time[7] = BCD2LowerCh(second);
	MOVF        _second+0, 0 
	MOVWF       FARG_BCD2LowerCh_bcd+0 
	CALL        _BCD2LowerCh+0, 0
	MOVF        R0, 0 
	MOVWF       _time+7 
;RTC.c,139 :: 		date[0] = BCD2UpperCh(day);
	MOVF        _day+0, 0 
	MOVWF       FARG_BCD2UpperCh_bcd+0 
	CALL        _BCD2UpperCh+0, 0
	MOVF        R0, 0 
	MOVWF       _date+0 
;RTC.c,140 :: 		date[1] = BCD2LowerCh(day);
	MOVF        _day+0, 0 
	MOVWF       FARG_BCD2LowerCh_bcd+0 
	CALL        _BCD2LowerCh+0, 0
	MOVF        R0, 0 
	MOVWF       _date+1 
;RTC.c,141 :: 		date[3] = BCD2UpperCh(month);
	MOVF        _month+0, 0 
	MOVWF       FARG_BCD2UpperCh_bcd+0 
	CALL        _BCD2UpperCh+0, 0
	MOVF        R0, 0 
	MOVWF       _date+3 
;RTC.c,142 :: 		date[4] = BCD2LowerCh(month);
	MOVF        _month+0, 0 
	MOVWF       FARG_BCD2LowerCh_bcd+0 
	CALL        _BCD2LowerCh+0, 0
	MOVF        R0, 0 
	MOVWF       _date+4 
;RTC.c,143 :: 		date[6] = BCD2UpperCh(year);
	MOVF        _year+0, 0 
	MOVWF       FARG_BCD2UpperCh_bcd+0 
	CALL        _BCD2UpperCh+0, 0
	MOVF        R0, 0 
	MOVWF       _date+6 
;RTC.c,144 :: 		date[7] = BCD2LowerCh(year);
	MOVF        _year+0, 0 
	MOVWF       FARG_BCD2LowerCh_bcd+0 
	CALL        _BCD2LowerCh+0, 0
	MOVF        R0, 0 
	MOVWF       _date+7 
;RTC.c,146 :: 		if(ap)
	MOVF        _ap+0, 0 
	IORWF       _ap+1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main4
;RTC.c,148 :: 		time[9] = 'P';
	MOVLW       80
	MOVWF       _time+9 
;RTC.c,149 :: 		time[10] = 'M';
	MOVLW       77
	MOVWF       _time+10 
;RTC.c,150 :: 		}
	GOTO        L_main5
L_main4:
;RTC.c,153 :: 		time[9] = 'A';
	MOVLW       65
	MOVWF       _time+9 
;RTC.c,154 :: 		time[10] = 'M';
	MOVLW       77
	MOVWF       _time+10 
;RTC.c,155 :: 		}
L_main5:
;RTC.c,156 :: 		UART1_Write_Text(time);
	MOVLW       _time+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_time+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;RTC.c,157 :: 		UART1_Write(10);
	MOVLW       10
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;RTC.c,158 :: 		UART1_Write(13);
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;RTC.c,159 :: 		delay_ms(1000);
	MOVLW       6
	MOVWF       R11, 0
	MOVLW       19
	MOVWF       R12, 0
	MOVLW       173
	MOVWF       R13, 0
L_main6:
	DECFSZ      R13, 1, 1
	BRA         L_main6
	DECFSZ      R12, 1, 1
	BRA         L_main6
	DECFSZ      R11, 1, 1
	BRA         L_main6
	NOP
	NOP
;RTC.c,160 :: 		Lcd_out(1, 6, time);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       6
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _time+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_time+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;RTC.c,161 :: 		Lcd_out(2, 6, date);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       6
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _date+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_date+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;RTC.c,162 :: 		}
	GOTO        L_main1
;RTC.c,163 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
