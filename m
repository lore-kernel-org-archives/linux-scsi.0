From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: fcoe: make fcoe_e_d_tov and fcoe_r_a_tov static
Date: Mon, 24 Apr 2017 18:04:18 +0100
Message-ID: <20170424170418.9625-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:54434 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S975236AbdDXREZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Apr 2017 13:04:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jth@kernel.org>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

These module parameter variables don't need global scope, make them static

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/fcoe/fcoe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index ab7bc1505e0b..90939f66bc0d 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -63,11 +63,11 @@ unsigned int fcoe_debug_logging;
 module_param_named(debug_logging, fcoe_debug_logging, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(debug_logging, "a bit mask of logging levels");
 
-unsigned int fcoe_e_d_tov = 2 * 1000;
+static unsigned int fcoe_e_d_tov = 2 * 1000;
 module_param_named(e_d_tov, fcoe_e_d_tov, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(e_d_tov, "E_D_TOV in ms, default 2000");
 
-unsigned int fcoe_r_a_tov = 2 * 2 * 1000;
+static unsigned int fcoe_r_a_tov = 2 * 2 * 1000;
 module_param_named(r_a_tov, fcoe_r_a_tov, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(r_a_tov, "R_A_TOV in ms, default 4000");
 
-- 
2.11.0
