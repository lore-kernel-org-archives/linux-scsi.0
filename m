From: akpm@osdl.org
Subject: [patch 24/31] qla1280: fix section mismatch warnings
Date: Thu, 08 Jun 2006 22:23:55 -0700
Message-ID: <200606090523.k595Nuta032337@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:21469 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965183AbWFIFYJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jun 2006 01:24:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, rdunlap@xenotime.net, andrew.vasquez@qlogic.com


From: Randy Dunlap <rdunlap@xenotime.net>

Fix section mismatch warnings:
WARNING: drivers/scsi/qla1280.o - Section mismatch: reference to
.init.data: from .text between 'qla1280_get_token' (at offset 0x2a16)
and 'qla1280_probe_one'
WARNING: drivers/scsi/qla1280.o - Section mismatch: reference to
.init.data: from .text between 'qla1280_get_token' (at offset 0x2a3c)
and 'qla1280_probe_one'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/qla1280.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/qla1280.c~qla1280-fix-section-mismatch-warnings drivers/scsi/qla1280.c
--- devel/drivers/scsi/qla1280.c~qla1280-fix-section-mismatch-warnings	2006-06-01 20:41:52.000000000 -0700
+++ devel-akpm/drivers/scsi/qla1280.c	2006-06-01 20:41:52.000000000 -0700
@@ -4210,7 +4210,7 @@ qla1280_setup(char *s)
 }
 
 
-static int
+static int __init
 qla1280_get_token(char *str)
 {
 	char *sep;
_
