From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] qla4xxx: remove two unused MSI-X related #defines
Date: Wed, 11 Jan 2017 14:26:52 +0100
Message-ID: <1484141212-8637-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34442 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966554AbdAKN04 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2017 08:26:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com, linux-scsi@vger.kernel.org

Spotted while preparing qla2xxx changes as the symbols exist in both
drivers (sigh..).

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/qla4xxx/ql4_def.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index aeebefb..fc23371 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -408,9 +408,6 @@ struct qla4_8xxx_legacy_intr_set {
 };
 
 /* MSI-X Support */
-
-#define QLA_MSIX_DEFAULT	0
-#define QLA_MSIX_RSP_Q		1
 #define QLA_MSIX_ENTRIES	2
 
 /*
-- 
2.1.4

