package il.israelihelp.controller;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.jsp.jstl.core.Config;

import java.io.IOException;
import java.util.Locale;
import java.util.Set;

/**
 * Выбор языка интерфейса: EN (по умолчанию), HE, RU.
 *
 * Порядок поиска:
 *  1. Параметр ?lang= в адресе (переключатель языков)
 *  2. Значение в Session
 *  3. Cookie "lang"
 *  4. Английский
 *
 * Результат пишется в Session, Cookie и в JSTL (Config.FMT_LOCALE),
 * чтобы теги &lt;fmt:message&gt; брали нужный файл перевода.
 * Для иврита в request кладётся dir="rtl".
 */
@WebFilter("/*")
public class LocaleFilter implements Filter {

    public static final String SESSION_LANG = "lang";
    public static final String COOKIE_LANG = "lang";
    private static final Set<String> SUPPORTED = Set.of("en", "he", "ru");

    @Override
    public void doFilter(jakarta.servlet.ServletRequest req, jakarta.servlet.ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession();

        String lang = request.getParameter("lang");
        if (lang != null) {
            lang = lang.toLowerCase(Locale.ROOT);
            if (!SUPPORTED.contains(lang)) {
                lang = "en";
            }
            session.setAttribute(SESSION_LANG, lang);
            Cookie cookie = new Cookie(COOKIE_LANG, lang);
            cookie.setMaxAge(60 * 60 * 24 * 365); // 1 год
            cookie.setPath("/");
            cookie.setHttpOnly(true);
            response.addCookie(cookie);
        } else {
            Object fromSession = session.getAttribute(SESSION_LANG);
            if (fromSession instanceof String s && SUPPORTED.contains(s)) {
                lang = s;
            } else {
                lang = readCookie(request);
                if (lang == null) {
                    lang = "en";
                }
                session.setAttribute(SESSION_LANG, lang);
            }
        }

        Locale locale = switch (lang) {
            case "he" -> new Locale("he");
            case "ru" -> new Locale("ru");
            default -> Locale.ENGLISH;
        };

        // Config.FMT_LOCALE — чтобы <fmt:message> брал messages_ru / messages_he
        Config.set(session, Config.FMT_LOCALE, locale);
        Config.set(request, Config.FMT_LOCALE, locale);
        request.setAttribute("lang", lang);
        request.setAttribute("dir", "he".equals(lang) ? "rtl" : "ltr");
        request.setAttribute("locale", locale);

        chain.doFilter(request, response);
    }

    private static String readCookie(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies == null) {
            return null;
        }
        for (Cookie c : cookies) {
            if (COOKIE_LANG.equals(c.getName()) && SUPPORTED.contains(c.getValue())) {
                return c.getValue();
            }
        }
        return null;
    }
}
