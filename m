From: akpm@osdl.org
Subject: [patch 16/22] qla1280: fix section mismatch warnings
Date: Fri, 30 Jun 2006 02:33:14 -0700
Message-ID: <200606300933.k5U9XEsN001729@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:57234 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932116AbWF3Je0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jun 2006 05:34:26 -0400
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
--- a/drivers/scsi/qla1280.c~qla1280-fix-section-mismatch-warnings
+++ a/drivers/scsi/qla1280.c
@@ -4210,7 +4210,7 @@ qla1280_setup(char *s)
 }
 
 
-static int
+static int __init
 qla1280_get_token(char *str)
 {
 	char *sep;
_
