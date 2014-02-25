From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 02/10] qla4xxx: Change default capture to firmware defined capture mask
Date: Mon, 24 Feb 2014 22:06:57 -0500
Message-ID: <1393297625-928-3-git-send-email-vikas.chaudhary@qlogic.com>
References: <1393297625-928-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:55438 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752653AbaBYDnM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Feb 2014 22:43:12 -0500
In-Reply-To: <1393297625-928-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Tej Parkash <tej.parkash@qlogic.com>

From: Tej Parkash <tej.parkash@qlogic.com>

Signed-off-by: Tej Parkash <tej.parkash@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 2e95be4..fb90c9d 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -83,11 +83,11 @@ MODULE_PARM_DESC(ql4xsess_recovery_tmo,
 		" Target Session Recovery Timeout.\n"
 		"\t\t  Default: 120 sec.");
 
-int ql4xmdcapmask = 0x1F;
+int ql4xmdcapmask = 0;
 module_param(ql4xmdcapmask, int, S_IRUGO);
 MODULE_PARM_DESC(ql4xmdcapmask,
 		 " Set the Minidump driver capture mask level.\n"
-		 "\t\t  Default is 0x1F.\n"
+		 "\t\t  Default is 0 (firmware default capture mask)\n"
 		 "\t\t  Can be set to 0x3, 0x7, 0xF, 0x1F, 0x3F, 0x7F");
 
 int ql4xenablemd = 1;
-- 
1.8.2.GIT

