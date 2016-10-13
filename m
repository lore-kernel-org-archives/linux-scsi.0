From: james.smart@broadcom.com (James Smart)
Subject: [PATCH v3 07/17] lpfc: Code cleanup for lpfc_enable_rrq parameter
Date: Thu, 13 Oct 2016 15:06:08 -0700
Message-ID: <58000550.mGmznF0pv+Q11PU7%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sgpsmtp1.avagotech.com ([202.86.248.61]:55289 "EHLO
        sgpsmtp1.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756992AbcJMWQg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Oct 2016 18:16:36 -0400
Received: from flash (fx9xs32.emulex.com [10.230.226.120])
        by sgpsmtp1.avagotech.com (Postfix) with SMTP id 6E7EA10074E
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2016 15:06:10 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Code cleanup for lpfc_enable_rrq parameter

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_attr.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index e5092dc..22a66c7 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -2759,18 +2759,14 @@ LPFC_ATTR_R(enable_npiv, 1, 0, 1,
 LPFC_ATTR_R(fcf_failover_policy, 1, 1, 2,
 	"FCF Fast failover=1 Priority failover=2");
 
-int lpfc_enable_rrq = 2;
-module_param(lpfc_enable_rrq, int, S_IRUGO);
-MODULE_PARM_DESC(lpfc_enable_rrq, "Enable RRQ functionality");
-lpfc_param_show(enable_rrq);
 /*
 # lpfc_enable_rrq: Track XRI/OXID reuse after IO failures
 #	0x0 = disabled, XRI/OXID use not tracked.
 #	0x1 = XRI/OXID reuse is timed with ratov, RRQ sent.
 #	0x2 = XRI/OXID reuse is timed with ratov, No RRQ sent.
 */
-lpfc_param_init(enable_rrq, 2, 0, 2);
-static DEVICE_ATTR(lpfc_enable_rrq, S_IRUGO, lpfc_enable_rrq_show, NULL);
+LPFC_ATTR_R(enable_rrq, 2, 0, 2,
+	"Enable RRQ functionality");
 
 /*
 # lpfc_suppress_link_up:  Bring link up at initialization
-- 
2.5.0


