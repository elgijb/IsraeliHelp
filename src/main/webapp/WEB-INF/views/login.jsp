<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<main class="site-main">
  <div class="auth">
    <div class="logo-block">
      <a class="logo" href="${pageContext.request.contextPath}/">
        <svg class="ico"><use href="${pageContext.request.contextPath}/icons/lucide.svg#heart"/></svg>
        <fmt:message key="app.name"/>
      </a>
    </div>
    <h1><fmt:message key="login.title"/></h1>
    <p class="sub"><fmt:message key="login.sub"/></p>
    <form method="post" action="${pageContext.request.contextPath}/login">
      <div class="f">
        <label class="label" for="username"><fmt:message key="login.username"/></label>
        <input class="input" type="text" id="username" name="username" autocomplete="username" required>
      </div>
      <div class="f">
        <label class="label" for="password"><fmt:message key="login.password"/></label>
        <input class="input" type="password" id="password" name="password" autocomplete="current-password" required>
      </div>
      <button class="btn btn-primary btn-lg btn-block" type="submit"><fmt:message key="login.submit"/></button>
    </form>
    <p class="foot"><fmt:message key="login.noAccount"/> <a href="${pageContext.request.contextPath}/register"><fmt:message key="login.registerLink"/></a></p>
  </div>
</main>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
