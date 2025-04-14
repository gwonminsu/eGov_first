<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> <!-- 숫자 포맷팅을 위한 라이브러리 -->
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> <!-- 검색 폼을 위한 기능 라이브러리 -->

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

    <!-- 검색 폼 -->
    <c:url var="searchUrl" value="/board/mainBoardList.do"/>
    <form action="${searchUrl}" method="get" style="margin-bottom:1em;">
        <label for="searchType">검색조건:</label>
        <select name="searchType" id="searchType">
            <option value="author" ${searchType=='author' ? 'selected':''}>작성자</option>
            <option value="title"  ${searchType=='title'  ? 'selected':''}>제목</option>
        </select>
        <label for="keyword">검색어:</label>
        <input type="text" id="keyword" name="keyword" value="${fn:escapeXml(keyword)}" />
        <button type="submit">검색</button>
    </form>

    <p>전체: <span class="count-red"><fmt:formatNumber value="${totalCount}" type="number" groupingUsed="true"/></span>건</p>
    <c:url var="newBoardFormUrl" value="boardForm.do" />
    <button type="button" onclick="location.href='${newBoardFormUrl}';">글쓰기</button>
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

                <!-- 원글일 경우 -->
                <c:url var="detailUrl" value="/board/selectBoard.do">
                    <c:param name="idx" value="${item.idx}" />
                </c:url>
                <!-- 답글일 경우에만 parentUrl 생성 -->
                <c:if test="${not empty item.parentBoardIdx}">
                    <c:url var="parentUrl" value="/board/selectBoard.do">
                        <c:param name="idx" value="${item.parentBoardIdx}" />
                    </c:url>
                </c:if>
                <td>
                    <!-- 답글이면 추가 -->
                    <c:if test="${not empty item.parentBoardIdx}">
                        <a href="${parentUrl}" title="부모 글로 이동">🔼</a>
                    </c:if>
                    <a href="${detailUrl}">${item.title}</a>
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
