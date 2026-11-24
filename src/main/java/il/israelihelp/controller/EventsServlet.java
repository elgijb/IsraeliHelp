package il.israelihelp.controller;

import il.israelihelp.model.Category;
import il.israelihelp.model.City;
import il.israelihelp.model.Event;
import il.israelihelp.model.EventStatus;
import il.israelihelp.service.DateFormats;
import il.israelihelp.service.DemoCatalog;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.ResourceBundle;
/**
 * Каталог мероприятий: поиск и фильтры.
 * Пока данные из DemoCatalog; на этапе 5 — из MySQL.
 */
@WebServlet("/events")
public class EventsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Locale locale = (Locale) request.getAttribute("locale");
        if (locale == null) {
            locale = Locale.ENGLISH;
        }
        ResourceBundle bundle = ResourceBundle.getBundle("i18n.messages", locale);

        String q = request.getParameter("q");
        String city = request.getParameter("city");
        String[] cats = request.getParameterValues("category");
        List<String> categories = cats == null ? List.of() : Arrays.asList(cats);
        // поддержка одного category= из главной формы
        if (categories.isEmpty() && request.getParameter("category") != null
                && !request.getParameter("category").isBlank()) {
            categories = List.of(request.getParameter("category"));
        }
        boolean openOnly = "1".equals(request.getParameter("openOnly"))
                || "on".equals(request.getParameter("openOnly"));

        List<Event> filtered = DemoCatalog.filter(q, city, categories, openOnly);
        Map<String, List<Event>> byMonth = DemoCatalog.groupByMonth(filtered);

        List<Map<String, Object>> months = new ArrayList<>();
        for (Map.Entry<String, List<Event>> entry : byMonth.entrySet()) {
            String key = entry.getKey(); // yyyy-MM
            int year = Integer.parseInt(key.substring(0, 4));
            int month = Integer.parseInt(key.substring(5, 7));
            Map<String, Object> block = new LinkedHashMap<>();
            block.put("label", bundle.getString("month." + month) + " " + year);
            block.put("count", entry.getValue().size());

            List<Map<String, Object>> rows = new ArrayList<>();
            for (Event e : entry.getValue()) {
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("event", e);
                row.put("dayShort", DateFormats.dayShort(e.getEventDate(), bundle));
                row.put("dayNum", DateFormats.dayNumber(e.getEventDate()));
                row.put("time", DateFormats.time(e.getEventDate()));
                row.put("isFull", e.getStatus() == EventStatus.FULL);
                rows.add(row);
            }
            block.put("rows", rows);
            months.add(block);
        }

        long totalUpcoming = DemoCatalog.all().stream()
                .filter(e -> e.getStatus() != EventStatus.COMPLETED)
                .count();

        request.setAttribute("pageTitle", bundle.getString("catalog.title"));
        request.setAttribute("activeNav", "events");
        request.setAttribute("q", q == null ? "" : q);
        request.setAttribute("selectedCity", city == null ? "" : city);
        request.setAttribute("selectedCategories", categories);
        request.setAttribute("openOnly", openOnly);
        request.setAttribute("months", months);
        request.setAttribute("resultCount", filtered.size());
        request.setAttribute("totalCount", totalUpcoming);
        request.setAttribute("allCities", City.values());
        request.setAttribute("categoryCounts", DemoCatalog.countsByCategory());
        request.setAttribute("allCategories", Category.values());

        request.getRequestDispatcher("/WEB-INF/views/events.jsp").forward(request, response);
    }
}
