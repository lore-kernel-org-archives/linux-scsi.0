From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 37/39] ata_piix: use blk_mq
Date: Mon, 17 Mar 2014 06:28:10 -0700
Message-ID: <20140317133137.113837193@bombadil.infradead.org>
References: <20140317132733.789623766@bombadil.infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=0037-ata_piix-use-blk_mq.patch
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/ata/ata_piix.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 6334c8d..df00cef 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1068,6 +1068,7 @@ static u8 piix_vmw_bmdma_status(struct ata_port *ap)
 
 static struct scsi_host_template piix_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
+	.use_blk_mq		= true,
 };
 
 static struct ata_port_operations piix_sata_ops = {
-- 
1.7.10.4
