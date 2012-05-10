From: James Smart <james.smart@emulex.com>
Subject: [PATCH 10/20] lpfc 8.3.31:Fix build warnings when debugfs is not
 defined
Date: Wed, 9 May 2012 21:18:12 -0400
Message-ID: <1336612693.1996.39.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:27892 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753806Ab2EJBSa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 May 2012 21:18:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix build warnings when debugfs is not defined


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_scsi.c |    8 ++++++++
 1 file changed, 8 insertions(+)


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2012-05-07 10:01:08.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2012-05-07 10:01:14.000000000 -0400
@@ -1945,7 +1945,9 @@ lpfc_bg_setup_bpl(struct lpfc_hba *phba,
 	dma_addr_t physaddr;
 	int i = 0, num_bde = 0, status;
 	int datadir = sc->sc_data_direction;
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	uint32_t rc;
+#endif
 	uint32_t checking = 1;
 	uint32_t reftag;
 	unsigned blksize;
@@ -2082,7 +2084,9 @@ lpfc_bg_setup_bpl_prot(struct lpfc_hba *
 	int datadir = sc->sc_data_direction;
 	unsigned char pgdone = 0, alldone = 0;
 	unsigned blksize;
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	uint32_t rc;
+#endif
 	uint32_t checking = 1;
 	uint32_t reftag;
 	uint8_t txop, rxop;
@@ -2301,7 +2305,9 @@ lpfc_bg_setup_sgl(struct lpfc_hba *phba,
 	uint32_t reftag;
 	unsigned blksize;
 	uint8_t txop, rxop;
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	uint32_t rc;
+#endif
 	uint32_t checking = 1;
 	uint32_t dma_len;
 	uint32_t dma_offset = 0;
@@ -2431,7 +2437,9 @@ lpfc_bg_setup_sgl_prot(struct lpfc_hba *
 	uint32_t reftag;
 	uint8_t txop, rxop;
 	uint32_t dma_len;
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	uint32_t rc;
+#endif
 	uint32_t checking = 1;
 	uint32_t dma_offset = 0;
 	int num_sge = 0;




