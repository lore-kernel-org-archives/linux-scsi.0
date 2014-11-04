From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] aic94xx: Fixup compilation warning
Date: Tue,  4 Nov 2014 08:10:59 +0100
Message-ID: <1415085059-127936-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37857 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbaKDHLC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Nov 2014 02:11:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

gcc complained about an uninitialized warning.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/aic94xx/aic94xx_sds.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_sds.c b/drivers/scsi/aic94xx/aic94xx_sds.c
index edb43fd..6f6a5b8 100644
--- a/drivers/scsi/aic94xx/aic94xx_sds.c
+++ b/drivers/scsi/aic94xx/aic94xx_sds.c
@@ -982,7 +982,7 @@ static int asd_process_ctrl_a_user(struct asd_ha_struct *asd_ha,
 				   struct asd_flash_dir *flash_dir)
 {
 	int err, i;
-	u32 offs, size;
+	u32 offs = 0, size;
 	struct asd_ll_el *el;
 	struct asd_ctrla_phy_settings *ps;
 	struct asd_ctrla_phy_settings dflt_ps;
-- 
1.8.5.2

