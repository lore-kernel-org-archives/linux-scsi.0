From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 14/15] iscsi_tcp: use blk_mq
Date: Wed, 05 Feb 2014 04:41:32 -0800
Message-ID: <20140205124154.750048337@bombadil.infradead.org>
References: <20140205124118.332902571@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53243 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbaBEMl4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Feb 2014 07:41:56 -0500
Content-Disposition: inline; filename=0014-iscsi_tcp-use-blk_mq.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/iscsi_tcp.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index add6d15..44aae3d 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -957,6 +957,7 @@ static struct scsi_host_template iscsi_sw_tcp_sht = {
 	.target_alloc		= iscsi_target_alloc,
 	.proc_name		= "iscsi_tcp",
 	.this_id		= -1,
+	.use_blk_mq		= true,
 };
 
 static struct iscsi_transport iscsi_sw_tcp_transport = {
-- 
1.7.10.4


