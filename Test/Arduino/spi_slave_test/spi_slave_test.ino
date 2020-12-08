#include <SPI.h> 

#define CS0 7  //Chip (Slave) select 0
#define CS1 8 //Chip (Slave) select 1

using namespace std;

int CPOL_MODE;
int CPHA_MODE;
int tlgth_MODE;
int buffr;
int slave_num;
  
void setup() {
  // Start serial
  Serial.begin(9600);
  Serial.print("\nSerial ready");
  //chip selects
  pinMode(CS0, OUTPUT);
  pinMode(CS1, OUTPUT);
  digitalWrite(CS0, HIGH);
  digitalWrite(CS1, HIGH);
  Serial.print("\nCS ready");
  SPI.begin();
  SPI.setClockDivider(SPI_CLOCK_DIV2);
  SPI.setBitOrder(MSBFIRST);
  SPI.setDataMode(SPI_MODE0);
  Serial.print("\nSPI begin");
  Serial.print("\nEnter slave number (0-1) or settings (2): ");
}

void loop() 
{
  
  if (Serial.available() > 0)
  {
    buffr = Serial.parseInt();
    Serial.print(buffr);
    if(buffr == 0)
    {
      spi_transaction(CS0);
    }
    else if(buffr == 1)
    {
      spi_transaction(CS1);
    } 
    else if(buffr == 2)
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
    Serial.print("\nEnter slave number (0-1) or settings (2): ");
  }
}
void spi_transaction(int CS)
{
      Serial.print("\nEnter data to send: ");
      while (Serial.available() == 0);
      buffr = Serial.parseInt();
      Serial.print(buffr);
      digitalWrite(CS, LOW);
      Serial.print("\nResponse: ");
      for(int i = 0; i < tlgth_MODE; i++)
      {
        Serial.print(SPI.transfer(buffr));
      }
      digitalWrite(CS, HIGH);  
}
