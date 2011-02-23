From: madhu.iyengar@qlogic.com
Subject: [PATCH 07/13] qla2xxx: Pass right CT command string for CT status processing.
Date: Wed, 23 Feb 2011 15:27:12 -0800
Message-ID: <1298503638-22396-8-git-send-email-madhu.iyengar@qlogic.com>
References: <1298503638-22396-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:52633 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755175Ab1BWXab (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Feb 2011 18:30:31 -0500
In-Reply-To: <1298503638-22396-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index a3ea6f0..74a91b6 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1972,7 +1972,7 @@ qla2x00_gff_id(scsi_qla_host_t *vha, sw_info_t *list)
 			    "scsi(%ld): GFF_ID issue IOCB failed "
 			    "(%d).\n", vha->host_no, rval));
 		} else if (qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp,
-			       "GPN_ID") != QLA_SUCCESS) {
+			       "GFF_ID") != QLA_SUCCESS) {
 			DEBUG2_3(printk(KERN_INFO
 			    "scsi(%ld): GFF_ID IOCB status had a "
 			    "failure status code\n", vha->host_no));
-- 
1.6.0.2

