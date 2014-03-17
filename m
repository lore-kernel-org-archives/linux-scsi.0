From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 36/39] iscsi_tcp: use blk_mq
Date: Mon, 17 Mar 2014 06:28:09 -0700
Message-ID: <20140317133136.922474744@bombadil.infradead.org>
References: <20140317132733.789623766@bombadil.infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=0036-iscsi_tcp-use-blk_mq.patch
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

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
