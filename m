From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/7] scsi_dh: Fixup kernel-doc comments
Date: Wed, 24 Aug 2011 10:51:14 +0200
Message-ID: <1314175879-16565-3-git-send-email-hare@suse.de>
References: <1314175879-16565-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58438 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756702Ab1HXIvn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2011 04:51:43 -0400
In-Reply-To: <1314175879-16565-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Fixup some kernel-doc comments to reference to the
correct function name.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index bc96ca6..a801c59 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -468,7 +468,7 @@ int scsi_dh_handler_exist(const char *name)
 EXPORT_SYMBOL_GPL(scsi_dh_handler_exist);
 
 /*
- * scsi_dh_handler_attach - Attach device handler
+ * scsi_dh_attach - Attach device handler
  * @sdev - sdev the handler should be attached to
  * @name - name of the handler to attach
  */
@@ -498,7 +498,7 @@ int scsi_dh_attach(struct request_queue *q, const char *name)
 EXPORT_SYMBOL_GPL(scsi_dh_attach);
 
 /*
- * scsi_dh_handler_detach - Detach device handler
+ * scsi_dh_detach - Detach device handler
  * @sdev - sdev the handler should be detached from
  *
  * This function will detach the device handler only
-- 
1.6.0.2

