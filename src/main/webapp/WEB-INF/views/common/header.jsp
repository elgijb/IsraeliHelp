<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%--
  Общая шапка сайта.
  Ожидает в request: lang, dir, locale; опционально activeNav = home|events|about|admin
--%>
<fmt:setLocale value="${lang}" scope="request"/>
<fmt:setBundle basename="i18n.messages" scope="request"/>
<!DOCTYPE html>
<html lang="${lang}" dir="${dir}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><c:out value="${pageTitle}"/> · <fmt:message key="app.name"/></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/fonts.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<header class="site-header">
    <div class="container">
        <a class="logo" href="${pageContext.request.contextPath}/">
            <svg class="ico" aria-hidden="true"><use href="${pageContext.request.contextPath}/icons/lucide.svg#heart"/></svg>
            <fmt:message key="app.name"/>
        </a>
        <c:if test="${adminArea}">
            <span class="admin-tag"><fmt:message key="nav.admin"/></span>
        </c:if>
        <c:if test="${not adminArea}">
            <nav class="nav" aria-label="Main">
                <a class="${activeNav == 'events' ? 'active' : ''}" href="${pageContext.request.contextPath}/events"><fmt:message key="nav.opportunities"/></a>
                <a class="${activeNav == 'about' ? 'active' : ''}" href="${pageContext.request.contextPath}/about"><fmt:message key="nav.about"/></a>
            </nav>
        </c:if>
        <div class="spacer"></div>
        <div class="lang" role="navigation" aria-label="Language">
            <a class="${lang == 'en' ? 'on' : ''}" href="${pageContext.request.contextPath}/lang?code=en"><fmt:message key="lang.en"/></a>
            <a class="${lang == 'he' ? 'on' : ''}" href="${pageContext.request.contextPath}/lang?code=he"><fmt:message key="lang.he"/></a>
            <a class="${lang == 'ru' ? 'on' : ''}" href="${pageContext.request.contextPath}/lang?code=ru"><fmt:message key="lang.ru"/></a>
        </div>
        <c:choose>
            <c:when test="${adminArea}">
                <a class="btn btn-ghost btn-sm" href="${pageContext.request.contextPath}/"><fmt:message key="nav.viewSite"/></a>
                <span class="avatar" aria-hidden="true">A</span>
            </c:when>
            <c:otherwise>
                <a class="btn btn-ghost btn-sm" href="${pageContext.request.contextPath}/login"><fmt:message key="nav.login"/></a>
                <a class="btn btn-primary btn-sm" href="${pageContext.request.contextPath}/register"><fmt:message key="nav.signup"/></a>
            </c:otherwise>
        </c:choose>
        <button type="button" class="menu-btn" aria-label="Menu">
            <svg class="ico"><use href="${pageContext.request.contextPath}/icons/lucide.svg#menu"/></svg>
        </button>
    </div>
</header>
<c:if test="${adminArea}">
<nav class="subnav">
    <div class="container">
        <a class="${activeNav == 'admin-events' ? 'on' : ''}" href="${pageContext.request.contextPath}/admin/events"><fmt:message key="admin.events"/></a>
        <a class="${activeNav == 'admin-apps' ? 'on' : ''}" href="${pageContext.request.contextPath}/admin/events"><fmt:message key="admin.applications"/> <span class="count-pill"><fmt:message key="admin.pending"><fmt:param value="2"/></fmt:message></span></a>
    </div>
</nav>
</c:if>
