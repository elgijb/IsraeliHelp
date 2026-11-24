<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<footer class="site-footer">
    <div class="container">
        <div>
            <b style="color:var(--text);font-weight:600"><fmt:message key="app.name"/></b><br>
            <fmt:message key="footer.tagline"/><br>
            <fmt:message key="footer.demo"/>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/events" style="color:inherit;text-decoration:none"><fmt:message key="nav.opportunities"/></a>
            ·
            <a href="${pageContext.request.contextPath}/about" style="color:inherit;text-decoration:none"><fmt:message key="nav.about"/></a>
            ·
            <a href="${pageContext.request.contextPath}/login" style="color:inherit;text-decoration:none"><fmt:message key="nav.login"/></a>
        </div>
    </div>
</footer>
</body>
</html>
