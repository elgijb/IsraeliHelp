<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<main class="site-main">
<div class="container page-pad">
  <div class="admin-head">
    <div>
      <h1><fmt:message key="admin.eventsTitle"/></h1>
      <p><fmt:message key="admin.eventsMeta"><fmt:param value="${total}"/><fmt:param value="${openCount}"/></fmt:message></p>
    </div>
    <span class="btn btn-primary" style="opacity:.55;cursor:default" title="Stage 6">
      <svg class="ico"><use href="${pageContext.request.contextPath}/icons/lucide.svg#plus"/></svg>
      <fmt:message key="admin.newEvent"/>
    </span>
  </div>

  <p class="help" style="margin-bottom:16px"><fmt:message key="admin.demoNote"/></p>

  <div class="tools">
    <div class="input" style="width:280px;justify-content:flex-start">
      <svg class="ico"><use href="${pageContext.request.contextPath}/icons/lucide.svg#search"/></svg>
      <span class="ph"><fmt:message key="admin.searchTitle"/></span>
    </div>
  </div>

  <table class="table">
    <thead>
      <tr>
        <th><fmt:message key="admin.col.event"/></th>
        <th><fmt:message key="admin.col.city"/></th>
        <th><fmt:message key="admin.col.date"/></th>
        <th><fmt:message key="admin.col.volunteers"/></th>
        <th><fmt:message key="admin.col.status"/></th>
        <th style="text-align:end"><fmt:message key="admin.col.actions"/></th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="row" items="${rows}">
        <tr>
          <td>
            <div class="t"><c:out value="${row.event.title}"/></div>
            <div class="sub"><fmt:message key="${row.event.category.messageKey}"/></div>
          </td>
          <td><fmt:message key="${row.event.city.messageKey}"/></td>
          <td class="num"><c:out value="${row.date}"/><div class="sub"><c:out value="${row.time}"/></div></td>
          <td>
            <div class="vol num">
              <c:out value="${row.event.approvedVolunteers}"/> / <c:out value="${row.event.requiredVolunteers}"/>
              <div class="bar"><i style="width:${row.event.fillPercent}%"></i></div>
            </div>
          </td>
          <td><span class="badge ${row.badgeClass}"><fmt:message key="${row.statusKey}"/></span></td>
          <td>
            <div class="actions">
              <a class="icon-btn" href="${pageContext.request.contextPath}/events/view?id=${row.event.id}" title="View">
                <svg class="ico"><use href="${pageContext.request.contextPath}/icons/lucide.svg#edit"/></svg>
              </a>
              <span class="icon-btn danger" title="Delete — stage 6">
                <svg class="ico"><use href="${pageContext.request.contextPath}/icons/lucide.svg#trash"/></svg>
              </span>
            </div>
          </td>
        </tr>
      </c:forEach>
    </tbody>
  </table>
  <div class="admin-foot">
    <span><fmt:message key="admin.showing"><fmt:param value="${total}"/><fmt:param value="${total}"/></fmt:message></span>
    <span><fmt:message key="admin.statusHint"/></span>
  </div>
</div>
</main>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
