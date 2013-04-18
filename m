From: James Smart <james.smart@emulex.com>
Subject: [PATCH 9/22] lpfc 8.3.39: Fix lpfc_fcp_look_ahead module parameter
Date: Wed, 17 Apr 2013 20:17:13 -0400
Message-ID: <1366244233.1513.10.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:24311 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935849Ab3DRARR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Apr 2013 20:17:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix lpfc_fcp_look_ahead module parameter


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_attr.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2013-04-15 18:26:36.982041119 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2013-04-15 18:26:38.186041147 -0400
@@ -4016,12 +4016,11 @@ LPFC_ATTR_R(enable_bg, 0, 0, 1, "Enable
 #       0  = disabled (default)
 #       1  = enabled
 # Value range is [0,1]. Default value is 0.
+#
+# This feature in under investigation and may be supported in the future.
 */
 unsigned int lpfc_fcp_look_ahead = LPFC_LOOK_AHEAD_OFF;
 
-module_param(lpfc_fcp_look_ahead, uint, S_IRUGO);
-MODULE_PARM_DESC(lpfc_fcp_look_ahead, "Look ahead for completions");
-
 /*
 # lpfc_prot_mask: i
 #	- Bit mask of host protection capabilities used to register with the



