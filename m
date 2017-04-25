From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 21/37] smartpqi: change return value for LUN reset operations
Date: Tue, 25 Apr 2017 14:48:00 -0500
Message-ID: <149314968026.13903.5364080721205532025.stgit@brunhilda>
References: <149314950730.13903.644081079070695025.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0056.outbound.protection.outlook.com ([104.47.33.56]:56206
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1167899AbdDYTsW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Apr 2017 15:48:22 -0400
In-Reply-To: <149314950730.13903.644081079070695025.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@hpe.com>

change return value for controller offline to be consistent
with the rest of the driver.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index f943e58..5678b6a 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -5032,7 +5032,7 @@ static int pqi_wait_for_lun_reset_completion(struct pqi_ctrl_info *ctrl_info,
 
 		pqi_check_ctrl_health(ctrl_info);
 		if (pqi_ctrl_offline(ctrl_info)) {
-			rc = -ETIMEDOUT;
+			rc = -ENXIO;
 			break;
 		}
 	}
