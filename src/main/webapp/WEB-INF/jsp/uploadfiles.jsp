<%@ page language="java" pageEncoding="utf-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="utf-8">
    <title>jQuery File Upload Example</title>

    <link rel="stylesheet" href="css/jquery-ui.min.css">
    <link rel="stylesheet" href="css/jquery-ui.structure.min.css">
    <link rel="stylesheet" href="css/jquery-ui.theme.min.css">
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/jquery.fileupload.css">
    <link rel="stylesheet" href="css/jquery.fileupload-ui.css">

    <script type="text/javascript" src="js/jquery.min.js"></script>
    <script type="text/javascript" src="js/jquery-ui.min.js"></script>
    <script type="text/javascript" src="js/bootstrap.min.js"></script>
    <script type="text/javascript" src="js/layer.js"></script>
    <script type="text/javascript" src="js/vendor/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="js/jquery.iframe-transport.js"></script>
	<script type="text/javascript" src="js/load-image.all.min.js"></script>
    <script type="text/javascript" src="js/jquery.fileupload.js"></script>
    <script type="text/javascript" src="js/jquery.fileupload-process.js"></script>
    <script type="text/javascript" src="js/jquery.fileupload-image.js"></script>
    <script type="text/javascript" src="js/jquery.fileupload-audio.js"></script>
    <script type="text/javascript" src="js/jquery.fileupload-video.js"></script>
    <script type="text/javascript" src="js/jquery.fileupload-validate.js"></script>
	<script type="text/javascript" src="js/jquery.fileupload-ui.js"></script>
    <script type="text/javascript" src="js/jquery.fileupload-jquery-ui.js"></script>

	<style type="text/css">
		.progress-bar {
			height: 18px;
			background: blue;
		}
	</style>
</head>
<body>
	<h5>jQuery File Upload</h5>

    <input id="uploadFilesID" name="uploadFiles" type="file" multiple>
    <div id="progressID">
		<div class="progress-bar" style="width:0%;"></div>
    </div>
    <div id="filesID"></div>
    <div id="validID"></div>
	<div id="previewID"></div>
	<div id="responseID"></div>
	<div>
		<button id="submitID" style="display: none">提交</button>
	</div>

    <script type="text/javascript">
        $(function () {
			'use strict';

			var url = 'uploadFiles.do';
            $('#uploadFilesID').fileupload({
                url: url,
                type: 'post',
                dataType: 'json',
                autoUpload: false,
                disableValidation: false,
                forceIframeTransport: true,
                acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i,
                maxNumberOfFiles: 64,
                maxFileSize: 10*1024*1024,
                minFileSize: 1,
                messages: {
					acceptFileTypes: '文件类型不匹配!',
                    maxNumberOfFiles: '文件过多!',
                    maxFileSize: '文件过大!',
                    minFileSize: '文件过小!'
                },
                previewMaxWidth: 256,
                previewMaxHeight: 256,
                previewCrop: true,
            }).on('fileuploadadd', function(e, data) {
                console.log(data);
                console.log(data.files);

				$.each(data.files, function(index, file) {
					console.log(file);
					$('<p/>').text(file.name).appendTo('#filesID');

					if(data.files.length === index + 1) {
						$('#submitID').off('click').on('click', function() {
							data.submit();
						});
					}
				});
			}).on('fileuploadprocessalways', function(e, data) {
                console.log(data);
                console.log(data.files);

                var index = data.index;
                var file = data.files[index];
                console.log(index);
				console.log(file);

				if(file.error) {
					layer.alert(file.error);
					$("#validID").append('<br>').append(file.error);
					return false;
				}
				if(file.preview) {
					$("#previewID").append('<br>').append(file.preview);
				}

				if(data.files.length === index + 1) {
					layer.alert("添加成功!");
					$("#submitID").css('display', 'block');
					return true;
				}
			}).on('fileuploadprogressall', function(e, data) {
                console.log(data);

                var progress = parseInt(data.loaded / data.total * 100, 10);
                $('#progressID .progress-bar').css('width', progress + '%');
			}).on('fileuploaddone', function(e, data) {
				console.log(data);
				console.log(data.result);

                $.each(data.result.files, function (index, file) {
                    console.log(file);
                    $('<p/>').text(file).appendTo('#responseID');
                });
                layer.alert("上传成功!");
                return true;
			}).on('fileuploadfail', function(e, data) {
                console.log(data);
                console.log(data.files);

				$.each(data.files, function(index, file) {
					console.log(file);
				});
                layer.alert("上传失败!");
                return false;
			});
        });
    </script>
</body>
</html>
