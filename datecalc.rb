# Copyright 2012-2014 PariahVi (http://pariahvi.com).
# LatchBox is licensed under a BSD License.
# Read LICENSE.txt for more license text.

# A Module to Calculate the Day of the Week of Any Date

# Version 1.0.3.2

MONTH_OFFSET = [
    [4, 3], [0, 6], [0], [3], [5], [1], [3], [6], [2], [4], [0], [2]
]
DAYS = [
    "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday",
    "Saturday"
]
CAL_TYPES = [
    "GREGORIAN", "CE", "JULIAN", "ENGLISH", "ROMAN"
]

# Figure out if leap year for CE style dates.
def ce_leap_year(y)
    if y % 100 == 0
        if y % 400 == 0
            return true
        end
    elsif y % 4 == 0
        return true
    end
    return false
end

# Figure out if leap year for Julian style dates.
def jul_leap_year(y)
    if y < 0
        y = (y + 1) % 700
    end
    if y % 4 == 0
        return true
    end
    return false
end

# Figure out if leap year for Julian style dates.
def is_leap_year(year, cal_type)
    if cal_type == "GREGORIAN"
        new_year = year
        if year < 0
            new_year = (year + 1) % 400
        end
        return ce_leap_year(new_year)
    elsif cal_type == "CE"
        return ce_leap_year(year)
    elsif cal_type == "JULIAN"
        return jul_leap_year(year)
    elsif cal_type == "ENGLISH"
        if year >= 1800
            return ce_leap_year(year)
        else
            return jul_leap_year(year)
        end
    elsif cal_type == "ROMAN"
        if year >= 1700
            return ce_leap_year(year)
        else
            return jul_leap_year(year)
        end
    end
end

# Check if value is an integer value.
def check_int(value)
    begin
        Integer(value)
    rescue ArgumentError
        return false
    end
    return true
end

# Check if the date (year, month, date) exists if cal_type.
def is_real_date(year, month, date, cal_type)
    month30 = [4, 6, 9, 11]
    if !month.between?(1, 12)
        return 2
    end
    if !check_int(year)
        return 3
    end
    if !check_int(date) or date < 1 or date > 31
        return 4
    end
    if !CAL_TYPES.include?(cal_type)
        return 5
    end
    if year == 0 and cal_type != "CE"
        return 6
    else
        if month30.include?(month) and date > 30
            return 7
        elsif month == 1 and !(
            date < 29 or(is_leap_year(year, cal_type) and date == 29)
        )
            return 7
        end
    end
    if cal_type == "ENGLISH"
        if month == 9 and date > 2 and date < 15 and year == 1752
            return 8
        end
    end
    if cal_type == "ROMAN"
        if month == 10 and date > 4 and date < 16 and year == 1582
            return 8
        end
    end
    return 1
end

# Figures out value to add from last two digits of year.
def add_xxyy(year, cal_type)
    new_year = year % 100
    if cal_type != "CE" and year < 0
        new_year = (year + 1) % 100
    end
    return ((new_year / 12) + (new_year % 12) + ((new_year % 12) / 4) % 7)
end

# Returns value calculated from every digit of the year besides the last 2
# digits for CE style dates.
def ce_add_yyxx(y)
    yyxx = [2, 0, 5, 3]
    return yyxx[(y/100) % 4]
end

# Returns value calculated from every digit of the year besides the last 2
# digits for Julian style dates.
def jul_add_yyxx(y)
    return (7 - y / 100) % 7
end

# Figures out value to add from every digit of the year besides the last 2
# digits.
def add_yyxx(year, month, date, cal_type)
    if cal_type == "GREGORIAN"
        new_year = year
        if year < 0
            new_year = (year + 1) % 400
        end
        new_year = new_year % 400
        return ce_add_yyxx(new_year)
    elsif cal_type == "CE"
        new_year = year % 400
        return ce_add_yyxx(new_year)
    elsif cal_type == "JULIAN"
        new_year = year
        if year < 0
            new_year = (year + 1) % 700
        end
        new_year %= 700
        return jul_add_yyxx(new_year)
    elsif cal_type == "ENGLISH"
        if year >= 1752
            if year == 1752
                if month.between?(9, 12)
                    if month == 9
                        if date >= 14
                            return 0
                        else
                            return 4
                        end
                    else
                        return 0
                    end
                else
                    return 4
                end
            else
                new_year = year % 400
                return ce_add_yyxx(new_year)
            end
        else
            new_year = year
            if year < 0
                new_year = (year + 1) % 700
            end
            new_year %= 700
            return jul_add_yyxx(new_year)
        end
    elsif cal_type == "ROMAN"
        if year >= 1582
            if year == 1582
                if month.between?(10, 12)
                    if month == 10
                        if date >= 15
                            return 3
                        else
                            return 6
                        end
                    else
                        return 3
                    end
                else
                    return 6
                end
            else
                new_year = year % 400
                return ce_add_yyxx(new_year)
            end
        else
            new_year = year
            if year < 0
                new_year = (year + 1) % 700
            end
            new_year %= 700
            return jul_add_yyxx(new_year)
        end
    end
end

# Add value calculated from the year.
def add_year(year, month, date, cal_type)
    return add_yyxx(year, month, date, cal_type) + add_xxyy(year, cal_type)
end

# Add value for the month based on the year and cal_type.
def add_month(year, month, cal_type)
    if is_leap_year(year, cal_type) and len(MONTH_OFFSET[month - 1]) > 1
        return MONTH_OFFSET[month - 1][1]
    end
    return MONTH_OFFSET[month - 1][0]
end

module Datecalc
    # Returns the day of the week or raises error if a date can't be
    # calculated.
    def self.date(year, month, date, cal_type="ENGLISH")
        cal_type = cal_type.upcase
        check = is_real_date(year, month, date, cal_type)
        if check == 1
            total = (
                (add_year(year, month, date, cal_type) +
                add_month(year, month, cal_type) + date) % 7
                )
            return DAYS[total]
        end
        cal_type = cal_type.capitalize
        raise "Cannot Calculate Date #{year}, #{month}, #{date}, #{cal_type}"
    end
end
