From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 06/11] qla4xxx: Handle one H/W Interrupt at a time
Date: Thu, 17 Jun 2010 02:22:37 +0530
Message-ID: <20100616205237.GA8168@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:25187
	"HELO sles11sp1b1.site" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1753576Ab0FPUyJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2010 16:54:09 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: ravi.anand@qlogic.com, vikas.chaudhary@qlogic.com

From: Ravi Anand <ravi.anand@qlogic.com>

Handle one H/W Interrupt at a time to prevent holding off H/W lock
for longer period of time.

Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 2b53c79..b47ded2 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -118,7 +118,7 @@
 #define DRIVER_NAME			"qla4xxx"
 
 #define MAX_LINKED_CMDS_PER_LUN		3
-#define MAX_REQS_SERVICED_PER_INTR	16
+#define MAX_REQS_SERVICED_PER_INTR	1
 
 #define ISCSI_IPADDR_SIZE		4	/* IP address size */
 #define ISCSI_ALIAS_SIZE		32	/* ISCSI Alias name size */
-- 
1.7.0.5

