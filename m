From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: fusion: clean up some indentations
Date: Wed,  6 Dec 2017 15:02:43 +0000
Message-ID: <20171206150243.20695-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are several places where the source is not indented correctly
with either too many or too few levels of intentation. Fix these.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/message/fusion/mptbase.c | 57 ++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 28 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 7a93400eea2a..8df37fa1e977 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -958,7 +958,7 @@ mpt_put_msg_frame(u8 cb_idx, MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf)
 {
 	u32 mf_dma_addr;
 	int req_offset;
-	u16	 req_idx;	/* Request index */
+	u16 req_idx;	/* Request index */
 
 	/* ensure values are reset properly! */
 	mf->u.frame.hwhdr.msgctxu.fld.cb_idx = cb_idx;		/* byte */
@@ -994,7 +994,7 @@ mpt_put_msg_frame_hi_pri(u8 cb_idx, MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf)
 {
 	u32 mf_dma_addr;
 	int req_offset;
-	u16	 req_idx;	/* Request index */
+	u16 req_idx;	/* Request index */
 
 	/* ensure values are reset properly! */
 	mf->u.frame.hwhdr.msgctxu.fld.cb_idx = cb_idx;
@@ -1128,11 +1128,12 @@ mpt_add_sge_64bit_1078(void *pAddr, u32 flagslength, dma_addr_t dma_addr)
 static void
 mpt_add_chain(void *pAddr, u8 next, u16 length, dma_addr_t dma_addr)
 {
-		SGEChain32_t *pChain = (SGEChain32_t *) pAddr;
-		pChain->Length = cpu_to_le16(length);
-		pChain->Flags = MPI_SGE_FLAGS_CHAIN_ELEMENT;
-		pChain->NextChainOffset = next;
-		pChain->Address = cpu_to_le32(dma_addr);
+	SGEChain32_t *pChain = (SGEChain32_t *) pAddr;
+
+	pChain->Length = cpu_to_le16(length);
+	pChain->Flags = MPI_SGE_FLAGS_CHAIN_ELEMENT;
+	pChain->NextChainOffset = next;
+	pChain->Address = cpu_to_le32(dma_addr);
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -1147,18 +1148,18 @@ mpt_add_chain(void *pAddr, u8 next, u16 length, dma_addr_t dma_addr)
 static void
 mpt_add_chain_64bit(void *pAddr, u8 next, u16 length, dma_addr_t dma_addr)
 {
-		SGEChain64_t *pChain = (SGEChain64_t *) pAddr;
-		u32 tmp = dma_addr & 0xFFFFFFFF;
+	SGEChain64_t *pChain = (SGEChain64_t *) pAddr;
+	u32 tmp = dma_addr & 0xFFFFFFFF;
 
-		pChain->Length = cpu_to_le16(length);
-		pChain->Flags = (MPI_SGE_FLAGS_CHAIN_ELEMENT |
-				 MPI_SGE_FLAGS_64_BIT_ADDRESSING);
+	pChain->Length = cpu_to_le16(length);
+	pChain->Flags = (MPI_SGE_FLAGS_CHAIN_ELEMENT |
+			 MPI_SGE_FLAGS_64_BIT_ADDRESSING);
 
-		pChain->NextChainOffset = next;
+	pChain->NextChainOffset = next;
 
-		pChain->Address.Low = cpu_to_le32(tmp);
-		tmp = (u32)(upper_32_bits(dma_addr));
-		pChain->Address.High = cpu_to_le32(tmp);
+	pChain->Address.Low = cpu_to_le32(tmp);
+	tmp = (u32)(upper_32_bits(dma_addr));
+	pChain->Address.High = cpu_to_le32(tmp);
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -1360,7 +1361,7 @@ mpt_host_page_alloc(MPT_ADAPTER *ioc, pIOCInit_t ioc_init)
 	ioc->add_sge(psge, flags_length, ioc->HostPageBuffer_dma);
 	ioc->facts.HostPageBufferSGE = ioc_init->HostPageBufferSGE;
 
-return 0;
+	return 0;
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -2152,7 +2153,7 @@ mpt_suspend(struct pci_dev *pdev, pm_message_t state)
 	    device_state);
 
 	/* put ioc into READY_STATE */
-	if(SendIocReset(ioc, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET, CAN_SLEEP)) {
+	if (SendIocReset(ioc, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET, CAN_SLEEP)) {
 		printk(MYIOC_s_ERR_FMT
 		"pci-suspend:  IOC msg unit reset failed!\n", ioc->name);
 	}
@@ -6348,7 +6349,7 @@ mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS *pCfg)
 	u8		 page_type = 0, extend_page;
 	unsigned long 	 timeleft;
 	unsigned long	 flags;
-    int		 in_isr;
+	int		 in_isr;
 	u8		 issue_hard_reset = 0;
 	u8		 retry_count = 0;
 
@@ -8092,15 +8093,15 @@ mpt_spi_log_info(MPT_ADAPTER *ioc, u32 log_info)
 static void
 mpt_sas_log_info(MPT_ADAPTER *ioc, u32 log_info, u8 cb_idx)
 {
-union loginfo_type {
-	u32	loginfo;
-	struct {
-		u32	subcode:16;
-		u32	code:8;
-		u32	originator:4;
-		u32	bus_type:4;
-	}dw;
-};
+	union loginfo_type {
+		u32	loginfo;
+		struct {
+			u32	subcode:16;
+			u32	code:8;
+			u32	originator:4;
+			u32	bus_type:4;
+		} dw;
+	};
 	union loginfo_type sas_loginfo;
 	char *originator_desc = NULL;
 	char *code_desc = NULL;
-- 
2.14.1
