package il.israelihelp.controller;

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
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.ResourceBundle;

/**
 * Админ-таблица мероприятий (этап 3 — макет).
 * Права доступа и CRUD появятся на этапах 6–7.
 */
@WebServlet("/admin/events")
public class AdminEventsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Locale locale = (Locale) request.getAttribute("locale");
        if (locale == null) {
            locale = Locale.ENGLISH;
        }
        ResourceBundle bundle = ResourceBundle.getBundle("i18n.messages", locale);

        List<Map<String, Object>> rows = new ArrayList<>();
        for (Event e : DemoCatalog.all()) {
            Map<String, Object> row = new LinkedHashMap<>();
            row.put("event", e);
            row.put("date", DateFormats.numericDate(e.getEventDate()));
            row.put("time", DateFormats.time(e.getEventDate()));
            row.put("statusKey", switch (e.getStatus()) {
                case OPEN -> "catalog.status.open";
                case FULL -> "catalog.full";
                case CANCELLED -> "catalog.status.cancelled";
                case COMPLETED -> "catalog.status.completed";
            });
            row.put("badgeClass", switch (e.getStatus()) {
                case OPEN -> "b-open";
                case FULL -> "b-full";
                case CANCELLED -> "b-cancel";
                case COMPLETED -> "b-done";
            });
            rows.add(row);
        }

        long open = DemoCatalog.openCount();
        request.setAttribute("pageTitle", bundle.getString("admin.eventsTitle"));
        request.setAttribute("adminArea", true);
        request.setAttribute("activeNav", "admin-events");
        request.setAttribute("rows", rows);
        request.setAttribute("total", rows.size());
        request.setAttribute("openCount", open);

        request.getRequestDispatcher("/WEB-INF/views/admin/events.jsp").forward(request, response);
    }
}
