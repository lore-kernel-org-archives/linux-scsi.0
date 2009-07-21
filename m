From: giridhar.malavali@qlogic.com
Subject: [PATCH 7/9] qla2xxx: Handle RSCN's per master/slave vn-port basis.
Date: Tue, 21 Jul 2009 12:03:43 -0700
Message-ID: <1248203025-507-8-git-send-email-giridhar.malavali@qlogic.com>
References: <1248203025-507-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:37727 "EHLO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753161AbZGUTDv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Jul 2009 15:03:51 -0400
In-Reply-To: <1248203025-507-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Santosh Vernekar <santosh.vernekar@qlogic.com>

From: Santosh Vernekar <santosh.vernekar@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 63e7cdc..40014f3 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -685,7 +685,7 @@ skip_rio:
 		if (vha->vp_idx && test_bit(VP_SCR_NEEDED, &vha->vp_flags))
 			break;
 		/* Only handle SCNs for our Vport index. */
-		if (vha->vp_idx && vha->vp_idx != (mb[3] & 0xff))
+		if (vha->vp_idx != (mb[3] & 0xff))
 			break;
 		DEBUG2(printk("scsi(%ld): Asynchronous RSCR UPDATE.\n",
 		    vha->host_no));
-- 
1.6.2.rc1.30.gd43c

