From: Doug Maxey <dwm@maxeymade.com>
Subject: Re: [CMT 16/16] qla4xxx: driver review ql4_version.h
Date: Sat, 01 Apr 2006 17:35:03 -0600
Message-ID: <200604012335.k31NZ3Jc006322@falcon30.maxeymade.com>
Reply-To: dwm@maxeymade.com
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:16611 "EHLO
	falcon30.maxeymade.com") by vger.kernel.org with ESMTP
	id S932316AbWDAXfO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 1 Apr 2006 18:35:14 -0500
In-reply-to: 200604010418.k314Iqam008288@falcon30.maxeymade.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ravi Anand <ravi.anand@qlogic.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Does this file need any multiple inclusion protection?

Now moving on to the honeydo's.  The wife is starting to tap her
foot. ;-)

++doug
--
diff --git a/drivers/scsi/qla4xxx/ql4_version.h b/drivers/scsi/qla4xxx/ql4_version.h
new file mode 100644
index 0000000..c9326b4
--- /dev/null
+++ b/drivers/scsi/qla4xxx/ql4_version.h
@@ -0,0 +1,13 @@
+/*
+ * QLogic iSCSI HBA Driver
+ * Copyright (c)  2003-2006 QLogic Corporation
+ *
+ * See LICENSE.qla4xxx for copyright and licensing details.
+ */
+
+#define QLA4XXX_DRIVER_VERSION      "5.00.05b5-k"
+
+#define QL4_DRIVER_MAJOR_VER	5
+#define QL4_DRIVER_MINOR_VER	0
+#define QL4_DRIVER_PATCH_VER	5
+#define QL4_DRIVER_BETA_VER	5
