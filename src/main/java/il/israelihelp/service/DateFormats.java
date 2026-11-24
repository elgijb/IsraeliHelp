package il.israelihelp.service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;
import java.util.ResourceBundle;

/**
 * Форматирование дат для страниц.
 * Числа и короткие имена дней берутся из ResourceBundle (day.1 … day.7, month.1 …).
 */
public final class DateFormats {

    private DateFormats() {}

    public static String dayShort(LocalDateTime dt, ResourceBundle bundle) {
        // DayOfWeek: MONDAY=1 … SUNDAY=7 в ISO; в Java getValue() тоже 1=Mon … 7=Sun
        return bundle.getString("day." + dt.getDayOfWeek().getValue());
    }

    public static String monthName(LocalDateTime dt, ResourceBundle bundle) {
        return bundle.getString("month." + dt.getMonthValue());
    }

    public static String dayNumber(LocalDateTime dt) {
        return String.valueOf(dt.getDayOfMonth());
    }

    public static String time(LocalDateTime dt) {
        return dt.format(DateTimeFormatter.ofPattern("HH:mm"));
    }

    public static String dayMonth(LocalDateTime dt) {
        return dt.format(DateTimeFormatter.ofPattern("d MMM", Locale.ENGLISH));
    }

    public static String numericDate(LocalDateTime dt) {
        return dt.format(DateTimeFormatter.ofPattern("dd.MM.yyyy"));
    }

    public static String longDate(LocalDateTime dt, Locale locale) {
        return dt.format(DateTimeFormatter.ofPattern("EEEE, d MMMM yyyy", locale));
    }
}
