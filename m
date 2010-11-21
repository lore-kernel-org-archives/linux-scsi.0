From: James Smart <james.smart@emulex.com>
Subject: [PATCH 5/6] lpfc 8.3.19: Change heartbeat to default to disabled
Date: Sat, 20 Nov 2010 23:12:02 -0500
Message-ID: <1290312722.32645.14.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:23292 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752779Ab0KUEOj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Nov 2010 23:14:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org



Change heartbeat to default to disabled

 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_attr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2010-11-19 16:11:02.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2010-11-19 16:11:19.000000000 -0500
@@ -3305,12 +3305,12 @@ LPFC_ATTR_R(fcp_eq_count, LPFC_FP_EQN_DE
 LPFC_ATTR_R(enable_hba_reset, 1, 0, 1, "Enable HBA resets from the driver.");
 
 /*
-# lpfc_enable_hba_heartbeat: Enable HBA heartbeat timer..
+# lpfc_enable_hba_heartbeat: Disable HBA heartbeat timer..
 #       0  = HBA Heartbeat disabled
 #       1  = HBA Heartbeat enabled (default)
 # Value range is [0,1]. Default value is 1.
 */
-LPFC_ATTR_R(enable_hba_heartbeat, 1, 0, 1, "Enable HBA Heartbeat.");
+LPFC_ATTR_R(enable_hba_heartbeat, 0, 0, 1, "Enable HBA Heartbeat.");
 
 /*
 # lpfc_enable_bg: Enable BlockGuard (Emulex's Implementation of T10-DIF)


