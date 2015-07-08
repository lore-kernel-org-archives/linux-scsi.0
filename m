From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 20/20] scsi_dh_alua: Update version to 2.0
Date: Wed,  8 Jul 2015 11:06:18 +0200
Message-ID: <1436346378-96518-21-git-send-email-hare@suse.de>
References: <1436346378-96518-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35922 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934480AbbGHJGf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2015 05:06:35 -0400
In-Reply-To: <1436346378-96518-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.de>

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 30310c8..d077014 100644
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

