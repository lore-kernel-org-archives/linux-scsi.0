From: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] bnx2fc: Modify supported product numbers in MODULE_DESCRIPTION
Date: Thu, 15 Oct 2015 22:02:12 +0900
Message-ID: <1444914132-1461-1-git-send-email-standby24x7@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com, linux-scsi@vger.kernel.org, bprakash@broadcom.com, linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Currently bnx2fc driver support not only BMC57710,
but also BCM57711, BCM57712, BCM57800, BCM57810 and BCM57840.
It is better to modify from "BCM57710" to "BCM5771x/BCM578xx"

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index d5cdc47..565764c 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -32,7 +32,7 @@ static char version[] =
 
 
 MODULE_AUTHOR("Bhanu Prakash Gollapudi <bprakash@broadcom.com>");
-MODULE_DESCRIPTION("QLogic NetXtreme II BCM57710 FCoE Driver");
+MODULE_DESCRIPTION("QLogic NetXtreme II BCM5771x/BCM578xx FCoE Driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_MODULE_VERSION);
 
-- 
2.6.1.133.gf5b6079
