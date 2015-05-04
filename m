From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 17/17] scsi_dh_alua: Update version to 2.0
Date: Mon,  4 May 2015 14:42:23 +0200
Message-ID: <1430743343-47174-18-git-send-email-hare@suse.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47357 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353AbbEDMmn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 May 2015 08:42:43 -0400
In-Reply-To: <1430743343-47174-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 6c1eadf..a13f963 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -31,7 +31,7 @@
 #include <scsi/scsi_dh.h>
 
 #define ALUA_DH_NAME "alua"
-#define ALUA_DH_VER "1.3"
+#define ALUA_DH_VER "2.0"
 
 #define TPGS_STATE_OPTIMIZED		0x0
 #define TPGS_STATE_NONOPTIMIZED		0x1
-- 
1.8.5.2

