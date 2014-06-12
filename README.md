datecalc-rb
========

datecalc-rb is created by PariahVi (http://pariahvi.com) and is licensed under a BSD License. Read LICENSE.txt for more license text.

A Module to Calculate the Day of the Week of Any Date

####Using the Module
To calculate the day of the week for any date, use *Datecalc.date(y, m, d, t)* where y is the full year (a negative integer for BC years), m is the month number, d is the day number, and type is the calendar type.  The calendar types you have to chose from are:
* English
* Roman
* Gregorian
* Julian
* CE
The default type is English, which is the calendar system the English speaking western countries are using.  This is a system where the calendar was under the Julian system until 1752, when it switched to the Gregorian Calendar, skipping  September 3rd and going straight to September 15th to offset for the differences in the calendar systems on how they incorporated leap years.

####Example Uses
```
require ./datecalc.rb

puts Datecalc.date(2014, 3, 14)
puts Datecalc.date(2014, 3, 14, 'English')
puts Datecalc.date(2014, 3, 14, 'Roman')
puts Datecalc.date(-2014, 3, 14)
puts Datecalc.date(-2014, 3, 14, 'Julian')
puts Datecalc.date(2014, 3, 14, 'Julian')
puts Datecalc.date(204727298871375019846193105719886136647191237731911139435, 3, 14, 'Julian')
puts Datecalc.date(-204727298871375019846193105719886136647191237731911139435, 3, 14)

```
prints out:
```
Friday
Friday
Friday
Wedneday
Wedneday
Thursday
Monday
Saturday
```
