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
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.Locale;
import java.util.Optional;
import java.util.ResourceBundle;

@WebServlet("/events/view")
public class EventViewServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        int id;
        try {
            id = Integer.parseInt(idParam);
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        Optional<Event> found = DemoCatalog.findById(id);
        if (found.isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        Event event = found.get();

        Locale locale = (Locale) request.getAttribute("locale");
        if (locale == null) {
            locale = Locale.ENGLISH;
        }
        ResourceBundle bundle = ResourceBundle.getBundle("i18n.messages", locale);

        long days = ChronoUnit.DAYS.between(LocalDate.now(), event.getEventDate().toLocalDate());

        request.setAttribute("pageTitle", event.getTitle());
        request.setAttribute("activeNav", "events");
        request.setAttribute("event", event);
        request.setAttribute("dayShort", DateFormats.dayShort(event.getEventDate(), bundle));
        request.setAttribute("time", DateFormats.time(event.getEventDate()));
        request.setAttribute("numericDate", DateFormats.numericDate(event.getEventDate()));
        request.setAttribute("monthName", DateFormats.monthName(event.getEventDate(), bundle));
        request.setAttribute("dayNum", DateFormats.dayNumber(event.getEventDate()));
        request.setAttribute("daysUntil", days);
        request.setAttribute("isFull", event.getStatus() == EventStatus.FULL);
        request.setAttribute("isCancelled", event.getStatus() == EventStatus.CANCELLED);
        request.setAttribute("isOpen", event.getStatus() == EventStatus.OPEN);
        // Описание может содержать абзацы через \n\n
        request.setAttribute("paragraphs", event.getDescription().split("\\n\\n"));

        request.getRequestDispatcher("/WEB-INF/views/event.jsp").forward(request, response);
    }
}
