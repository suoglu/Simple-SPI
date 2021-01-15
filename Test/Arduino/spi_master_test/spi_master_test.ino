#include <SPI.h> 

int CPOL_MODE;
int CPHA_MODE;
int tlgth_MODE;
int buffr;
int slave_num;
bool newT;

void setup() {
  Serial.begin(9600);
  Serial.print("\nSerial ready");
  pinMode(SS, INPUT_PULLUP);
  pinMode(MOSI, INPUT);
  pinMode(SCK, INPUT);
  pinMode(MISO, OUTPUT);
  SPCR |= _BV(SPE);
  SPI.attachInterrupt();
  buffr = 0;
  newT = false;
  Serial.print("\nSPI ready");
  Serial.print("\nEnter something for config: ");
}

void loop() {
  if(newT)
  {
    newT = false;
    Serial.print("\nRecieved: ");
    Serial.print(buffr);
  }
  if(Serial.available() > 0)
  {
      Serial.read(); //read inital data
      Serial.print("\nCPOL: ");
      while (Serial.available() == 0);
      CPOL_MODE = Serial.parseInt();
      Serial.print(CPOL_MODE);
      Serial.print("\nCPHA: ");
      while (Serial.available() == 0);
      CPHA_MODE = Serial.parseInt();
      Serial.print(CPHA_MODE);
      Serial.print("\nTransaction length: ");
      while (Serial.available() == 0);
      tlgth_MODE = Serial.parseInt();
      Serial.print(tlgth_MODE);
      if(CPOL_MODE == 1)
      {
        if(CPHA_MODE == 1)
        {
          SPI.setDataMode(SPI_MODE3);
        }
        else
        {
          SPI.setDataMode(SPI_MODE2);
        }
      }
      else
      {
        if(CPHA_MODE == 1)
        {
          SPI.setDataMode(SPI_MODE1);
        }
        else
        {
          SPI.setDataMode(SPI_MODE0);
        }
      }
  }
}

ISR (SPI_STC_vect)
{
  int hold = buffr;
  //echo back
  buffr = SPDR;
  SPDR = hold;
  newT = true;
}  // end of interrupt service routine (ISR) SPI_STC_vect
