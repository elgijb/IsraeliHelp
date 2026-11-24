package il.israelihelp.controller;

import il.israelihelp.model.City;
import il.israelihelp.model.Event;
import il.israelihelp.service.DateFormats;
import il.israelihelp.service.DemoCatalog;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.ResourceBundle;

/**
 * Главная страница: проблема, поиск, ближайшие мероприятия, города.
 */
@WebServlet("")
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Locale locale = (Locale) request.getAttribute("locale");
        if (locale == null) {
            locale = Locale.ENGLISH;
        }
        ResourceBundle bundle = ResourceBundle.getBundle("i18n.messages", locale);

        List<Map<String, Object>> upcoming = new ArrayList<>();
        for (Event e : DemoCatalog.upcoming(4)) {
            Map<String, Object> row = new LinkedHashMap<>();
            row.put("event", e);
            row.put("dayShort", DateFormats.dayShort(e.getEventDate(), bundle));
            row.put("dayNum", DateFormats.dayNumber(e.getEventDate()));
            row.put("monthShort", shortMonth(DateFormats.monthName(e.getEventDate(), bundle), locale));
            row.put("time", DateFormats.time(e.getEventDate()));
            upcoming.add(row);
        }

        Map<City, Long> byCity = DemoCatalog.openCountByCity();
        // сохраняем порядок городов как в enum
        List<Map<String, Object>> cities = new ArrayList<>();
        for (City c : City.values()) {
            Map<String, Object> row = new LinkedHashMap<>();
            row.put("city", c);
            row.put("count", byCity.getOrDefault(c, 0L));
            cities.add(row);
        }

        request.setAttribute("pageTitle", "Home");
        request.setAttribute("activeNav", "home");
        request.setAttribute("openCount", DemoCatalog.openCount());
        request.setAttribute("upcoming", upcoming);
        request.setAttribute("cities", cities);
        request.setAttribute("allCities", City.values());
        request.setAttribute("categories", il.israelihelp.model.Category.values());

        request.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(request, response);
    }

    private static String shortMonth(String name, Locale locale) {
        if (locale.getLanguage().equals("he") || locale.getLanguage().equals("ru")) {
            return name; // не обрезаем — буквы другие
        }
        return name.length() <= 3 ? name : name.substring(0, 3);
    }
}
