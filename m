From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 06/14] qla2xxx: Enable Minidump by default with default capture mask 0x1f.
Date: Fri, 18 Nov 2011 09:02:14 -0800
Message-ID: <1321635742-16426-7-git-send-email-chad.dupuis@qlogic.com>
References: <1321635742-16426-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:43600
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757567Ab1KRRP2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2011 12:15:28 -0500
In-Reply-To: <1321635742-16426-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index abec1dd..71d6259 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -201,12 +201,12 @@ MODULE_PARM_DESC(ql2xmdcapmask,
 		"Set the Minidump driver capture mask level. "
 		"Default is 0x7F - Can be set to 0x3, 0x7, 0xF, 0x1F, 0x7F.");
 
-int ql2xmdenable;
+int ql2xmdenable = 1;
 module_param(ql2xmdenable, int, S_IRUGO);
 MODULE_PARM_DESC(ql2xmdenable,
 		"Enable/disable MiniDump. "
-		"0 (Default) - MiniDump disabled. "
-		"1 - MiniDump enabled.");
+		"0 - MiniDump disabled. "
+		"1 (Default) - MiniDump enabled.");
 
 /*
  * SCSI host template entry points
-- 
1.6.0.2


