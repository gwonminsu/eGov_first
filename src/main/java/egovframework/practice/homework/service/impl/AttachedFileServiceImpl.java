package egovframework.practice.homework.service.impl;

import egovframework.practice.homework.service.AttachedFileService;
import egovframework.practice.homework.service.AttachedFileVO;
import org.egovframe.rte.fdl.idgnr.EgovIdGnrService;
import org.egovframe.rte.fdl.property.EgovPropertyService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import java.io.File;
import java.util.List;

@Service("AttachedFileService")
public class AttachedFileServiceImpl implements AttachedFileService {

    private static final Logger log = LoggerFactory.getLogger(AttachedFileServiceImpl.class);

    @Resource(name="attachIdGnrService")
    private EgovIdGnrService idgen1;

    @Resource(name="fileUUIDIdGnrService")
    private EgovIdGnrService idgen2;

    @Resource(name="AttachedFileDAO")
    private AttachedFileDAO dao;

    @Resource(name = "propertiesService")
    protected EgovPropertyService propertiesService;

    // 첨부파일들 저장
    @Override
    public void saveFiles(String boardIdx, MultipartFile[] files) throws Exception {
        if (files == null) return; // 파일 없으면 그냥 리턴
        String baseUploadDir = propertiesService.getString("file.upload.dir"); // 업로드 할 실제 저장 경로
        // 저장 경로가 없으면 만들기
        File uploadDir = new File(baseUploadDir);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        for (MultipartFile mf : files) {
            if (mf.isEmpty()) continue; // 더 이상 파일 없으면 작업 끝
            String idx = idgen1.getNextStringId(); // idx 발급
            String uuid = idgen2.getNextStringId(); // uuid 발급
            String origName = mf.getOriginalFilename();
            String ext = origName.substring(origName.lastIndexOf('.')); // 확장자
            String savedName = uuid + ext; // uuid로 새로운 파일 이름 생성
            File dest = new File(uploadDir, savedName); // 새로운 이름으로 업로드 경로에 파일 생성
            mf.transferTo(dest); // 저장할 파일 객체

            AttachedFileVO vo = new AttachedFileVO();
            vo.setIdx(idx);
            vo.setBoardIdx(boardIdx);
            vo.setFileName(origName);
            vo.setFileUuid(uuid);
            vo.setFilePath(uploadDir.getAbsolutePath());
            vo.setFileSize(mf.getSize());
            vo.setExt(ext);
            dao.insert(vo); // 첨부파일 테이블에 추가
        }
    }

    // idx 파일 하나 조회
    @Override
    public AttachedFileVO getFileByIdx(String fileIdx) throws Exception {
        return dao.selectFileByIdx(fileIdx);
    }

    // 게시물 첨부파일들 가져오기
    @Override
    public List<AttachedFileVO> getFiles(String boardIdx) throws Exception {
        return dao.selectByBoard(boardIdx);
    }

    // 첨부파일 idx들로 점부파일 삭제
    @Override
    public void deleteFiles(String[] fileIdxs) throws Exception {
        if (fileIdxs == null) return;
        for (String idx : fileIdxs) {
            dao.deleteByIdx(idx);
            // (선택) 로컬 파일도 지우려면 파일경로 조회 후 File.delete()
        }
    }

    // 게시물에 등록된 모든 첨부파일들 삭제
    @Override
    public void deleteAllByBoard(String boardIdx) throws Exception {
        // DB에서 해당 게시물의 첨부파일 목록 조회
        List<AttachedFileVO> files = dao.selectByBoard(boardIdx);

        // 물리 파일 삭제
        for (AttachedFileVO vo : files) {
            // 저장 경로 + 파일명 (UUID + 확장자)
            File file = new File(vo.getFilePath(), vo.getFileUuid() + vo.getExt());
            log.info("DELETE 첨부파일 이름: {}", vo.getFileName());
            if (file.exists()) {
                if (!file.delete()) {
                    log.warn("첨부파일 물리 삭제 실패: {}", file.getAbsolutePath());
                }
            }
        }

        // DB 레코드 일괄 삭제
        dao.deleteByBoard(boardIdx);
    }
}
