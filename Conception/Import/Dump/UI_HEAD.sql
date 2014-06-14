--------------------------------------------------------
--  DDL for Procedure UI_HEAD
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "G11_FLIGHT"."UI_HEAD" IS
	path_css varchar2(255) := '/public/css/';
BEGIN
	htp.print('
		<!docTYPE html>
		<!--[IF lte IE 7]> <html class="no-js ie67 ie678" lang="fr"> <![endIF]-->
		<!--[IF IE 8]> <html class="no-js ie8 ie678" lang="fr"> <![endIF]-->
		<!--[IF IE 9]> <html class="no-js ie9" lang="fr"> <![endIF]-->
		<!--[IF gt IE 9]> <!--><html class="no-js" lang="fr"> <!--<![endIF]-->
		<head>
			<meta charset="UTF-8">
			<!--[IF IE]><meta http-equiv="X-UA-Compatible" content="IE=edge"><![endIF]-->
			<title>Tour de France ' || GETSELECTEDTOUR || '</title>
			<meta name="viewport" content="width=device-width, initial-scale=1.0">
			<!--[IF lt IE 9]>
			<script src="//html5shiv.googlecode.com/svn/trunk/html5.js"></script>
			<![endIF]-->
			<link rel="stylesheet" href="' || path_css ||'knacss.css" media="all">
			<link rel="stylesheet" href="' || path_css ||'styles.css" media="all">
		</head>
		<body>');
END UI_HEAD;

/
