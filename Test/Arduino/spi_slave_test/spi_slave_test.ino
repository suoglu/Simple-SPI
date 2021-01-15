#include <SPI.h> 

int CPOL_MODE;
int CPHA_MODE;
int tlgth_MODE;
int buffr;
int slave_num;
  
void setup() {
  delay(0);
  Serial.begin(9600);
  Serial.print("\nSerial ready");
  //chip selects
  pinMode(SS, OUTPUT);
  digitalWrite(SS, HIGH);
  pinMode(MOSI, OUTPUT);
  pinMode(SCK, OUTPUT);
  pinMode(MISO, INPUT);
  Serial.print("\nSS ready");
  SPI.begin();
  //SPI.setClockDivider(SPI_CLOCK_DIV2);
  SPI.setBitOrder(MSBFIRST);
  SPI.setDataMode(SPI_MODE0);
  Serial.print("\nSPI begin");
  Serial.print("\nEnter 0 to transfer or 1 to config: ");
}

void loop() 
{
  
  if (Serial.available() > 0)
  {
    buffr = Serial.parseInt();
    Serial.print(buffr);
    if(buffr == 0)
    {
      Serial.print("\nEnter data to send: ");
      while (Serial.available() == 0);
      buffr = Serial.parseInt();
      Serial.print(buffr);
      digitalWrite(SS, LOW);
      Serial.print("\nResponse: ");
      for(int i = 0; i < tlgth_MODE; i++)
      {
        Serial.print(SPI.transfer(buffr));
      }
      digitalWrite(SS, HIGH);  
    }
    else if(buffr == 1)
    {
      
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
    Serial.print("\nEnter 0 to transfer or 1 to config: ");
  }
}
