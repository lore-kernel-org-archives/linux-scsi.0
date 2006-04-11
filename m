From: akpm@osdl.org
Subject: [patch 08/15] small whitespace cleanup for qlogic driver
Date: Mon, 10 Apr 2006 23:26:39 -0700
Message-ID: <200604110727.k3B7RLcI015303@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:6024 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932226AbWDKH1r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Apr 2006 03:27:47 -0400
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

 drivers/scsi/qla2xxx/qla_os.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/qla2xxx/qla_os.c~small-whitespace-cleanup-for-qlogic-driver drivers/scsi/qla2xxx/qla_os.c
--- devel/drivers/scsi/qla2xxx/qla_os.c~small-whitespace-cleanup-for-qlogic-driver	2006-03-21 23:05:42.000000000 -0800
+++ devel-akpm/drivers/scsi/qla2xxx/qla_os.c	2006-03-21 23:05:42.000000000 -0800
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
@@ -74,7 +74,7 @@ MODULE_PARM_DESC(ql2xfdmienable,
 int ql2xprocessrscn;
 module_param(ql2xprocessrscn, int, S_IRUGO|S_IRUSR);
 MODULE_PARM_DESC(ql2xprocessrscn,
-		"Option to enable port RSCN handling via a series of less"
+		"Option to enable port RSCN handling via a series of less "
 		"fabric intrusive ADISCs and PLOGIs.");
 
 /*
_
