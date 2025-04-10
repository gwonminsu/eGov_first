package egovframework.practice.test.service.impl;

import egovframework.practice.test.service.TestVO;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;

// testDAO라는 이름으로 빈 생성
@Repository("testDAO")
public class TestDAO {

    @Resource(name = "sqlSession")
    protected SqlSessionTemplate sqlSession;

    // 전체 목록 조회
    public List<TestVO> selectTestList() throws Exception {
        return sqlSession.selectList("testDAO.selectTestList");
    }

}
