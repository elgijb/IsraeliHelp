<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<main class="site-main">
<div class="container">
  <nav class="crumbs" aria-label="Breadcrumb">
    <a href="${pageContext.request.contextPath}/events"><fmt:message key="nav.opportunities"/></a>
    <span class="sep">/</span>
    <a href="${pageContext.request.contextPath}/events?city=${event.city}"><fmt:message key="${event.city.messageKey}"/></a>
    <span class="sep">/</span>
    <span style="color:var(--text)"><c:out value="${event.title}"/></span>
  </nav>

  <div class="event-layout">
    <article>
      <div class="event-cat">
        <svg class="ico" aria-hidden="true"><use href="${pageContext.request.contextPath}/icons/lucide.svg#leaf"/></svg>
        <fmt:message key="${event.category.messageKey}"/>
      </div>
      <h1 class="event-title"><c:out value="${event.title}"/></h1>
      <img class="event-photo" src="${pageContext.request.contextPath}/img/events/${event.image}" alt="">
      <div class="credit"><fmt:message key="event.photoCredit"><fmt:param value="Pexels"/></fmt:message></div>

      <div class="facts">
        <div class="fact">
          <svg class="ico"><use href="${pageContext.request.contextPath}/icons/lucide.svg#cal"/></svg>
          <div>
            <div class="k"><fmt:message key="event.date"/></div>
            <div class="v"><c:out value="${dayShort}"/>, <c:out value="${dayNum}"/> <c:out value="${monthName}"/> <c:out value="${event.eventDate.year}"/></div>
            <c:if test="${daysUntil >= 0}"><div class="s">in <c:out value="${daysUntil}"/> days</div></c:if>
          </div>
        </div>
        <div class="fact">
          <svg class="ico"><use href="${pageContext.request.contextPath}/icons/lucide.svg#clock"/></svg>
          <div>
            <div class="k"><fmt:message key="event.time"/></div>
            <div class="v"><c:out value="${time}"/></div>
            <div class="s"><fmt:message key="event.israelTime"/></div>
          </div>
        </div>
        <div class="fact">
          <svg class="ico"><use href="${pageContext.request.contextPath}/icons/lucide.svg#pin"/></svg>
          <div>
            <div class="k"><fmt:message key="event.city"/></div>
            <div class="v"><fmt:message key="${event.city.messageKey}"/></div>
            <div class="s"><c:out value="${event.address}"/></div>
          </div>
        </div>
      </div>

      <section class="about">
        <h2><fmt:message key="event.about"/></h2>
        <c:forEach var="p" items="${paragraphs}">
          <p><c:out value="${p}"/></p>
        </c:forEach>
      </section>

      <section class="place">
        <div>
          <h2 style="margin-bottom:4px"><fmt:message key="event.where"/></h2>
          <div class="addr"><c:out value="${event.address}"/></div>
          <div class="city"><fmt:message key="${event.city.messageKey}"/></div>
        </div>
        <a class="btn btn-secondary" href="https://www.google.com/maps/search/?api=1&query=${event.address}%20${event.city}" target="_blank" rel="noopener">
          <svg class="ico"><use href="${pageContext.request.contextPath}/icons/lucide.svg#map"/></svg>
          <fmt:message key="event.openMaps"/>
        </a>
      </section>
    </article>

    <aside>
      <div class="apply">
        <div class="when"><c:out value="${dayShort}"/>, <c:out value="${dayNum}"/> <c:out value="${monthName}"/></div>
        <div class="time"><c:out value="${time}"/> · <fmt:message key="${event.city.messageKey}"/></div>
        <div class="need">
          <span><fmt:message key="event.volunteers"/></span>
          <span><b><c:out value="${event.approvedVolunteers}"/></b> / <c:out value="${event.requiredVolunteers}"/></span>
        </div>
        <div class="bar"><i style="width:${event.fillPercent}%"></i></div>
        <c:if test="${isOpen}">
          <div class="left"><fmt:message key="event.moreNeeded"><fmt:param value="${event.spotsLeft}"/></fmt:message></div>
          <a class="btn btn-primary btn-lg btn-block" href="${pageContext.request.contextPath}/login"><fmt:message key="event.loginToApply"/></a>
          <div class="note"><fmt:message key="event.applyNote"/></div>
        </c:if>
        <c:if test="${isFull}">
          <button class="btn btn-primary btn-lg btn-block" disabled style="opacity:.45" type="button"><fmt:message key="event.noSpots"/></button>
        </c:if>
        <c:if test="${isCancelled}">
          <span class="badge b-cancel"><fmt:message key="catalog.status.cancelled"/></span>
        </c:if>
      </div>
    </aside>
  </div>
</div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
