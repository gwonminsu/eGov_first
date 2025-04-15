package egovframework.practice.homework.service;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

// 페이지네이션을 위한 VO
@Getter
@Setter
@ToString
public class BoardDefaultVO {

    private static final long serialVersionUID = 1L; // 자바의 직렬화(Serialization) 기능을 사용할 때, 클래스의 버전을 식별하기 위해 쓰이는 고유 식별자
    private String searchType;
    private String keyword;
    private int pageIndex = 1; // 현재 페이지
    private int pageUnit = 10; // 한 페이지 레코드 수
    private int pageSize = 10; // 페이지 번호 블록 크기
    private int firstIndex; // MyBatis 조회 시작 row
    private int lastIndex;  // 페이징 조회 종료 인덱스
    private int recordCountPerPage; // 한 페이지당 실제 조회할 레코드 수

}
