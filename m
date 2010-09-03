From: madhu.iyengar@qlogic.com
Subject: [PATCH 2/7] qla2xxx: make rport deletions explicit during vport removal
Date: Fri,  3 Sep 2010 14:57:01 -0700
Message-ID: <1283551026-3886-3-git-send-email-madhu.iyengar@qlogic.com>
References: <1283551026-3886-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:42963 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753251Ab0ICWDH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Sep 2010 18:03:07 -0400
In-Reply-To: <1283551026-3886-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: nkmi@yahoo.com

From: Arun Easi <arun.easi@qlogic.com>


Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mid.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index bc1a745..2b69392 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -135,7 +135,6 @@ qla2x00_mark_vp_devices_dead(scsi_qla_host_t *vha)
 		    "loop_id=0x%04x :%x\n",
 		    vha->host_no, fcport->loop_id, fcport->vp_idx));
 
-		atomic_set(&fcport->state, FCS_DEVICE_DEAD);
 		qla2x00_mark_device_lost(vha, fcport, 0, 0);
 		atomic_set(&fcport->state, FCS_UNCONFIGURED);
 	}
-- 
1.6.0.2

