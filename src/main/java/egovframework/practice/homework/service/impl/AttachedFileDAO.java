package egovframework.practice.homework.service.impl;

import egovframework.practice.homework.service.AttachedFileVO;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;

@Repository("AttachedFileDAO")
public class AttachedFileDAO {

    @Resource(name="sqlSession")
    protected SqlSessionTemplate sqlSession;

    // 첨부 파일 등록
    public void insert(AttachedFileVO vo) {
        sqlSession.insert("AttachedFileDAO.insert", vo);
    }

    // 게시물 첨부 파일 목록 가져오기
    public List<AttachedFileVO> selectByBoard(String boardIdx) {
        return sqlSession.selectList("AttachedFileDAO.selectByBoard", boardIdx);
    }

    // 첨부파일 idx로 하나 조회
    public AttachedFileVO selectFileByIdx(String idx) {
        return sqlSession.selectOne("AttachedFileDAO.selectFileByIdx", idx);
    }

    // 첨부 파일 idx로 삭제
    public void deleteByIdx(String idx) {
        sqlSession.delete("AttachedFileDAO.deleteByIdx", idx);
    }

    // 게시물에 소속된 첨부 파일들 삭제
    public void deleteByBoard(String boardIdx) {
        sqlSession.delete("AttachedFileDAO.deleteByBoard", boardIdx);
    }

}
