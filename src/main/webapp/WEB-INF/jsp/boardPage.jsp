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

        .board-table {
            width: 90%;
            margin-top: 30px
            border-collapse: collapse;
        }
        .board-table th,
        .board-table td {
            border: 1px solid #ccc;
            padding: 8px;
        }
        .board-table th.center,
        .board-table td.center {
            text-align: center;
        }

        .pagination {
            text-align: center;
            margin: 1em 0;
        }
        .pagination img.disabled {
            opacity: 0.5;
            cursor: default;
        }
    </style>
    <script>
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

        // 현재 속한 그룹의 시작 페이지 계산
        function getGroupStart(current, pageSize) {
            return current - ((current - 1) % pageSize);
        }

        // 이동할 pageIndex 계산
        function calcPage(action, current, pageSize, total) {
            var groupStart = getGroupStart(current, pageSize);
            switch (action) {
                case 'first':     return 1;
                case 'prevGroup': return Math.max(1, groupStart - pageSize);
                case 'nextGroup': return Math.min(total, groupStart + pageSize);
                case 'last':      return total;
                default:          return current;
            }
        }

        // 버튼 작동 함수
        function jumpPage(action) {
            var current  = ${paginationInfo.currentPageNo};
            var total    = ${paginationInfo.totalPageCount};
            var pageSize = ${paginationInfo.pageSize};
            var target   = calcPage(action, current, pageSize, total);
            fn_link_page(target);
        }
    </script>
</head>
<body>
    <h2>게시글 목록</h2>

    <!-- 검색 폼 -->
    <c:url var="searchUrl" value="/board/mainBoardList.do"/>
    <form:form id="searchForm" modelAttribute="searchVO" method="post" action="${searchUrl}" style="margin-bottom:1em;">
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
    <table class="board-table">
        <tr>
            <th class="center">순번</th>
            <th>제목</th>
            <th class="center">작성자</th>
            <th class="center">등록일</th>
            <th class="center">조회수</th>
        </tr>
        <!-- Model에 담긴 boardList 데이터를 JSTL forEach 태그를 통해 반복 출력 -->
        <c:forEach var="item" items="${boardList}">
            <tr>
                <td class="center">${item.number}</td>

                <td>
                    <form id="detailForm${item.idx}" method="post" action="/board/selectBoard.do" style="display:inline;">
                        <input type="hidden" name="idx" value="${item.idx}"/>
                        <input type="hidden" name="searchType" value="${param.searchType}"/>
                        <input type="hidden" name="keyword" value="${param.keyword}"/>
                            <c:choose>
                                <c:when test="${not empty param.keyword}"></c:when>
                                <c:otherwise>
                                    <c:forEach var="i" begin="1" end="${item.level * 4}">
                                        &nbsp;
                                    </c:forEach>
                                    <c:if test="${item.level > 0}">ㄴ</c:if>
                                </c:otherwise>
                            </c:choose>
                            <a href="javascript:document.getElementById('detailForm${item.idx}').submit();"
                               style="color:inherit; text-decoration:none; cursor:pointer;">
                                <c:out value="${item.title}" />
                            </a>
                            <c:if test="${item.hasFile}"> &#128279;</c:if>
                    </form>
                </td>

                <td class="center">${item.author}</td>
                <td class="center"><fmt:formatDate value="${item.createdAt}" pattern="yyyy-MM-dd"/></td>
                <td class="center">${item.hit}</td>

            </tr>
        </c:forEach>
    </table>

    <!-- 페이지네이션 UI -->
    <c:url var="firstPageUrl" value="/images/egovframework/cmmn/btn_page_pre10.gif"/>
    <c:url var="prevPageUrl" value="/images/egovframework/cmmn/btn_page_pre1.gif"/>
    <c:url var="nextPageUrl" value="/images/egovframework/cmmn/btn_page_next1.gif"/>
    <c:url var="lastPageUrl" value="/images/egovframework/cmmn/btn_page_next10.gif"/>


    <div class="pagination">
        <!-- 처음 -->
        <c:choose>
            <c:when test="${paginationInfo.currentPageNo > 1}">
                <a href="javascript:jumpPage('first');">
                    <img src="${firstPageUrl}" border="0" alt="처음"/>
                </a>
            </c:when>
            <c:otherwise>
                <!-- 기능 비활성화: 링크 제거, .disabled 클래스 추가 -->
                <img src="${firstPageUrl}" class="disabled" border="0" alt="처음"/>
            </c:otherwise>
        </c:choose>

        <!-- 이전 그룹 -->
        <c:choose>
            <c:when test="${paginationInfo.firstPageNoOnPageList > 1}">
                <a href="javascript:jumpPage('prevGroup');">
                    <img src="${prevPageUrl}" border="0" alt="이전 10페이지"/>
                </a>
            </c:when>
            <c:otherwise>
                <img src="${prevPageUrl}" class="disabled" border="0" alt="이전 10페이지"/>
            </c:otherwise>
        </c:choose>

        <!-- 페이지 번호 -->
        <c:forEach var="page" begin="${paginationInfo.firstPageNoOnPageList}" end="${paginationInfo.lastPageNoOnPageList}">
            <c:choose>
                <c:when test="${page == paginationInfo.currentPageNo}">
                    <strong>${page}</strong>
                </c:when>
                <c:otherwise>
                    <a href="javascript:fn_link_page(${page});">${page}</a>
                </c:otherwise>
            </c:choose>
        </c:forEach>

        <!-- 다음 -->
        <c:choose>
            <c:when test="${paginationInfo.currentPageNo < paginationInfo.totalPageCount}">
                <a href="javascript:jumpPage('nextGroup');">
                    <img src="${nextPageUrl}"  border="0" alt="다음"/>
                </a>
            </c:when>
            <c:otherwise>
                <img src="${nextPageUrl}"  class="disabled" border="0" alt="다음"/>
            </c:otherwise>
        </c:choose>

        <!-- 마지막 -->
        <c:choose>
            <c:when test="${paginationInfo.currentPageNo < paginationInfo.totalPageCount}">
                <a href="javascript:jumpPage('last');">
                    <img src="${lastPageUrl}" border="0" alt="마지막"/>
                </a>
            </c:when>
            <c:otherwise>
                <img src="${lastPageUrl}" class="disabled" border="0" alt="마지막"/>
            </c:otherwise>
        </c:choose>
    </div>

</body>
</html>
