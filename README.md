# Kalkulator Integer
> Proyek ini dibuat untuk memenuhi tugas besar mata kuliah sistem digital 2021

**Anggota**:
1. Lingga Aradhana Sahadewa (13220020)
2. Muhammad Mikhail Ghrilman (13220021)
3. Nicholas Glenn Manurung (13220052)
4. Bostang Palaguna (13220055)

## Deskripsi
Melakukan operasi aritmatika (jumlah, kurang, kali, bagi) pada bilangan bulat dengan menggunakan FPGA (Altera Cyclone IVE) yang diimplementasikan dengan VHDL.
FPGA menerima input dua buah bilangan bulat beserta operasi yang ingin dilakukan dari komputer menggunakan aplikasi terminal : Termite. Setelah itu, hasil akan ditampilkan pada seven segment yang ada pada FPGA.

## Kebutuhan Sistem
### Software
1. [Intel Quartus Prime Lite](https://www.intel.com/content/www/us/en/software-kit/795188/intel-quartus-prime-lite-edition-design-software-version-23-1-for-windows.html)
2. [Termite Terminal](https://www.compuphase.com/software_termite.htm)

### Hardware
1. Laptop
2. [FPGA Altera Cyclone IV EP4CE Development Board](https://github.com/jvitkauskas/Altera-Cyclone-IV-board-V3.0?tab=readme-ov-file)
3. USB to UART (RS-232) adapter

## Desain Sistem
### Data Path
![Data Path](https://github.com/bostang/kalkulatorIntegerFPGA/blob/main/image/dataPath.png)
### State Chart
![Stae Chart](https://github.com/bostang/kalkulatorIntegerFPGA/blob/main/image/stateDiagram.png)

## Demonstrasi
Pada video demonstrasi di bawah, dilakukan input dua buah bilangan bulat `123` dan `246` untuk dilakukan operasi penjumlahan (`+`). Untuk melakukan itu, pada Terminal Termite kedua angka dimasukkan digit per digit mulai dari digit paling besar, kemudian operasi yang ingin dilakukan `+`, dan terakhir adalah sama dengan `=`. Setelah itu, hasil `369` diamati pada seven segment di FPGA.

![Video Demonstrasi](https://github.com/bostang/kalkulatorIntegerFPGA/blob/main/image/IntegerCalcalator.gif)
