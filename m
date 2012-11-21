From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 16/19] qla2xxx: Update ql2xextended_error_logging parameter description with new option.
Date: Wed, 21 Nov 2012 02:40:41 -0500
Message-ID: <1353483644-17262-17-git-send-email-saurav.kashyap@qlogic.com>
References: <1353483644-17262-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:61214 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753203Ab2KUH64 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2012 02:58:56 -0500
In-Reply-To: <1353483644-17262-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

Update the parameter description for the ql2xextended_error_logging parameter
with the following new option:

0x00008000 - Verbose output
0x00004000 - Target mode
0x00002000 - Target mode management
0x00001000 - Target mode task management

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 9ad66a3..6af369b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -89,6 +89,8 @@ MODULE_PARM_DESC(ql2xextended_error_logging,
 		"\t\t0x00200000 - AER/EEH.       0x00100000 - Multi Q.\n"
 		"\t\t0x00080000 - P3P Specific.  0x00040000 - Virtual Port.\n"
 		"\t\t0x00020000 - Buffer Dump.   0x00010000 - Misc.\n"
+		"\t\t0x00008000 - Verbose.       0x00004000 - Target.\n"
+		"\t\t0x00002000 - Target Mgmt.   0x00001000 - Target TMF.\n"
 		"\t\t0x7fffffff - For enabling all logs, can be too many logs.\n"
 		"\t\t0x1e400000 - Preferred value for capturing essential "
 		"debug information (equivalent to old "
-- 
1.7.7

