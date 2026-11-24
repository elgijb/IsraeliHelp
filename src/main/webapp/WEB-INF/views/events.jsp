<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<main class="site-main">
<div class="container">
  <div class="page-head">
    <div>
      <h1><fmt:message key="catalog.title"/></h1>
      <p><fmt:message key="catalog.showing"><fmt:param value="${resultCount}"/><fmt:param value="${totalCount}"/></fmt:message></p>
    </div>
    <form class="search" method="get" action="${pageContext.request.contextPath}/events">
      <c:if test="${not empty selectedCity}"><input type="hidden" name="city" value="${selectedCity}"></c:if>
      <c:forEach var="c" items="${selectedCategories}"><input type="hidden" name="category" value="${c}"></c:forEach>
      <c:if test="${openOnly}"><input type="hidden" name="openOnly" value="1"></c:if>
      <input class="input" type="search" name="q" value="<c:out value='${q}'/>" placeholder="<fmt:message key='catalog.searchPlaceholder'/>">
      <button class="btn btn-primary" type="submit"><fmt:message key="catalog.search"/></button>
    </form>
  </div>

  <div class="catalog-layout">
    <aside class="filters">
      <form method="get" action="${pageContext.request.contextPath}/events" id="filtersForm">
        <c:if test="${not empty q}"><input type="hidden" name="q" value="<c:out value='${q}'/>"></c:if>
        <div class="fgroup">
          <h3><fmt:message key="catalog.filters.city"/></h3>
          <select class="input" name="city" onchange="this.form.submit()">
            <option value=""><fmt:message key="catalog.filters.allCities"/></option>
            <c:forEach var="c" items="${allCities}">
              <option value="${c}" ${selectedCity == c.name() ? 'selected' : ''}><fmt:message key="${c.messageKey}"/></option>
            </c:forEach>
          </select>
        </div>
        <div class="fgroup">
          <h3><fmt:message key="catalog.filters.kind"/></h3>
          <c:forEach var="cat" items="${allCategories}">
            <c:set var="checked" value="false"/>
            <c:forEach var="sc" items="${selectedCategories}"><c:if test="${sc == cat.name()}"><c:set var="checked" value="true"/></c:if></c:forEach>
            <label class="check">
              <input type="checkbox" name="category" value="${cat}" ${checked ? 'checked' : ''} onchange="this.form.submit()" style="position:absolute;opacity:0;width:1px;height:1px">
              <span class="box ${checked ? 'on' : ''}"><c:if test="${checked}"><svg class="ico"><use href="${pageContext.request.contextPath}/icons/lucide.svg#check"/></svg></c:if></span>
              <fmt:message key="${cat.messageKey}"/>
              <span class="n"><c:out value="${categoryCounts[cat]}"/></span>
            </label>
          </c:forEach>
        </div>
        <div class="fgroup">
          <label class="check">
            <input type="checkbox" name="openOnly" value="1" ${openOnly ? 'checked' : ''} onchange="this.form.submit()" style="position:absolute;opacity:0;width:1px;height:1px">
            <span class="box ${openOnly ? 'on' : ''}"><c:if test="${openOnly}"><svg class="ico"><use href="${pageContext.request.contextPath}/icons/lucide.svg#check"/></svg></c:if></span>
            <fmt:message key="catalog.filters.openOnly"/>
          </label>
        </div>
        <a class="btn btn-ghost btn-sm" href="${pageContext.request.contextPath}/events" style="padding:0"><fmt:message key="catalog.filters.reset"/></a>
      </form>
    </aside>

    <section>
      <div class="toolbar">
        <c:if test="${not empty q}">
          <a class="chip" href="${pageContext.request.contextPath}/events"><c:out value='"${q}"'/> <svg class="ico"><use href="${pageContext.request.contextPath}/icons/lucide.svg#x"/></svg></a>
        </c:if>
        <c:forEach var="sc" items="${selectedCategories}">
          <span class="chip"><fmt:message key="category.${sc}"/> </span>
        </c:forEach>
        <span class="sort"><fmt:message key="catalog.sort"/> <b><fmt:message key="catalog.sort.soonest"/></b></span>
      </div>

      <c:choose>
        <c:when test="${empty months}">
          <div class="empty-state">
            <p><fmt:message key="catalog.empty"/></p>
            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/events"><fmt:message key="catalog.filters.reset"/></a>
          </div>
        </c:when>
        <c:otherwise>
          <c:forEach var="block" items="${months}">
            <div class="month">
              <c:out value="${block.label}"/>
              <span>
                <c:choose>
                  <c:when test="${block.count == 1}"><fmt:message key="catalog.eventCount"><fmt:param value="${block.count}"/></fmt:message></c:when>
                  <c:otherwise><fmt:message key="catalog.eventsCount"><fmt:param value="${block.count}"/></fmt:message></c:otherwise>
                </c:choose>
              </span>
            </div>
            <div class="results">
              <c:forEach var="row" items="${block.rows}">
                <a class="erow ${row.isFull ? 'full' : ''}" href="${pageContext.request.contextPath}/events/view?id=${row.event.id}">
                  <div class="d">
                    <div class="w"><c:out value="${row.dayShort}"/></div>
                    <div class="n"><c:out value="${row.dayNum}"/></div>
                    <div class="t"><c:out value="${row.time}"/></div>
                  </div>
                  <img class="thumb" src="${pageContext.request.contextPath}/img/events/${row.event.image}" alt="">
                  <div>
                    <div class="cat"><fmt:message key="${row.event.category.messageKey}"/></div>
                    <h3><c:out value="${row.event.title}"/></h3>
                    <div class="meta">
                      <span><svg class="ico"><use href="${pageContext.request.contextPath}/icons/lucide.svg#pin"/></svg><fmt:message key="${row.event.city.messageKey}"/></span>
                      <span><c:out value="${row.event.address}"/></span>
                    </div>
                  </div>
                  <div class="cap">
                    <c:choose>
                      <c:when test="${row.isFull}">
                        <span class="badge b-full"><fmt:message key="catalog.full"/></span>
                        <div class="bar" style="margin-top:10px"><i style="width:100%;background:var(--border-strong)"></i></div>
                      </c:when>
                      <c:otherwise>
                        <fmt:message key="home.volunteersOf">
                          <fmt:param value="${row.event.approvedVolunteers}"/>
                          <fmt:param value="${row.event.requiredVolunteers}"/>
                        </fmt:message>
                        <div class="bar"><i style="width:${row.event.fillPercent}%"></i></div>
                      </c:otherwise>
                    </c:choose>
                  </div>
                </a>
              </c:forEach>
            </div>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </section>
  </div>
</div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
