<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>게시판</title>
    <!-- 필요 시 CSS 및 JavaScript 파일 포함 -->
</head>
<body>
    <h2>게시판 목록(테스트용 무지성Ver.)</h2>
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
