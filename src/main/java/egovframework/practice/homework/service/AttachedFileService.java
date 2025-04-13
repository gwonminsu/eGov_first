package egovframework.practice.homework.service;

import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface AttachedFileService {

    // 첨부파일들 저장
    /**
     * 게시글에 첨부된 파일들을 저장한다.
     * 각 파일마다 UUID를 생성하고, 로컬 스토리지에 저장한 뒤 DB에 메타데이터를 기록한다.
     *
     * @param boardIdx 저장 대상 게시글의 idx
     * @param files 업로드된 파일 배열
     * @throws Exception 저장 중 오류 발생 시
     */
    void saveFiles(String boardIdx, MultipartFile[] files) throws Exception;

    // 첨부파일 idx로 하나 조회
    AttachedFileVO getFileByIdx(String fileIdx) throws Exception;

    // 게시물 첨부파일들 가져오기
    /**
     * 지정된 게시글에 첨부된 파일 목록을 조회한다.
     *
     * @param boardIdx 조회 대상 게시글의 idx
     * @return AttachedFileVO 리스트
     * @throws Exception 조회 중 오류 발생 시
     */
    List<AttachedFileVO> getFiles(String boardIdx) throws Exception;

    // 첨부파일 idx들로 점부파일 삭제
    /**
     * 전달받은 첨부파일 idx 배열에 해당하는 파일들을 삭제한다.
     * (로컬 스토리지와 DB 레코드를 모두 삭제)
     *
     * @param fileIdxs 삭제할 첨부파일들의 idx 배열
     * @throws Exception 삭제 중 오류 발생 시
     */
    void deleteFiles(String[] fileIdxs) throws Exception;

    // 게시물에 등록된 모든 첨부파일들 삭제
    /**
     * 특정 게시글에 등록된 모든 첨부파일을 일괄 삭제한다.
     * (게시글 삭제 시 연쇄 삭제 용도)
     *
     * @param boardIdx 대상 게시글의 idx
     * @throws Exception 삭제 중 오류 발생 시
     */
    void deleteAllByBoard(String boardIdx) throws Exception;

}
