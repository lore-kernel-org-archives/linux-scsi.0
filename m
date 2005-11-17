From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [PATCH 2/7]  mptfusion - adding = THIS_MODULE
Date: Wed, 16 Nov 2005 18:54:14 -0700
Message-ID: <200511161854.14799.Eric.Moore@lsil.com>
Reply-To: Eric.Moore@lsil.com
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_GL+eDuyJSkhF0FT"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:3714 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1161090AbVKQB7q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Nov 2005 20:59:46 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id jAH1t4SW011538
	for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2005 17:55:04 -0800 (PST)
Received: from mailmux (popmil.lsil.com [147.145.13.217])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with SMTP id jAH1xjs8001923
	for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2005 17:59:45 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux scsi <linux-scsi@vger.kernel.org>


--Boundary-00=_GL+eDuyJSkhF0FT
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Self explanatory patch.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>


--Boundary-00=_GL+eDuyJSkhF0FT
Content-Type: text/x-diff;
  charset="us-ascii";
  name="2-module-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="2-module-fix.patch"

diff -uarN b/drivers/message/fusion/mptfc.c a/drivers/message/fusion/mptfc.c
--- b/drivers/message/fusion/mptfc.c	2005-10-27 18:02:08.000000000 -0600
+++ a/drivers/message/fusion/mptfc.c	2005-11-16 17:22:38.000000000 -0700
@@ -84,6 +84,7 @@
 static int	mptfcInternalCtx = -1; /* Used only for internal commands */
 
 static struct scsi_host_template mptfc_driver_template = {
+	.module				= THIS_MODULE,
 	.proc_name			= "mptfc",
 	.proc_info			= mptscsih_proc_info,
 	.name				= "MPT FC Host",
diff -uarN b/drivers/message/fusion/mptsas.c a/drivers/message/fusion/mptsas.c
--- b/drivers/message/fusion/mptsas.c	2005-11-16 12:54:28.000000000 -0700
+++ a/drivers/message/fusion/mptsas.c	2005-11-16 17:23:02.000000000 -0700
@@ -277,6 +277,7 @@
 }
 
 static struct scsi_host_template mptsas_driver_template = {
+	.module				= THIS_MODULE,
 	.proc_name			= "mptsas",
 	.proc_info			= mptscsih_proc_info,
 	.name				= "MPT SPI Host",
diff -uarN b/drivers/message/fusion/mptspi.c a/drivers/message/fusion/mptspi.c
--- b/drivers/message/fusion/mptspi.c	2005-10-27 18:02:08.000000000 -0600
+++ a/drivers/message/fusion/mptspi.c	2005-11-16 17:22:29.000000000 -0700
@@ -103,6 +103,7 @@
 static int	mptspiInternalCtx = -1; /* Used only for internal commands */
 
 static struct scsi_host_template mptspi_driver_template = {
+	.module				= THIS_MODULE,
 	.proc_name			= "mptspi",
 	.proc_info			= mptscsih_proc_info,
 	.name				= "MPT SPI Host",

--Boundary-00=_GL+eDuyJSkhF0FT--
