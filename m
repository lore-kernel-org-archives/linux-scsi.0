From: akpm@osdl.org
Subject: [patch 07/22] small whitespace cleanup for qlogic driver
Date: Fri, 30 Jun 2006 02:33:07 -0700
Message-ID: <200606300933.k5U9X7Kv001695@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:58002 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932157AbWF3Je3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jun 2006 05:34:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, jesper.juhl@gmail.com, andrew.vasquez@qlogic.com

From: Jesper Juhl <jesper.juhl@gmail.com>

Add a few spaces to MODULE_PARM_DESC() text for qla2xxx. Without these
spaces text runs together when modinfo prints the text.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/qla2xxx/qla_os.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/qla2xxx/qla_os.c~small-whitespace-cleanup-for-qlogic-driver drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c~small-whitespace-cleanup-for-qlogic-driver
+++ a/drivers/scsi/qla2xxx/qla_os.c
@@ -39,14 +39,14 @@ MODULE_PARM_DESC(ql2xlogintimeout,
 int qlport_down_retry = 30;
 module_param(qlport_down_retry, int, S_IRUGO|S_IRUSR);
 MODULE_PARM_DESC(qlport_down_retry,
-		"Maximum number of command retries to a port that returns"
+		"Maximum number of command retries to a port that returns "
 		"a PORT-DOWN status.");
 
 int ql2xplogiabsentdevice;
 module_param(ql2xplogiabsentdevice, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xplogiabsentdevice,
 		"Option to enable PLOGI to devices that are not present after "
-		"a Fabric scan.  This is needed for several broken switches."
+		"a Fabric scan.  This is needed for several broken switches. "
 		"Default is 0 - no PLOGI. 1 - perfom PLOGI.");
 
 int ql2xloginretrycount = 0;
_
