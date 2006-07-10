From: David Somayajulu <david.somayajulu@qlogic.com>
Subject: [RFC] [PATCH 7/7] qla4xxx: driver version
Date: Mon, 10 Jul 2006 17:02:45 -0400
Message-ID: <1152565365.17882.64.camel@davlnxhost.QLOGIC>
References: <1152564679.17882.49.camel@davlnxhost.QLOGIC>
	 <1152564896.17882.53.camel@davlnxhost.QLOGIC>
	 <1152565021.17882.55.camel@davlnxhost.QLOGIC>
	 <1152565134.17882.58.camel@davlnxhost.QLOGIC>
	 <1152565261.17882.61.camel@davlnxhost.QLOGIC>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:11428 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S965337AbWGKACp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jul 2006 20:02:45 -0400
In-Reply-To: <1152565261.17882.61.camel@davlnxhost.QLOGIC>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: open-iscsi@googlegroups.com, David Wagner <david.wagner@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Duane Grigsby <duane.grigsby@qlogic.com>, David Somayajulu <david.somayajulu@qlogic.com>

qla4xxx driver version.

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
+#define QLA4XXX_DRIVER_VERSION	"5.00.05b7-k"
+
+#define QL4_DRIVER_MAJOR_VER	5
+#define QL4_DRIVER_MINOR_VER	0
+#define QL4_DRIVER_PATCH_VER	5
+#define QL4_DRIVER_BETA_VER	7

