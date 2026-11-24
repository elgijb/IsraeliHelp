<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Home" scope="request"/>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<main class="site-main">
<div class="container">
  <section class="hero">
    <div>
      <div class="kicker"><fmt:message key="home.kicker"/></div>
      <h1><fmt:message key="home.title"/></h1>
      <p class="lead"><fmt:message key="home.lead"/></p>
    </div>
    <form class="finder" action="${pageContext.request.contextPath}/events" method="get">
      <h2><fmt:message key="home.findTitle"/></h2>
      <div class="f">
        <label class="label" for="city"><fmt:message key="home.city"/></label>
        <select class="input" id="city" name="city">
          <option value=""><fmt:message key="catalog.filters.allCities"/></option>
          <c:forEach var="c" items="${allCities}">
            <option value="${c}"><fmt:message key="${c.messageKey}"/></option>
          </c:forEach>
        </select>
      </div>
      <div class="f">
        <label class="label" for="category"><fmt:message key="home.category"/></label>
        <select class="input" id="category" name="category">
          <option value=""><fmt:message key="home.anyCategory"/></option>
          <c:forEach var="cat" items="${categories}">
            <option value="${cat}"><fmt:message key="${cat.messageKey}"/></option>
          </c:forEach>
        </select>
      </div>
      <div class="f">
        <label class="label" for="date"><fmt:message key="home.fromDate"/></label>
        <input class="input" type="date" id="date" name="date">
      </div>
      <button class="btn btn-primary btn-lg btn-block" type="submit">
        <svg class="ico" aria-hidden="true"><use href="${pageContext.request.contextPath}/icons/lucide.svg#search"/></svg>
        <fmt:message key="home.show"/>
      </button>
      <a class="all" href="${pageContext.request.contextPath}/events">
        <fmt:message key="home.browseAll"><fmt:param value="${openCount}"/></fmt:message>
        <svg class="ico" aria-hidden="true"><use href="${pageContext.request.contextPath}/icons/lucide.svg#arrow"/></svg>
      </a>
    </form>
  </section>

  <section class="problem">
    <div class="side">
      <h2><fmt:message key="home.problemTitle"/></h2>
      <p><fmt:message key="home.problemLead"/></p>
    </div>
    <div>
      <div class="prow">
        <div>
          <h3><fmt:message key="home.p1.title"/></h3>
          <p><fmt:message key="home.p1.body"/></p>
        </div>
        <div class="fix">
          <svg class="ico" aria-hidden="true"><use href="${pageContext.request.contextPath}/icons/lucide.svg#check"/></svg>
          <div><b><fmt:message key="home.onSite"/></b><fmt:message key="home.p1.fix"/></div>
        </div>
      </div>
      <div class="prow">
        <div>
          <h3><fmt:message key="home.p2.title"/></h3>
          <p><fmt:message key="home.p2.body"/></p>
        </div>
        <div class="fix">
          <svg class="ico" aria-hidden="true"><use href="${pageContext.request.contextPath}/icons/lucide.svg#check"/></svg>
          <div><b><fmt:message key="home.onSite"/></b><fmt:message key="home.p2.fix"/></div>
        </div>
      </div>
      <div class="prow">
        <div>
          <h3><fmt:message key="home.p3.title"/></h3>
          <p><fmt:message key="home.p3.body"/></p>
        </div>
        <div class="fix">
          <svg class="ico" aria-hidden="true"><use href="${pageContext.request.contextPath}/icons/lucide.svg#check"/></svg>
          <div><b><fmt:message key="home.onSite"/></b><fmt:message key="home.p3.fix"/></div>
        </div>
      </div>
    </div>
  </section>

  <section class="week">
    <div class="sec-head">
      <h2><fmt:message key="home.upcoming"/></h2>
      <a href="${pageContext.request.contextPath}/events"><fmt:message key="home.allOpportunities"/> <svg class="ico"><use href="${pageContext.request.contextPath}/icons/lucide.svg#arrow"/></svg></a>
    </div>
    <div class="list">
      <c:forEach var="row" items="${upcoming}">
        <a class="lrow" href="${pageContext.request.contextPath}/events/view?id=${row.event.id}">
          <div class="date">
            <div class="dw"><c:out value="${row.dayShort}"/></div>
            <div class="dd"><c:out value="${row.dayNum}"/> <c:out value="${row.monthShort}"/></div>
          </div>
          <div>
            <div class="cat"><fmt:message key="${row.event.category.messageKey}"/></div>
            <h3><c:out value="${row.event.title}"/></h3>
          </div>
          <div class="where">
            <span><svg class="ico"><use href="${pageContext.request.contextPath}/icons/lucide.svg#pin"/></svg><fmt:message key="${row.event.city.messageKey}"/></span>
            <span><svg class="ico"><use href="${pageContext.request.contextPath}/icons/lucide.svg#clock"/></svg><c:out value="${row.time}"/></span>
          </div>
          <div class="spots">
            <fmt:message key="home.volunteersOf">
              <fmt:param value="${row.event.approvedVolunteers}"/>
              <fmt:param value="${row.event.requiredVolunteers}"/>
            </fmt:message>
            <div class="bar"><i style="width:${row.event.fillPercent}%"></i></div>
          </div>
        </a>
      </c:forEach>
    </div>
  </section>

  <section class="cities">
    <h2><fmt:message key="home.byCity"/></h2>
    <div class="cgrid">
      <c:forEach var="row" items="${cities}">
        <a href="${pageContext.request.contextPath}/events?city=${row.city}">
          <fmt:message key="${row.city.messageKey}"/>
          <span><c:out value="${row.count}"/></span>
        </a>
      </c:forEach>
    </div>
  </section>
</div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
