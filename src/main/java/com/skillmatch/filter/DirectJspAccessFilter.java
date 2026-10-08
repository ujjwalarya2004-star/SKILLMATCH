package com.skillmatch.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Prevents users from opening protected view pages (e.g. /client/dashboard.jsp)
 * directly. Pages must be reached through their controller servlet, which loads
 * the data and enforces authentication/authorization. Server-side forwards from
 * servlets are unaffected (this filter only handles REQUEST dispatches).
 */
@WebFilter(urlPatterns = {"*.jsp"},
           dispatcherTypes = {DispatcherType.REQUEST})
public class DirectJspAccessFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String path = request.getServletPath();
        boolean isPublicPage = path.equals("/index.jsp") || path.equals("/login.jsp")
                || path.equals("/register.jsp");
        if (isPublicPage) {
            chain.doFilter(req, res);
            return;
        }
        response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
    }
}
