package egovframework.practice.homework.service;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.sql.Timestamp;

@Getter
@Setter
@ToString
@NoArgsConstructor
public class BoardVO {

    private String idx;
    private String author; // 게시자 이름
    private String parentBoardIdx; // 부모 게시글 idx (NULL 가능)
    private String title; // 제목
    private String password; // 비밀번호
    private int hit; // 조회수
    private String content; // 게시글 내용
    private Timestamp createdAt; // 생성 일시
    private Timestamp updatedAt; // 수정 일시

    private int level; // 답글 레벨

    private int number;

    private boolean hasFile; // 첨부파일 존재 여부

}
