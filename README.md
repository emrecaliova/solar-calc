# Solar Calculator for a Given Day and Location (Fortran)

This Fortran program calculates solar parameters for a given location and date. It computes sunrise time, sunset time, sunlight duration, nighttime duration, and other astronomical variables based on well-known solar position algorithms.

---

## 🧠 Background and Developer Note

This program was developed by **Emre Çalıova** during undergraduate studies at **Istanbul Technical University (ITU)** as part of a research project investigating the impacts of Turkey's **permanent daylight saving time (DST)** policy.

In 2016, Turkey adopted permanent DST to make better use of daylight throughout the year. This policy shift raised public and academic interest, particularly regarding its implications on **energy consumption**, **human circadian rhythms**, and **daily life schedules**. Accurate computation of **sunrise and sunset times** became essential for these assessments.

This tool was created to support such evaluations by offering precise solar position calculations based on geographic and temporal inputs. It has been used in geospatial studies and policy impact analysis.

---

## 🌍 Features

- Calculates:
  - Sunrise and sunset times (in HH:MM:SS)
  - Sunlight duration and nighttime duration (in HH:MM:SS)
  - Solar zenith and elevation angles
  - Solar azimuth angle
  - Equation of time, declination, right ascension, and more
- Based on input geographic and time information
- Outputs time in human-readable `HH:MM:SS` format

---

## 📥 Input Parameters

All input values are defined at the beginning of the `SOLAR_CALC_FOR_A_DAY` program.

| Variable     | Description                                                  | Example |
|--------------|--------------------------------------------------------------|---------|
| `LAT`        | Latitude in degrees (positive = north, negative = south)     | `41.0`  |
| `LON`        | Longitude in degrees (positive = east, negative = west)      | `29.0`  |
| `TIMEZONE`   | Timezone offset from UTC                                     | `2`     |
| `YEAR`       | Year of the desired date                                     | `2016`  |
| `MONTH`      | Month of the desired date                                    | `1`     |
| `DAY`        | Day of the desired date                                      | `1`     |
| `PLMTHOUR`   | Hour after local midnight (default: `12`)                    | `12`    |
| `PLMTMINUTE` | Minute after local midnight (default: `0`)                   | `0`     |
| `PLMTSECOND` | Second after local midnight (default: `0`)                   | `0`     |

---

## 🧮 Output Variables

After running the program, you’ll see printed values for:

- Julian Day and Julian Century
- Solar angles and declination
- **Sunrise time**: formatted as `HH:MM:SS`
- **Sunset time**: formatted as `HH:MM:SS`
- **Sunlight duration**: in `HH:MM:SS`
- **Nighttime duration**: in `HH:MM:SS`

---

## ⚙️ How to Compile and Run

### 📌 Requirements

- Fortran compiler (e.g., `gfortran`)

### 🧵 Compile

```bash
gfortran -o solar_calculator solar_calc_for_a_day.f90
```

### ▶️ Run

```bash
./solar_calculator
```

### 🔢 Sample Output

```
SRT (sunrise time): 07:28:43
SST (sunset time) : 16:46:44
SLD (sunlight duration): 09:17:03
NTD (nighttime duration): 14:42:56
```

---

### 📚 Algorithm Source

The solar position calculations are based on methods from:

- U.S. NOAA Solar Calculator
- Astronomical Algorithms by Jean Meeus

---

### 📁 File Structure

📦 solar-calc/

  ├── solar_calc_for_a_day.f90   # Main Fortran source code  
  └── README.md                  # This file

---

## 👨‍💻 Author

**Emre Çalıova**  
Meteorological Engineer

📧 [Mail](mailto:caliova94@gmail.com)  
🔗 [LinkedIn](https://www.linkedin.com/in/emrecaliova)  
📅 Created: 10.06.2016  
📅 Updated: 02.08.2025  (for GitHub Repository)

---

### 📄 License

This project is licensed under the MIT License.

You may use, modify, and distribute it freely. Please credit the author where appropriate.
