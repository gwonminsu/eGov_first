<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<html>
<head>
    <title>
        <c:choose>
            <c:when test="${not empty board.idx}">게시글 수정</c:when>
            <c:otherwise>게시글 등록</c:otherwise>
        </c:choose>
    </title>
    <style>
      .error { color: red; }
      .errorSummary { border:1px solid red; padding:10px; margin-bottom:15px; }
    </style>
    <!-- jquery 사용 -->
    <script src="<c:url value='/js/jquery-3.6.0.min.js'/>"></script>
</head>
<body>
    <h2>
        <c:choose>
            <c:when test="${not empty board.idx}">게시글 수정</c:when>
            <c:otherwise>게시글 등록</c:otherwise>
        </c:choose>
    </h2>

    <!-- 전역 에러(필드별 에러 외에 form 전체 에러가 있을 때) -->
    <c:if test="${not empty org.springframework.validation.BindingResult.board and org.springframework.validation.BindingResult.board.errorCount > 0}">
        <div class="errorSummary">
            <form:errors path="*" element="div"/>
        </div>
    </c:if>

    <!-- form에 게시물 idx가 있으면 update 아니면 insert -->
    <c:choose>
        <c:when test="${not empty board.idx}">
            <c:url var="formAction" value="updateBoard.do"/>
        </c:when>
        <c:otherwise>
            <c:url var="formAction" value="insertBoard.do"/>
        </c:otherwise>
    </c:choose>

    <form:form action="${formAction}" modelAttribute="board" method="post" enctype="multipart/form-data">
        <%-- 수정용 보드 폼을 위한 필드 --%>
        <c:if test="${not empty board.idx}">
            <form:hidden path="idx"/>
        </c:if>
        <%-- 부모게시글idx가 있을 때만 필드 출력(inset 시 공백문자 삽입 방지) --%>
        <c:if test="${not empty board.parentBoardIdx}">
            <form:hidden path="parentBoardIdx"/>
        </c:if>
        <table>
            <tr>
                <th>제목</th>
                <td>
                    <form:input path="title" required="required" htmlEscape="true" maxlength="100" />
                    <form:errors path="title" cssClass="error" />
                </td>
            </tr>
            <tr>
                <th>작성자</th>
                <td>
                    <form:input path="author" required="required" htmlEscape="true" maxlength="50" />
                    <form:errors path="author" cssClass="error" />
                </td>
            </tr>
            <tr>
                <th>비밀번호</th>
                <td>
                    <form:password path="password" required="required" htmlEscape="true" maxlength="100" />
                    <form:errors path="password" cssClass="error" />
                </td>
            </tr>
            <tr>
                <th>내용</th>
                <td>
                    <form:textarea path="content" rows="5" cols="50" required="required" htmlEscape="true" />
                    <form:errors path="content" cssClass="error" />
                </td>
            </tr>

            <!-- 파일 업로드 -->
            <tr>
                <th>첨부파일</th>
                <td>
                    <input type="file" id="fileInput" name="files" multiple="multiple"/>
                </td>
            </tr>

            <tr>
                <td colspan="2">
                    <ul id="fileList">
                        <!-- 기존 첨부파일 렌더링 -->
                        <c:if test="${not empty fileList}">
                            <c:forEach var="file" items="${fileList}">
                                <li data-idx="${file.idx}">
                                    ${file.fileName} [${file.fileSize} bytes]
                                    <button type="button"
                                            onclick="removeExistingFile('${file.idx}')">X</button>
                                </li>
                            </c:forEach>
                        </c:if>
                        <!-- 신규 파일은 아래 JS에서 <li class="new">로 append -->
                    </ul>
                </td>
            </tr>

            <!-- 서버에 보낼 삭제 대상 파일 idx (hidden inputs) -->
            <tr style="display:none;">
              <td colspan="2">
                <div id="deleteInputs"></div>
              </td>
            </tr>

            <%-- 검색 파라미터 유지용 필드 --%>
            <c:if test="${not empty param.searchType}">
                <input type="hidden" name="searchType" value="${param.searchType}"/>
            </c:if>
            <c:if test="${not empty param.keyword}">
                <input type="hidden" name="keyword"    value="${param.keyword}"/>
            </c:if>

            <tr>
                <td colspan="2" style="text-align:center;">
                    <input type="submit" value="${not empty board.idx ? '수정하기' : '등록하기'}" />
                    <!-- parentBoardIdx 값에 따라 취소 시 이동 경로 결정 -->
                    <c:choose>
                        <%-- 수정 모드: idx 가 있으면 본인 상세 페이지로 --%>
                        <c:when test="${not empty board.idx}">
                            <c:url var="cancelDetailUrl" value="/board/selectBoard.do">
                                <c:param name="idx" value="${board.idx}"/>
                                <c:if test="${not empty param.searchType}">
                                    <c:param name="searchType" value="${param.searchType}"/>
                                </c:if>
                                <c:if test="${not empty param.keyword}">
                                    <c:param name="keyword" value="${param.keyword}"/>
                                </c:if>
                            </c:url>
                            <input type="button" value="취소" onclick="location.href='${cancelDetailUrl}';" />
                        </c:when>
                        <%-- 등록 모드 --%>
                        <c:otherwise>
                            <c:choose>
                                <%-- 답글 작성 모드: parentBoardIdx 가 있으면 부모 상세로 --%>
                                <c:when test="${not empty board.parentBoardIdx}">
                                    <c:url var="cancelParentUrl" value="/board/selectBoard.do">
                                        <c:param name="idx" value="${board.parentBoardIdx}"/>
                                        <c:if test="${not empty param.searchType}">
                                            <c:param name="searchType" value="${param.searchType}"/>
                                        </c:if>
                                        <c:if test="${not empty param.keyword}">
                                            <c:param name="keyword"    value="${param.keyword}"/>
                                        </c:if>
                                    </c:url>
                                    <input type="button" value="취소" onclick="location.href='${cancelParentUrl}';" />
                                </c:when>
                                <%-- 원글 작성 모드: parentBoardIdx 없으면 메인 목록으로 --%>
                                <c:otherwise>
                                    <c:url var="cancelMainUrl" value="/board/mainBoardList.do">
                                        <c:if test="${not empty param.searchType}">
                                            <c:param name="searchType" value="${param.searchType}"/>
                                        </c:if>
                                        <c:if test="${not empty param.keyword}">
                                            <c:param name="keyword"    value="${param.keyword}"/>
                                        </c:if>
                                    </c:url>
                                    <input type="button" value="취소" onclick="location.href='${cancelMainUrl}';" />
                                </c:otherwise>
                            </c:choose>
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>
        </table>
    </form:form>

    <script>
        $(function(){
            // 선택된 파일을 메모리에서 관리
            var dt = new DataTransfer();

            // 파일 인풋 변경 이벤트 (jQuery)
            $('#fileInput').on('change', function(){
                dt = new DataTransfer(); // 이전 파일 목록 초기화
                $('#fileList li.new').remove(); // 신규 파일 항목만 삭제

                // input.files → DataTransfer로 복사
                $.each(this.files, function(i, file){
                    dt.items.add(file);
                });

                // DataTransfer.files → 화면에 <li>로 표시
                $.each(dt.files, function(i, file){
                    const $li = $('<li class="new">')
                        .text(file.name + ' [' + file.size + ' bytes] ');
                    const $btn = $('<button type="button">X</button>')
                        .on('click', function(){
                            if (confirm('삭제 하시겠습니까?')) { // 삭제 전 확인
                                removeNewFile(file);
                            }
                        });
                    $li.append($btn).appendTo('#fileList');
                });

                // input.files 갱신
                this.files = dt.files;

                console.log('=== 파일 선택 후 상태 ===');
                printStateLog();
            });

            // 새로 선택된 파일 삭제 함수
            function removeNewFile(targetFile) {
                for (let i = 0; i < dt.items.length; i++) {
                    if (dt.items[i].getAsFile() === targetFile) {
                        dt.items.remove(i);
                        break;
                    }
                }
                $('#fileInput')[0].files = dt.files;
                $('#fileInput').trigger('change');  // 리스트 다시 그리기

                console.log('=== 새로운 파일 삭제 후 상태 ===');
                printStateLog();
            }

            // 기존 첨부파일 삭제 처리 (전역 함수)
            window.removeExistingFile = function(idx) {
                // 삭제 전 확인
                if (!confirm('삭제 하시겠습니까?')) {
                    return;
                }
                // 화면에서 해당 <li> 제거
                $('#fileList').find('li[data-idx="' + idx + '"]').remove();
                // 숨은 삭제 파라미터 추가 (폼 전송 시 deleteFileIdx로 넘어감)
                $('<input>')
                    .attr({ type: 'hidden', name: 'deleteFileIdx', value: idx })
                    .appendTo('#deleteInputs');

                console.log('=== 기존 파일에서 삭제 후 상태 ===');
                printStateLog();
            };

            // 로그 출력 함수
            function printStateLog() {
                console.log('▶ 현재 파일 목록:',
                    $('#fileList li').map(function(){
                        // data-idx와 텍스트(파일명)만 추출
                        const idx = $(this).data('idx') || 'new';
                        const name = $(this).text().trim().split(' [')[0];
                        return idx + ':' + name;
                    }).get()
                );
                console.log('▶ 삭제 예정 파일 idx:',
                    $('#deleteInputs input[name="deleteFileIdx"]').map(function(){
                        return $(this).val();
                    }).get()
                );
            }
        });
    </script>
</body>
</html>
