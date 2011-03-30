From: madhu.iyengar@qlogic.com
Subject: [PATCH 10/18] qla2xxx: Remove extra call to qla82xx_check_fw_alive().
Date: Wed, 30 Mar 2011 11:46:25 -0700
Message-ID: <1301510793-2492-11-git-send-email-madhu.iyengar@qlogic.com>
References: <1301510793-2492-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:45792 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S932179Ab1C3SvS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2011 14:51:18 -0400
In-Reply-To: <1301510793-2492-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

The stanadlone call to qla82xx_check_fw_alive() in qla82xx_watchdog()
is a typo, so remove it.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index d823098..6e4b429 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -3647,7 +3647,6 @@ void qla82xx_watchdog(scsi_qla_host_t *vha)
 			set_bit(ISP_QUIESCE_NEEDED, &vha->dpc_flags);
 			qla2xxx_wake_dpc(vha);
 		} else {
-			qla82xx_check_fw_alive(vha);
 			if (qla82xx_check_fw_alive(vha)) {
 				halt_status = qla82xx_rd_32(ha,
 				    QLA82XX_PEG_HALT_STATUS1);
-- 
1.6.0.2

