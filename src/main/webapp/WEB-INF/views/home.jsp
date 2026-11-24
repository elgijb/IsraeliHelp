<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%--
  Проверочная страница этапа 1.
  Значения ${...} приходят из HomeServlet через request.setAttribute(...).
  <c:out> экранирует HTML-символы — защита от XSS.
--%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>IsraeliHelp</title>
    <style>
        body { font-family: system-ui, sans-serif; background: #FAFAF8; color: #171717;
               max-width: 640px; margin: 64px auto; padding: 0 24px; line-height: 1.6; }
        h1 { font-size: 24px; margin-bottom: 4px; }
        p.muted { color: #737373; margin-top: 0; }
        dl { border: 1px solid #E5E5E5; background: #FFFFFF; border-radius: 8px; padding: 16px 20px; }
        dt { font-size: 13px; color: #737373; }
        dd { margin: 0 0 12px; }
    </style>
</head>
<body>
    <h1>IsraeliHelp</h1>
    <p class="muted">Stage 1 — project skeleton is running.</p>

    <dl>
        <dt>Server time</dt>
        <dd><c:out value="${serverTime}"/></dd>
        <dt>Java version</dt>
        <dd><c:out value="${javaVersion}"/></dd>
        <dt>Server</dt>
        <dd><c:out value="${serverInfo}"/></dd>
        <dt>Unicode check</dt>
        <dd>English · עברית · Русский</dd>
    </dl>
</body>
</html>
