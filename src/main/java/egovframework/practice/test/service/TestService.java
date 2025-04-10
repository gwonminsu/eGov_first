package egovframework.practice.test.service;

import java.util.List;

// Service 인터페이스
public interface TestService {

    // 데이터 목록 조회
    List<TestVO> getTestList() throws Exception;

}
