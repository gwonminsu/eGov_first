<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> <!-- 숫자 포맷팅을 위한 라이브러리 -->
<html>
<head>
    <title>게시판</title>
    <style>
        .count-red {
            color: red;
            font-weight: bold;
            font-size: 1.2em;
        }
    </style>
</head>
<body>
    <h2>게시글 목록</h2>
    <p>전체: <span class="count-red"><fmt:formatNumber value="${totalCount}" type="number" groupingUsed="true"/></span>건</p>
    <button type="button" onclick="location.href='boardForm.do'">글쓰기</button>
    <table border="1">
        <tr>
            <th>Idx</th>
            <th>작성자</th>
            <th>부모 게시글</th>
            <th>제목</th>
            <th>비밀번호</th>
            <th>조회수</th>
            <th>내용</th>
            <th>등록 시간</th>
            <th>수정 시간</th>
        </tr>
        <!-- Model에 담긴 boardList 데이터를 JSTL forEach 태그를 통해 반복 출력 -->
        <c:forEach var="item" items="${boardList}">
            <tr>
                <td>${item.idx}</td>
                <td>${item.author}</td>
                <td>${item.parentBoardIdx}</td>
                <td>
                    <a href="selectBoard.do?idx=${item.idx}">
                        ${item.title}
                    </a>
                </td>
                <td>${item.password}</td>
                <td>${item.hit}</td>
                <td>${item.content}</td>
                <td>${item.createdAt}</td>
                <td>${item.updatedAt}</td>
            </tr>
        </c:forEach>
    </table>
</body>
</html>
