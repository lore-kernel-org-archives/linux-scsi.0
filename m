From: Doug Maxey <dwm@maxeymade.com>
Subject: Re: [CMT 15/16] qla4xxx: driver review ql4_settings.h
Date: Sat, 01 Apr 2006 17:29:07 -0600
Message-ID: <200604012329.k31NT7qO004161@falcon30.maxeymade.com>
Reply-To: dwm@maxeymade.com
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:48257 "EHLO
	falcon30.maxeymade.com") by vger.kernel.org with ESMTP
	id S932314AbWDAX3S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 1 Apr 2006 18:29:18 -0500
In-reply-to: 200604010418.k314Iqam008288@falcon30.maxeymade.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ravi Anand <ravi.anand@qlogic.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

As this file is content free, please just delete it.

++doug
--
diff --git a/drivers/scsi/qla4xxx/ql4_settings.h b/drivers/scsi/qla4xxx/ql4_settings.h
new file mode 100644
index 0000000..94a51db
--- /dev/null
+++ b/drivers/scsi/qla4xxx/ql4_settings.h
@@ -0,0 +1,11 @@
+/*
+ * QLogic iSCSI HBA Driver
+ * Copyright (c)  2003-2006 QLogic Corporation
+ *
+ * See LICENSE.qla4xxx for copyright and licensing details.
+ */
+
+/*
+ * Compile time Options:
+ *     0 - Disable and 1 - Enable
+ */
