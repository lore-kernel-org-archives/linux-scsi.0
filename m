From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH] add a few missing spaces to MODULE_PARM_DESC() text for qla2xxx
Date: Tue, 17 Jan 2006 21:06:42 +0100
Message-ID: <200601172106.42640.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xproxy.gmail.com ([66.249.82.202]:49523 "EHLO xproxy.gmail.com")
	by vger.kernel.org with ESMTP id S964791AbWAQUGh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jan 2006 15:06:37 -0500
Received: by xproxy.gmail.com with SMTP id i30so1105040wxd
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2006 12:06:37 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jesper Juhl <jesper.juhl@gmail.com>


Add a few spaces to MODULE_PARM_DESC() text for qla2xxx. Without these 
spaces text runs together when modinfo prints the text.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/scsi/qla2xxx/qla_os.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.16-rc1-orig/drivers/scsi/qla2xxx/qla_os.c	2006-01-17 19:14:07.000000000 +0100
+++ linux-2.6.16-rc1/drivers/scsi/qla2xxx/qla_os.c	2006-01-17 21:01:17.000000000 +0100
@@ -39,14 +39,14 @@
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
@@ -74,7 +74,7 @@
 int ql2xprocessrscn;
 module_param(ql2xprocessrscn, int, S_IRUGO|S_IRUSR);
 MODULE_PARM_DESC(ql2xprocessrscn,
-		"Option to enable port RSCN handling via a series of less"
+		"Option to enable port RSCN handling via a series of less "
 		"fabric intrusive ADISCs and PLOGIs.");
 
 /*
