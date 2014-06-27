From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/7] scsi: fix comment in scsi_device_set_state()
Date: Fri, 27 Jun 2014 08:26:59 +0200
Message-ID: <1403850425-89297-2-git-send-email-hare@suse.de>
References: <1403850425-89297-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48830 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476AbaF0G1J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2014 02:27:09 -0400
In-Reply-To: <1403850425-89297-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

The function returns '0' if successful; with the original comment
the function doesn't have a way to indicate success ...

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d5d22e4..a9d4f65 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2029,7 +2029,7 @@ EXPORT_SYMBOL(scsi_test_unit_ready);
  *	@sdev:	scsi device to change the state of.
  *	@state:	state to change to.
  *
- *	Returns zero if unsuccessful or an error if the requested 
+ *	Returns zero if successful or an error if the requested
  *	transition is illegal.
  */
 int
-- 
1.7.12.4

