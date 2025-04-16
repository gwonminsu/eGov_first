<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> <!-- 숫자 포맷팅을 위한 라이브러리 -->
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> <!-- 검색 폼을 위한 기능 라이브러리 -->
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%> <%-- 페이지네이션을 위한 라이브러리 --%>

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
    <script type="text/javascript">
        function fn_link_page(pageNo) {
            // form id로 폼 가져오기
            var form = document.getElementById('searchForm');
            // hidden input 가져오기 (없으면 생성)
            var pageInput = document.getElementById('pageIndex');
            if (!pageInput) {
                pageInput = document.createElement('input');
                pageInput.type = 'hidden';
                pageInput.name = 'pageIndex';
                pageInput.id   = 'pageIndex';
                form.appendChild(pageInput);
            }
            // 클릭한 페이지 번호 세팅
            pageInput.value = pageNo;
            form.submit();
        }
    </script>
</head>
<body>
    <h2>게시글 목록</h2>

    <!-- 검색 폼 -->
    <c:url var="searchUrl" value="/board/mainBoardList.do"/>
    <form:form id="searchForm" modelAttribute="searchVO" method="get" action="${searchUrl}" style="margin-bottom:1em;">
        <form:hidden path="pageIndex" id="pageIndex"/>
        <label for="searchType">검색조건:</label>
        <form:select path="searchType" id="searchType">
            <form:option value="author" label="작성자"/>
            <form:option value="title"  label="제목"/>
        </form:select>
        <label for="keyword">검색어:</label>
        <form:input path="keyword" id="keyword"/>
        <button type="submit" onclick="document.getElementById('pageIndex').value='1';">검색</button>
    </form:form>

    <p>전체: <span class="count-red"><fmt:formatNumber value="${paginationInfo.totalRecordCount}" type="number" groupingUsed="true"/></span>건</p>
    <c:url var="newBoardFormUrl" value="/board/boardForm.do">
        <c:if test="${not empty param.searchType}">
            <c:param name="searchType" value="${param.searchType}" />
        </c:if>
        <c:if test="${not empty param.keyword}">
            <c:param name="keyword"    value="${param.keyword}"    />
        </c:if>
    </c:url>
    <button type="button" onclick="location.href='${newBoardFormUrl}';">글쓰기</button>
    <table border="1">
        <tr>
            <th>순번</th>
            <th>제목</th>
            <th>작성자</th>
            <th>등록일</th>
            <th>조회수</th>
        </tr>
        <!-- Model에 담긴 boardList 데이터를 JSTL forEach 태그를 통해 반복 출력 -->
        <c:forEach var="item" items="${boardList}">
            <tr>
                <td>${item.number}</td>

                <!-- 원글일 경우 -->
                <c:url var="detailUrl" value="/board/selectBoard.do">
                    <c:param name="idx" value="${item.idx}" />
                    <!-- 검색 파라미터가 있으면 selectBoard.do에 검색 파라미터를 더해서 전달(목록버튼으로 다시 돌아가기 위함) -->
                    <c:if test="${not empty param.searchType}">
                        <c:param name="searchType" value="${param.searchType}" />
                    </c:if>
                    <c:if test="${not empty param.keyword}">
                        <c:param name="keyword" value="${param.keyword}" />
                    </c:if>
                </c:url>

                <td>
                    <c:choose>
                        <%-- 실제 검색어(param.keyword)가 있을 때만 검색 모드로 간주 --%>
                        <c:when test="${not empty param.keyword}">
                            <%-- 검색 모드(키워드가 있을 때)는 들여쓰기 없이 --%>
                        </c:when>
                        <c:otherwise>
                            <%-- 검색어가 없거나 페이징 이동일 때는 항상 계층 들여쓰기 --%>
                            <c:forEach var="i" begin="1" end="${item.level * 4}">
                                &nbsp;
                            </c:forEach>
                            <c:if test="${item.level > 0}">ㄴ</c:if>
                        </c:otherwise>
                    </c:choose>
                    <a href="${detailUrl}">
                        <c:out value="${item.title}" />
                    </a>
                    <c:if test="${item.hasFile}">
                        &nbsp;🔗
                    </c:if>
                </td>

                <td>${item.author}</td>
                <td><fmt:formatDate value="${item.createdAt}" pattern="yyyy-MM-dd"/></td>
                <td>${item.hit}</td>

            </tr>
        </c:forEach>
    </table>

    <ui:pagination
            paginationInfo="${paginationInfo}"
            type="image"
            jsFunction="fn_link_page"/>

</body>
</html>
