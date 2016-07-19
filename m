From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/2] fcoe: Rename 'fip_frame' to 'fip_vn2vn_notify_frame'
Date: Tue, 19 Jul 2016 13:49:39 +0200
Message-ID: <1468928980-40549-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50091 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979AbcGSLto (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jul 2016 07:49:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jth@kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Do not use a generic name to avoid confusions with other
usages.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/fcoe/fcoe_ctlr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 26a0685..dd45531 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -1989,7 +1989,7 @@ static void fcoe_ctlr_vn_send(struct fcoe_ctlr *fip,
 			      const u8 *dest, size_t min_len)
 {
 	struct sk_buff *skb;
-	struct fip_frame {
+	struct fip_vn2vn_probe_frame {
 		struct ethhdr eth;
 		struct fip_header fip;
 		struct fip_mac_desc mac;
@@ -2016,7 +2016,7 @@ static void fcoe_ctlr_vn_send(struct fcoe_ctlr *fip,
 	if (!skb)
 		return;
 
-	frame = (struct fip_frame *)skb->data;
+	frame = (struct fip_vn2vn_probe_frame *)skb->data;
 	memset(frame, 0, len);
 	memcpy(frame->eth.h_dest, dest, ETH_ALEN);
 
-- 
1.8.5.6

