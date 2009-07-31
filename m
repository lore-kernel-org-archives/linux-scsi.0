From: giridhar.malavali@qlogic.com
Subject: [PATCH 04/12] qla2xxx: Mark all devices lost on loss of fc port.
Date: Fri, 31 Jul 2009 15:09:26 -0700
Message-ID: <1249078174-1957-5-git-send-email-giridhar.malavali@qlogic.com>
References: <1249078174-1957-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36787 "EHLO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753063AbZGaWJi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Jul 2009 18:09:38 -0400
In-Reply-To: <1249078174-1957-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Santosh Vernekar <santosh.vernekar@qlogic.com>

From: Santosh Vernekar <santosh.vernekar@qlogic.com>

Signed-off-by: Santosh Vernekar <santosh.vernekar@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 00f23d2..63e7cdc 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -639,6 +639,7 @@ skip_rio:
 				atomic_set(&vha->vp_state, VP_FAILED);
 				fc_vport_set_state(vha->fc_vport,
 				    FC_VPORT_FAILED);
+				qla2x00_mark_all_devices_lost(vha, 1);
 			}
 
 			vha->flags.management_server_logged_in = 0;
-- 
1.6.2.rc1.30.gd43c

