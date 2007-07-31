From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: [PATCH 46] drivers/scsi/lpfc/lpfc_scsi.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 20:27:54 +0200
Message-ID: <200707312027.55149.m.kozlowski@tuxland.pl>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, james.smart@emulex.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/scsi/lpfc/lpfc_scsi.c | 42769 -> 42721 (-48 bytes)
 drivers/scsi/lpfc/lpfc_scsi.o | 191332 -> 191240 (-92 bytes)

 drivers/scsi/lpfc/lpfc_scsi.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/scsi/lpfc/lpfc_scsi.c	2007-07-26 13:07:42.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/scsi/lpfc/lpfc_scsi.c	2007-07-31 11:08:46.000000000 +0200
@@ -208,10 +208,9 @@ lpfc_new_scsi_buf(struct lpfc_vport *vpo
 	dma_addr_t pdma_phys;
 	uint16_t iotag;

-	psb = kmalloc(sizeof(struct lpfc_scsi_buf), GFP_KERNEL);
+	psb = kzalloc(sizeof(struct lpfc_scsi_buf), GFP_KERNEL);
 	if (!psb)
 		return NULL;
-	memset(psb, 0, sizeof (struct lpfc_scsi_buf));

 	/*
 	 * Get memory from the pci pool to map the virt space to pci bus space
