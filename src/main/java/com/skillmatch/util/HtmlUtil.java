package com.skillmatch.util;

/**
 * Output-encoding helpers used by the JSP views to prevent
 * Cross-Site Scripting (XSS) from user-supplied text.
 */
public final class HtmlUtil {

    private HtmlUtil() {}

    /** Escapes text for safe inclusion in HTML body or attribute values. */
    public static String escape(Object value) {
        if (value == null) {
            return "";
        }
        String s = value.toString();
        StringBuilder sb = new StringBuilder(s.length() + 16);
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            switch (c) {
                case '&':  sb.append("&amp;");  break;
                case '<':  sb.append("&lt;");   break;
                case '>':  sb.append("&gt;");   break;
                case '"':  sb.append("&quot;"); break;
                case '\'': sb.append("&#39;");  break;
                default:   sb.append(c);
            }
        }
        return sb.toString();
    }

    /** Allows only http/https URLs in href attributes (blocks javascript: etc.). */
    public static String safeUrl(String url) {
        if (url == null) {
            return "#";
        }
        String u = url.trim();
        String lower = u.toLowerCase();
        if (lower.startsWith("http://") || lower.startsWith("https://")) {
            return escape(u);
        }
        if (!u.isEmpty() && !lower.contains(":")) {
            return escape("https://" + u);
        }
        return "#";
    }
}
