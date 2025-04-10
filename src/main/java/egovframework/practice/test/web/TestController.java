package egovframework.practice.test.web;

import egovframework.practice.test.service.TestService;
import egovframework.practice.test.service.TestVO;
import org.egovframe.rte.fdl.property.EgovPropertyService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springmodules.validation.commons.DefaultBeanValidator;

import javax.annotation.Resource;
import java.util.List;

@Controller
public class TestController {

    private static final Logger log = LoggerFactory.getLogger(TestController.class);

    @Resource(name = "testService")
    protected TestService testService;

    /** EgovPropertyService */
    @Resource(name = "propertiesService")
    protected EgovPropertyService propertiesService;

    /** Validator */
    @Resource(name = "beanValidator")
    protected DefaultBeanValidator beanValidator;

    // "/testList.do" URL 매핑: 웹 요청을 받아 test_t 테이블의 전체 데이터 목록을 조회 후 JSP로 전달
    @RequestMapping("/testList.do")
    public String selectSampleList(ModelMap model) throws Exception {
        List<TestVO> list = testService.getTestList();
        log.info("SELECT 데이터: {}", list);
        model.addAttribute("testList", list);
        return "testPage";
    }

}
