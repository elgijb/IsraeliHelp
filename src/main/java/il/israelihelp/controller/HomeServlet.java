package il.israelihelp.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Главная страница сайта.
 *
 * На этапе 1 это проверочная страница: она показывает, что цепочка
 * "браузер -> Jetty -> Java-сервлет -> JSP -> браузер" работает.
 *
 * Адрес "" означает корень сайта: http://localhost:8080/
 */
@WebServlet("")
public class HomeServlet extends HttpServlet {

    private static final DateTimeFormatter TIME_FORMAT =
            DateTimeFormatter.ofPattern("dd.MM.yyyy HH:mm:ss");

    /**
     * doGet вызывается сервером, когда браузер делает GET-запрос
     * (например, пользователь открыл адрес в адресной строке).
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Кладём данные в запрос (request attributes), чтобы JSP могла их показать
        request.setAttribute("serverTime", LocalDateTime.now().format(TIME_FORMAT));
        request.setAttribute("javaVersion", System.getProperty("java.version"));
        request.setAttribute("serverInfo", getServletContext().getServerInfo());

        // forward — передаём запрос JSP-странице, она сформирует HTML.
        // JSP лежит в WEB-INF, поэтому браузер не может открыть её напрямую, только через сервлет.
        request.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(request, response);
    }
}
