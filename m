From: Colin King <colin.king@canonical.com>
Subject: [PATCH] iscsi: fix spelling mistakes in dev_warn messages
Date: Sat, 12 Nov 2016 16:49:50 +0000
Message-ID: <20161112164950.5605-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:49498 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966411AbcKLQuD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Nov 2016 11:50:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Intel SCU Linux support <intel-linux-scu@intel.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake "suspeneded" to "suspended" in
dev_warn messages

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/isci/remote_node_context.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/isci/remote_node_context.c b/drivers/scsi/isci/remote_node_context.c
index 1910100..30bd800 100644
--- a/drivers/scsi/isci/remote_node_context.c
+++ b/drivers/scsi/isci/remote_node_context.c
@@ -454,7 +454,7 @@ enum sci_status sci_remote_node_context_event_handler(struct sci_remote_node_con
 				 * the device since it's being invalidated anyway */
 				dev_warn(scirdev_to_dev(rnc_to_dev(sci_rnc)),
 					"%s: SCIC Remote Node Context 0x%p was "
-					"suspeneded by hardware while being "
+					"suspended by hardware while being "
 					"invalidated.\n", __func__, sci_rnc);
 				break;
 			default:
@@ -473,7 +473,7 @@ enum sci_status sci_remote_node_context_event_handler(struct sci_remote_node_con
 				 * the device since it's being resumed anyway */
 				dev_warn(scirdev_to_dev(rnc_to_dev(sci_rnc)),
 					"%s: SCIC Remote Node Context 0x%p was "
-					"suspeneded by hardware while being resumed.\n",
+					"suspended by hardware while being resumed.\n",
 					__func__, sci_rnc);
 				break;
 			default:
-- 
2.10.2

