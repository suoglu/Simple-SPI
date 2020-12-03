# SPI

## Contents of Readme

1. About
2. Modules
3. IOs of Modules
4. SPI Synchronous Clock
5. Serial Peripheral Interface (Brief information)
6. Simulation
7. Test
8. Status Information
9. List of Tested Modules
10. Issues

[![Repo on GitLab](https://img.shields.io/badge/repo-GitLab-6C488A.svg)](https://gitlab.com/suoglu/spi)
[![Repo on GitHub](https://img.shields.io/badge/repo-GitHub-3D76C2.svg)](https://github.com/suoglu/Simple-SPI)

---

## About

Set of simple modules to communicate using SPI protocol.

## Modules

Two SPI modules (a master and a slave) and a clock divider module is included in [spi.v](Sources/spi.v).

### `spi_master`

* SPI master module
* Supports multiple slaves.
* Supports both clock polarities (CPOL) and phases (CPHA).
* Supports 8, 16, 24 and 32 bit transactions.
* Variable SPI clock frequecy gis

* SPI slave nodule
* Supports both clock polarities (CPOL) and phases (CPHA).
* Supports 8, 16, 24 and 32 bit transactions.

### `clockDiv16`

* Used to generate SPI clock from system clock.
* Outputs a clock array with 16 diffrent frequencies.

**Important:** CPOL, CPHA and transaction width values should be decided before transaction begins.

## IOs of Modules

Both modules use same naming.

|   Port   | Module | Oriantation | Width |  Description |
| :------: | :----: | :----: | :----: |  ------    |
|  `clk`   |   M/S  |   I   | 1 | System Clock |
|  `rst`   |   M/S  |   I   | 1 | System Reset |
|  `busy`  |   M/S  | O | 1 | Busy signal. Indicates that, the module is in a SPI transaction. |
| `start_trans` | M | I | 1 | Initiate a SPI transfer |
|  `MOSI` | M/S | O/I | 1 | Master Out Slave In, SPI signal |
|  `MISO` | M/S | I/O | 1 | Master In Slave Out, SPI signal |
| `SPI_SCLK` | M/S | O/I | 1 | SPI synchronous clock |
| `CS` | M/S | O/I | */1 | Chip (Slave) Select (Active low) |
| `tx_data` | M/S | I | 32 | Data to be transmitted |
| `rx_data` | M/S | O | 32 | Received data |
| `chipADDRS` | M | I | * | Chip (Slave) address |
| `transaction_length` | M/S | I | 2 | Transaction width (0b00 8bit, 0b01 16bit, 0b10 24bit, 0b11 32bit) |
| `division_ratio` | M | I | 4 | Choose SPI clock frequency |
| `CPOL` | M/S | I | 1 | SPI Clock polarity |
| `CPHA` | M/S | I | 1 | SPI Clock phase |
| `default_val` | M/S | I | 1 | MISO/MOSI value when not in transfer |
M: Master  S: Slave  I: Input  O: Output

*Width of `chipADDRS` and `CS` for master module controlled by following parameters.
|   Parameter   | Default Value |  Description |
|   :-------:   | :-----------: |  ----------  |
| `SLAVE_COUNT` |   8  |   Number of maximum slaves to be connected   |
| `SLAVE_ADDRS_LEN` |   3  | Width slave address |

## SPI Synchronous Clock

SPI clock generated from system clock using `clockDiv16` module. `clockDiv16` generates following frequencies for 100 MHz system clock.

| `division_ratio` | Output Frequency | [f] |
| :------: | :------: | :------: |
| 0000 |   50  | MHz |
|  0001 |   25    |   MHz |
| 0010  |  12.5    | MHz  |
|  0011  |   6.25  |  MHz |
|  0100  |   3.125 |  MHz |
|  0101 | 1562.5   |  kHz |
|  0110  | 781.25  |  kHz |
|  0111  | 390.625 |  kHz |
|  1000 | 195.312  | kHz |
|  1001  | 97.656  | kHz |
|  1010  | 48.828  | kHz |
|  1011  | 24.414  | kHz |
|  1100 | 12.207  | kHz |
|  1101 |    6.103 |  kHz |
|  1110 |    3.052  | kHz |
|  1111 |    1.526  | kHz |

## Serial Peripheral Interface

Information about Serial Peripheral Interface (SPI) can be found on [Wikiperdia](https://en.wikipedia.org/wiki/Serial_Peripheral_Interface). A really good introduction can be found on [Analog.com](https://www.analog.com/en/analog-dialogue/articles/introduction-to-spi-interface.html).

SPI can be used to communicate a single master with multiple slaves. SPI protocol uses four signals to communicate. All modules are connected to same data lines (MOSI and MISO) and  SPI synchronous clock (SPI clock). Each slave must have its own chip (slave) select line connected to master. Master selects slave using active low CS signal. Then master starts toggle SPI clock to go on with the transaction. Master must select only one slave at a given time. MOSI signal carries data from master to slave. MISO signal carries data from slave to master.

SPI transaction can happen in four different modes, defined by clock polarity (`CPOL`) and clock phase (`CPHA`). Clock polarity defines value of clock when not in transaction. When `CPOL` is high, SPI clock value is also high when not in transaction. When `CPOL` is low, SPI clock value is also low when not in transaction. Clock phase determines which edge is to store data. When `CPHA` is low, at the odd numbered edges (first, third...) data is stored and at the even numbered edges (second, fourth...) data is shifted. When `CPHA` is high, at the odd numbered edges (first, third...) data is shifted and at the even numbered edges (second, fourth...) data is stored.

## Simulation

Modules simulated in [tb.v](Simulation/tb.v). Slave and master module simulated togeter. During simulation both received data and MOSI/MISO signals are verified. Modules simulated for all `CPOL`, `CPHA` and `transaction_length` values. ([tb.v](Simulation/tb.v) does not contain all simulation cases, just the last simulation.) Multiple clock frequencies (including highest possible), but not all, are simulated.

## Test

Not done yet

## Status Information

**Last simulation:** 3 December 2020, with [Icarus Verilog](http://iverilog.icarus.com).

**Last test:** Not done yet

## List of Tested Modules

Not done yet

## Issues

* **Possible issue:** MISO signal might come late when `CPHA` is high during 8 bit transaction. (It is working properly in simulation)