From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 10/18] qla2xxx: Corrected the default setting of the help text of Minidump capture mask.
Date: Fri, 18 Nov 2011 09:03:14 -0800
Message-ID: <1321635802-16491-11-git-send-email-chad.dupuis@qlogic.com>
References: <1321635802-16491-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:27394
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758254Ab1KRRQ3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2011 12:16:29 -0500
In-Reply-To: <1321635802-16491-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic>
---
 drivers/scsi/qla2xxx/qla_os.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 51c4655..b3028f5 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -202,7 +202,7 @@ int ql2xmdcapmask = 0x1F;
 module_param(ql2xmdcapmask, int, S_IRUGO);
 MODULE_PARM_DESC(ql2xmdcapmask,
 		"Set the Minidump driver capture mask level. "
-		"Default is 0x7F - Can be set to 0x3, 0x7, 0xF, 0x1F, 0x7F.");
+		"Default is 0x1F - Can be set to 0x3, 0x7, 0xF, 0x1F, 0x7F.");
 
 int ql2xmdenable = 1;
 module_param(ql2xmdenable, int, S_IRUGO);
-- 
1.6.0.2


