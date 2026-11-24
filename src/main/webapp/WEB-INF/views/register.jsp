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
    <h1><fmt:message key="register.title"/></h1>
    <p class="sub"><fmt:message key="register.sub"/></p>
    <form method="post" action="${pageContext.request.contextPath}/register">
      <div class="f">
        <label class="label" for="username"><fmt:message key="register.username"/></label>
        <input class="input" type="text" id="username" name="username" autocomplete="username" required>
      </div>
      <div class="f">
        <label class="label" for="email"><fmt:message key="register.email"/></label>
        <input class="input" type="email" id="email" name="email" autocomplete="email" required>
      </div>
      <div class="f">
        <label class="label" for="password"><fmt:message key="register.password"/></label>
        <input class="input" type="password" id="password" name="password" autocomplete="new-password" required>
      </div>
      <div class="f">
        <label class="label" for="password2"><fmt:message key="register.password2"/></label>
        <input class="input" type="password" id="password2" name="password2" autocomplete="new-password" required>
      </div>
      <button class="btn btn-primary btn-lg btn-block" type="submit"><fmt:message key="register.submit"/></button>
    </form>
    <p class="foot"><fmt:message key="register.hasAccount"/> <a href="${pageContext.request.contextPath}/login"><fmt:message key="register.loginLink"/></a></p>
  </div>
</main>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
