From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 1/3] arcmsr: modify codes for more readable
Date: Thu, 26 Nov 2015 19:33:56 +0800
Message-ID: <1448537636.10768.39.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:32964 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbbKZLeD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Nov 2015 06:34:03 -0500
Received: by pabfh17 with SMTP id fh17so87322354pab.0
        for <linux-scsi@vger.kernel.org>; Thu, 26 Nov 2015 03:34:02 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: thenzl@redhat.com, hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.de, jthumshirn@suse.de
Cc: hch@lst.de

From: Ching Huang <ching2048@areca.com.tw>

modify codes for more readable

Signed-of-by: Ching Huang <ching2048@areca.com.tw>

---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2015-11-25 18:08:52.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2015-11-26 15:52:54.000000000 +0800
@@ -2814,53 +2814,32 @@ static bool arcmsr_hbaD_get_config(struc
 	acb->dma_coherent2 = dma_coherent2;
 	reg = (struct MessageUnit_D *)dma_coherent2;
 	acb->pmuD = reg;
-	reg->chip_id = acb->mem_base0 + ARCMSR_ARC1214_CHIP_ID;
-	reg->cpu_mem_config = acb->mem_base0 +
-		ARCMSR_ARC1214_CPU_MEMORY_CONFIGURATION;
-	reg->i2o_host_interrupt_mask = acb->mem_base0 +
-		ARCMSR_ARC1214_I2_HOST_INTERRUPT_MASK;
-	reg->sample_at_reset = acb->mem_base0 + ARCMSR_ARC1214_SAMPLE_RESET;
-	reg->reset_request = acb->mem_base0 + ARCMSR_ARC1214_RESET_REQUEST;
-	reg->host_int_status = acb->mem_base0 +
-		ARCMSR_ARC1214_MAIN_INTERRUPT_STATUS;
-	reg->pcief0_int_enable = acb->mem_base0 +
-		ARCMSR_ARC1214_PCIE_F0_INTERRUPT_ENABLE;
-	reg->inbound_msgaddr0 = acb->mem_base0 +
-		ARCMSR_ARC1214_INBOUND_MESSAGE0;
-	reg->inbound_msgaddr1 = acb->mem_base0 +
-		ARCMSR_ARC1214_INBOUND_MESSAGE1;
-	reg->outbound_msgaddr0 = acb->mem_base0 +
-		ARCMSR_ARC1214_OUTBOUND_MESSAGE0;
-	reg->outbound_msgaddr1 = acb->mem_base0 +
-		ARCMSR_ARC1214_OUTBOUND_MESSAGE1;
-	reg->inbound_doorbell = acb->mem_base0 +
-		ARCMSR_ARC1214_INBOUND_DOORBELL;
-	reg->outbound_doorbell = acb->mem_base0 +
-		ARCMSR_ARC1214_OUTBOUND_DOORBELL;
-	reg->outbound_doorbell_enable = acb->mem_base0 +
-		ARCMSR_ARC1214_OUTBOUND_DOORBELL_ENABLE;
-	reg->inboundlist_base_low = acb->mem_base0 +
-		ARCMSR_ARC1214_INBOUND_LIST_BASE_LOW;
-	reg->inboundlist_base_high = acb->mem_base0 +
-		ARCMSR_ARC1214_INBOUND_LIST_BASE_HIGH;
-	reg->inboundlist_write_pointer = acb->mem_base0 +
-		ARCMSR_ARC1214_INBOUND_LIST_WRITE_POINTER;
-	reg->outboundlist_base_low = acb->mem_base0 +
-		ARCMSR_ARC1214_OUTBOUND_LIST_BASE_LOW;
-	reg->outboundlist_base_high = acb->mem_base0 +
-		ARCMSR_ARC1214_OUTBOUND_LIST_BASE_HIGH;
-	reg->outboundlist_copy_pointer = acb->mem_base0 +
-		ARCMSR_ARC1214_OUTBOUND_LIST_COPY_POINTER;
-	reg->outboundlist_read_pointer = acb->mem_base0 +
-		ARCMSR_ARC1214_OUTBOUND_LIST_READ_POINTER;
-	reg->outboundlist_interrupt_cause = acb->mem_base0 +
-		ARCMSR_ARC1214_OUTBOUND_INTERRUPT_CAUSE;
-	reg->outboundlist_interrupt_enable = acb->mem_base0 +
-		ARCMSR_ARC1214_OUTBOUND_INTERRUPT_ENABLE;
-	reg->message_wbuffer = acb->mem_base0 + ARCMSR_ARC1214_MESSAGE_WBUFFER;
-	reg->message_rbuffer = acb->mem_base0 + ARCMSR_ARC1214_MESSAGE_RBUFFER;
-	reg->msgcode_rwbuffer = acb->mem_base0 +
-		ARCMSR_ARC1214_MESSAGE_RWBUFFER;
+	reg->chip_id = MEM_BASE0(ARCMSR_ARC1214_CHIP_ID);
+	reg->cpu_mem_config = MEM_BASE0(ARCMSR_ARC1214_CPU_MEMORY_CONFIGURATION);
+	reg->i2o_host_interrupt_mask = MEM_BASE0(ARCMSR_ARC1214_I2_HOST_INTERRUPT_MASK);
+	reg->sample_at_reset = MEM_BASE0(ARCMSR_ARC1214_SAMPLE_RESET);
+	reg->reset_request = MEM_BASE0(ARCMSR_ARC1214_RESET_REQUEST);
+	reg->host_int_status = MEM_BASE0(ARCMSR_ARC1214_MAIN_INTERRUPT_STATUS);
+	reg->pcief0_int_enable = MEM_BASE0(ARCMSR_ARC1214_PCIE_F0_INTERRUPT_ENABLE);
+	reg->inbound_msgaddr0 = MEM_BASE0(ARCMSR_ARC1214_INBOUND_MESSAGE0);
+	reg->inbound_msgaddr1 = MEM_BASE0(ARCMSR_ARC1214_INBOUND_MESSAGE1);
+	reg->outbound_msgaddr0 = MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_MESSAGE0);
+	reg->outbound_msgaddr1 = MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_MESSAGE1);
+	reg->inbound_doorbell = MEM_BASE0(ARCMSR_ARC1214_INBOUND_DOORBELL);
+	reg->outbound_doorbell = MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_DOORBELL);
+	reg->outbound_doorbell_enable = MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_DOORBELL_ENABLE);
+	reg->inboundlist_base_low = MEM_BASE0(ARCMSR_ARC1214_INBOUND_LIST_BASE_LOW);
+	reg->inboundlist_base_high = MEM_BASE0(ARCMSR_ARC1214_INBOUND_LIST_BASE_HIGH);
+	reg->inboundlist_write_pointer = MEM_BASE0(ARCMSR_ARC1214_INBOUND_LIST_WRITE_POINTER);
+	reg->outboundlist_base_low = MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_LIST_BASE_LOW);
+	reg->outboundlist_base_high = MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_LIST_BASE_HIGH);
+	reg->outboundlist_copy_pointer = MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_LIST_COPY_POINTER);
+	reg->outboundlist_read_pointer = MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_LIST_READ_POINTER);
+	reg->outboundlist_interrupt_cause = MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_INTERRUPT_CAUSE);
+	reg->outboundlist_interrupt_enable = MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_INTERRUPT_ENABLE);
+	reg->message_wbuffer = MEM_BASE0(ARCMSR_ARC1214_MESSAGE_WBUFFER);
+	reg->message_rbuffer = MEM_BASE0(ARCMSR_ARC1214_MESSAGE_RBUFFER);
+	reg->msgcode_rwbuffer = MEM_BASE0(ARCMSR_ARC1214_MESSAGE_RWBUFFER);
 	iop_firm_model = (char __iomem *)(&reg->msgcode_rwbuffer[15]);
 	iop_firm_version = (char __iomem *)(&reg->msgcode_rwbuffer[17]);
 	iop_device_map = (char __iomem *)(&reg->msgcode_rwbuffer[21]);


