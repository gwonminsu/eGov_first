<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Test List</title>
    <!-- 필요 시 CSS 및 JavaScript 파일 포함 -->
</head>
<body>
    <h2>Test List</h2>
    <table border="1">
        <tr>
            <th>Idx</th>
            <th>Name</th>
            <th>Code</th>
        </tr>
        <!-- Model에 담긴 testList 데이터를 JSTL forEach 태그를 통해 반복 출력 -->
        <c:forEach var="item" items="${testPage}">
            <tr>
                <td>${item.idx}</td>
                <td>${item.name}</td>
                <td>${item.code}</td>
            </tr>
        </c:forEach>
    </table>
</body>
</html>
