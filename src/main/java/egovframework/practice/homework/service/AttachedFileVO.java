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
public class AttachedFileVO {

    private String idx;
    private String boardIdx; // 첨부파일 소속 게시뭉 idx
    private String fileName; // 첨부파일 이름
    private String fileUuid; // 첨부파일 uuid
    private String filePath; // 첨부파일 주소
    private long fileSize; // 첨부파일 사이즈
    private Timestamp createdAt; // 첨부파일 추가 일시

}
