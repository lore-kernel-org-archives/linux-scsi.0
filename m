From: Ravi Anand <ravi.anand@qlogic.com>
Subject: [RFC] [PATCH 7/7] requested for qla4xxx!!!
Date: Wed, 28 Jun 2006 23:50:53 -0700
Message-ID: <20060629065053.GH7220@ranandlinuxbox.oc.cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:63837 "EHLO avexch2.qlogic.com")
	by vger.kernel.org with ESMTP id S932711AbWF2Gub (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jun 2006 02:50:31 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: open-iscsi <open-iscsi@googlegroups.com>

ISP4xxx driver version.

Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
Signed-off-by: David Somayajulu <david.somayajulu@qlogic.com>
Signed-off-by: Doug Maxey <dwm@bubba.enoyolf.org>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
diff --git a/drivers/scsi/qla4xxx/ql4_version.h b/drivers/scsi/qla4xxx/ql4_version.h
new file mode 100644
index 0000000..c230538
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
+#define QLA4XXX_DRIVER_VERSION	"5.00.05b6-k"
+
+#define QL4_DRIVER_MAJOR_VER	5
+#define QL4_DRIVER_MINOR_VER	0
+#define QL4_DRIVER_PATCH_VER	5
+#define QL4_DRIVER_BETA_VER	6
