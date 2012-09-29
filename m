From: James Smart <james.smart@emulex.com>
Subject: [PATCH 03/16] lpfc 8.3.35: Fix incorrect comment in T10 DIF
 attributes
Date: Sat, 29 Sep 2012 11:29:17 -0400
Message-ID: <1348932557.23909.22.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:35003 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351Ab2I2Peu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Sep 2012 11:34:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix incorrect comment in T10 DIF attributes


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_attr.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2012-09-26 20:19:47.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2012-09-26 21:11:31.694153802 -0400
@@ -3935,6 +3935,12 @@ MODULE_PARM_DESC(lpfc_fcp_look_ahead, "L
 # 	- Only meaningful if BG is turned on (lpfc_enable_bg=1).
 #	- Allows you to ultimately specify which profiles to use
 #	- Default will result in registering capabilities for all profiles.
+#	- SHOST_DIF_TYPE1_PROTECTION	1
+#		HBA supports T10 DIF Type 1: HBA to Target Type 1 Protection
+#	- SHOST_DIX_TYPE0_PROTECTION	8
+#		HBA supports DIX Type 0: Host to HBA protection only
+#	- SHOST_DIX_TYPE1_PROTECTION	16
+#		HBA supports DIX Type 1: Host to HBA  Type 1 protection
 #
 */
 unsigned int lpfc_prot_mask = SHOST_DIF_TYPE1_PROTECTION |
@@ -3947,7 +3953,7 @@ MODULE_PARM_DESC(lpfc_prot_mask, "host p
 /*
 # lpfc_prot_guard: i
 #	- Bit mask of protection guard types to register with the SCSI mid-layer
-# 	- Guard types are currently either 1) IP checksum 2) T10-DIF CRC
+#	- Guard types are currently either 1) T10-DIF CRC 2) IP checksum
 #	- Allows you to ultimately specify which profiles to use
 #	- Default will result in registering capabilities for all guard types
 #



