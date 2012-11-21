From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 14/19] qla2xxx: Add 16Gb/s case to get port speed capability.
Date: Wed, 21 Nov 2012 02:40:39 -0500
Message-ID: <1353483644-17262-15-git-send-email-saurav.kashyap@qlogic.com>
References: <1353483644-17262-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:32961 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752585Ab2KUH64 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2012 02:58:56 -0500
In-Reply-To: <1353483644-17262-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gs.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index c51929c..01efc0e 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1933,6 +1933,9 @@ qla2x00_gpsc(scsi_qla_host_t *vha, sw_info_t *list)
 			case BIT_11:
 				list[i].fp_speed = PORT_SPEED_8GB;
 				break;
+			case BIT_10:
+				list[i].fp_speed = PORT_SPEED_16GB;
+				break;
 			}
 
 			ql_dbg(ql_dbg_disc, vha, 0x205b,
-- 
1.7.7

