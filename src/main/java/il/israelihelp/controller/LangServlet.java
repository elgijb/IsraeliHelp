package il.israelihelp.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Locale;
import java.util.Set;

/**
 * Переключатель языка: GET /lang?code=he
 * Сохраняет выбор в Session и Cookie, возвращает на предыдущую страницу.
 */
@WebServlet("/lang")
public class LangServlet extends HttpServlet {

    private static final Set<String> SUPPORTED = Set.of("en", "he", "ru");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String code = request.getParameter("code");
        if (code == null || !SUPPORTED.contains(code.toLowerCase(Locale.ROOT))) {
            code = "en";
        } else {
            code = code.toLowerCase(Locale.ROOT);
        }

        request.getSession().setAttribute(LocaleFilter.SESSION_LANG, code);
        Cookie cookie = new Cookie(LocaleFilter.COOKIE_LANG, code);
        cookie.setMaxAge(60 * 60 * 24 * 365);
        cookie.setPath("/");
        cookie.setHttpOnly(true);
        response.addCookie(cookie);

        String referer = request.getHeader("Referer");
        String target = (referer != null && referer.contains(request.getServerName()))
                ? referer
                : request.getContextPath() + "/";
        // убираем старый ?lang= из адреса, если был
        target = target.replaceAll("([?&])lang=[a-z]{2}", "$1").replaceAll("[?&]$", "");
        response.sendRedirect(target);
    }
}
