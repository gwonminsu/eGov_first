package egovframework.practice.test.service.impl;

import egovframework.practice.test.service.TestService;
import egovframework.practice.test.service.TestVO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

// Service 구현체
@Service("testService")
public class TestServiceImpl implements TestService {

    // 로거
    private static final Logger LOGGER = LoggerFactory.getLogger(TestServiceImpl.class);

    @Resource(name = "testDAO")
    protected TestDAO testDAO;

    // 데이터 리스트 조회
    @Override
    public List<TestVO> getTestList() throws Exception {
        return testDAO.selectTestList();
    }
}
