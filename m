From: vikas.chaudhary@qlogic.com
Subject: [PATCH 1/3] scsi_transport_iscsi: Declare portal type string macros for generic use
Date: Mon, 25 Mar 2013 08:08:31 -0400
Message-ID: <1364213313-17754-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:39451 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756832Ab3CYMb2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Mar 2013 08:31:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, poornima.vonti@qlogic.com, manish.rangankar@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 include/scsi/iscsi_if.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index f1b0183..fe7f06c 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -504,6 +504,10 @@ enum iscsi_host_param {
 	ISCSI_HOST_PARAM_MAX,
 };
 
+/* portal type */
+#define PORTAL_TYPE_IPV4	"ipv4"
+#define PORTAL_TYPE_IPV6	"ipv6"
+
 /* iSCSI Flash Target params */
 enum iscsi_flashnode_param {
 	ISCSI_FLASHNODE_IS_FW_ASSIGNED_IPV6,
-- 
1.8.2.GIT

