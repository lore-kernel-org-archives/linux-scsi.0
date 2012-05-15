From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 19/22] qla2xxx: Display proper firmware version when new minidump template is gathered for ISP82xx.
Date: Tue, 15 May 2012 14:34:26 -0400
Message-ID: <1337106869-14191-20-git-send-email-chad.dupuis@qlogic.com>
References: <1337106869-14191-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:51161 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S966209Ab2EOS5Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 May 2012 14:57:24 -0400
In-Reply-To: <1337106869-14191-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index e957487..caf627b 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -3159,11 +3159,11 @@ qla82xx_check_md_needed(scsi_qla_host_t *vha)
 				    "Firmware version differs "
 				    "Previous version: %d:%d:%d - "
 				    "New version: %d:%d:%d\n",
+				    fw_major_version, fw_minor_version,
+				    fw_subminor_version,
 				    ha->fw_major_version,
 				    ha->fw_minor_version,
-				    ha->fw_subminor_version,
-				    fw_major_version, fw_minor_version,
-				    fw_subminor_version);
+				    ha->fw_subminor_version);
 				/* Release MiniDump resources */
 				qla82xx_md_free(vha);
 				/* ALlocate MiniDump resources */
-- 
1.7.7

