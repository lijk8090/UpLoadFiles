package cn.com.infosec.uploadfiles.controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

@Controller
public class UpLoadFiles {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Value("${uploadfiles.pathname}")
	private String pathanme;

	public String uploadFile(MultipartFile srcFile, String dstPath) throws IOException {

		String name = srcFile.getOriginalFilename();

		if (srcFile.isEmpty()) {
			return null;
		}

		String file = dstPath + "/" + name;
		Path path = Paths.get(file);

		byte[] bytes = srcFile.getBytes();
		Files.write(path, bytes);

		logger.info(name);
		return name;
	}

	public List<String> uploadFiles(MultipartFile[] srcFiles, String dstPath) throws IOException {

		List<String> list = new ArrayList<String>();

		for (int i = 0; i < srcFiles.length; i++) {
			MultipartFile srcFile = srcFiles[i];

			String name = this.uploadFile(srcFile, dstPath);
			if (name == null) {
				return null;
			}
			list.add(name);
		}

		System.out.println(list);
		return list;
	}

	@RequestMapping("/")
	public String indexController(ModelMap modelMap) {

		logger.info("uploadfiles: /WEB-INF/jsp/uploadfiles.jsp");
		return "uploadfiles";
	}

	@ResponseBody
	@RequestMapping(value = "uploadFiles.do", method = RequestMethod.POST)
	public Map<String, Object> uploadFilesController(
			@RequestParam(value = "uploadFiles", required = true) MultipartFile[] uploadFiles) throws IOException {

		Map<String, Object> map = new HashMap<String, Object>();
		List<String> list = uploadFiles(uploadFiles, pathanme);
		if (list == null) {
			return null;
		}
		map.put("files", list);

		System.out.println(map);
		return map;
	}

}
