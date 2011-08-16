From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 04/12] qla2xxx: Enable write permission to some debug related module parameters to be changed dynamically.
Date: Tue, 16 Aug 2011 11:31:47 -0700
Message-ID: <1313519515-23122-5-git-send-email-chad.dupuis@qlogic.com>
References: <1313519515-23122-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:9776 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab1HPSol (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Aug 2011 14:44:41 -0400
In-Reply-To: <1313519515-23122-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index ca9c76e..c0d354a 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -143,7 +143,7 @@ MODULE_PARM_DESC(ql2xmultique_tag,
 		"Set it to 1 to turn on the cpu affinity.");
 
 int ql2xfwloadbin;
-module_param(ql2xfwloadbin, int, S_IRUGO);
+module_param(ql2xfwloadbin, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xfwloadbin,
 		"Option to specify location from which to load ISP firmware:.\n"
 		" 2 -- load firmware via the request_firmware() (hotplug).\n"
@@ -158,7 +158,7 @@ MODULE_PARM_DESC(ql2xetsenable,
 		"Default is 0 - skip ETS enablement.");
 
 int ql2xdbwr = 1;
-module_param(ql2xdbwr, int, S_IRUGO);
+module_param(ql2xdbwr, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xdbwr,
 		"Option to specify scheme for request queue posting.\n"
 		" 0 -- Regular doorbell.\n"
@@ -183,7 +183,7 @@ MODULE_PARM_DESC(ql2xasynctmfenable,
 		"Default is 0 - Issue TM IOCBs via mailbox mechanism.");
 
 int ql2xdontresethba;
-module_param(ql2xdontresethba, int, S_IRUGO);
+module_param(ql2xdontresethba, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xdontresethba,
 		"Option to specify reset behaviour.\n"
 		" 0 (Default) -- Reset on failure.\n"
-- 
1.6.0.2


