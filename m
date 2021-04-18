Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7003CC433ED
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Apr 2021 20:32:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C387610A1
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Apr 2021 20:32:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbhDRUdX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 18 Apr 2021 16:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhDRUdW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Apr 2021 16:33:22 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40149C06174A;
        Sun, 18 Apr 2021 13:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:MIME-Version
        :Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=lONnmRA8ho2fHGlmwzQJ1XUQfxnk2ahlExTFa3OFjPo=; b=FW9ycYln3cFqWB4120OwrMJtVd
        8Khx7Y3gb/QMBV/VI/t/jC/6eL7tAKXZfZVpujv5FJFw4gQeGvxRHRXF6UniE6vTSAY1VMxGAjmYo
        D2LBwl9yTF67OZcn2HSbJqmivetp+bmNdcGG6XFPCnttJ5pm8IjwgPfEUMS5/PEtnpPZFRhZj6I+G
        eHycjpdE8TmYMBXbzzah7Qv/siYJeiA5kF0ZAoad/t+KCZ/ZfTbQnQH9kIwJk7TLSgWs1y4A+G84w
        wwcny38JS6Ee35r+dLPdByJz5+ynbR2nna3g80Nzm90/8XRZ/AZxBSpXi9yFgcCALkBX+HWO249Cy
        tjlqtN8w==;
Received: from [2601:1c0:6280:3f0::df68] (helo=smtpauth.infradead.org)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lYE66-008YAm-Oo; Sun, 18 Apr 2021 20:32:51 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH] scsi: mpt3sas: documentation cleanup
Date:   Sun, 18 Apr 2021 13:32:46 -0700
Message-Id: <20210418203246.782-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix kernel-doc warnings, spellos, and typos.

drivers/scsi/mpt3sas/mpt3sas_base.c:5430: warning: Excess function parameter 'ct' description in '_base_allocate_pcie_sgl_pool'
drivers/scsi/mpt3sas/mpt3sas_base.c:5493: warning: Excess function parameter 'ctr' description in '_base_allocate_chain_dma_pool'
mpt3sas_base.c:1362: warning: missing initial short description on line:
 * _base_display_reply_info -
mpt3sas_base.c:2151: warning: contents before sections
mpt3sas_base.c:2314: warning: missing initial short description on line:
 * base_make_prp_nvme -

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: MPT-FusionLinux.pdl@broadcom.com
---
 drivers/scsi/mpt3sas/mpt3sas_base.c |  101 ++++++++++++--------------
 1 file changed, 50 insertions(+), 51 deletions(-)

--- linux-next-20210414.orig/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ linux-next-20210414/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -141,7 +141,7 @@ _base_clear_outstanding_commands(struct
  * @mpi_request:mf request pointer.
  * @sz:		size of buffer.
  *
- * @Returns - 1/0 Reset to be done or Not
+ * Return: 1/0 Reset to be done or Not
  */
 u8
 mpt3sas_base_check_cmd_timeout(struct MPT3SAS_ADAPTER *ioc,
@@ -440,7 +440,7 @@ static void _clone_sg_entries(struct MPT
 		return;
 
 	/* From smid we can get scsi_cmd, once we have sg_scmd,
-	 * we just need to get sg_virt and sg_next to get virual
+	 * we just need to get sg_virt and sg_next to get virtual
 	 * address associated with sgel->Address.
 	 */
 
@@ -600,7 +600,7 @@ static int mpt3sas_remove_dead_ioc_func(
  * _base_sync_drv_fw_timestamp - Sync Drive-Fw TimeStamp.
  * @ioc: Per Adapter Object
  *
- * Return nothing.
+ * Return: nothing.
  */
 static void _base_sync_drv_fw_timestamp(struct MPT3SAS_ADAPTER *ioc)
 {
@@ -704,7 +704,7 @@ _base_fault_reset_work(struct work_struc
 
 		/*
 		 * Call _scsih_flush_pending_cmds callback so that we flush all
-		 * pending commands back to OS. This call is required to aovid
+		 * pending commands back to OS. This call is required to avoid
 		 * deadlock at block layer. Dead IOC will fail to do diag reset,
 		 * and this call is safe since dead ioc will never return any
 		 * command back from HW.
@@ -873,7 +873,7 @@ mpt3sas_base_fault_info(struct MPT3SAS_A
  * @ioc: per adapter object
  * @fault_code: fault code
  *
- * Return nothing.
+ * Return: nothing.
  */
 void
 mpt3sas_base_coredump_info(struct MPT3SAS_ADAPTER *ioc, u16 fault_code)
@@ -887,7 +887,7 @@ mpt3sas_base_coredump_info(struct MPT3SA
  * @ioc: per adapter object
  * @caller: caller function name
  *
- * Returns 0 for success, non-zero for failure.
+ * Return: 0 for success, non-zero for failure.
  */
 int
 mpt3sas_base_wait_for_coredump_completion(struct MPT3SAS_ADAPTER *ioc,
@@ -1359,11 +1359,11 @@ _base_sas_log_info(struct MPT3SAS_ADAPTE
 }
 
 /**
- * _base_display_reply_info -
+ * _base_display_reply_info - handle reply descriptors depending on IOC Status
  * @ioc: per adapter object
  * @smid: system request message index
  * @msix_index: MSIX table index supplied by the OS
- * @reply: reply message frame(lower 32bit addr)
+ * @reply: reply message frame (lower 32bit addr)
  */
 static void
 _base_display_reply_info(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
@@ -1804,7 +1804,7 @@ _base_interrupt(int irq, void *bus_id)
  * @irqpoll: irq_poll object
  * @budget: irq poll weight
  *
- * returns number of reply descriptors processed
+ * Return: number of reply descriptors processed
  */
 static int
 _base_irqpoll(struct irq_poll *irqpoll, int budget)
@@ -1826,7 +1826,7 @@ _base_irqpoll(struct irq_poll *irqpoll,
 		enable_irq(reply_q->os_irq);
 		/*
 		 * Go for one more round of processing the
-		 * reply descriptor post queue incase if HBA
+		 * reply descriptor post queue in case the HBA
 		 * Firmware has posted some reply descriptors
 		 * while reenabling the IRQ.
 		 */
@@ -1840,7 +1840,7 @@ _base_irqpoll(struct irq_poll *irqpoll,
  * _base_init_irqpolls - initliaze IRQ polls
  * @ioc: per adapter object
  *
- * returns nothing
+ * Return: nothing
  */
 static void
 _base_init_irqpolls(struct MPT3SAS_ADAPTER *ioc)
@@ -1878,7 +1878,7 @@ _base_is_controller_msix_enabled(struct
  * @ioc: per adapter object
  * @poll: poll over reply descriptor pools incase interrupt for
  *		timed-out SCSI command got delayed
- * Context: non ISR conext
+ * Context: non-ISR context
  *
  * Called when a Task Management request has completed.
  */
@@ -2104,7 +2104,16 @@ _base_build_sg(struct MPT3SAS_ADAPTER *i
 
 /**
  * _base_build_nvme_prp - This function is called for NVMe end devices to build
- * a native SGL (NVMe PRP). The native SGL is built starting in the first PRP
+ *                        a native SGL (NVMe PRP).
+ * @ioc: per adapter object
+ * @smid: system request message index for getting asscociated SGL
+ * @nvme_encap_request: the NVMe request msg frame pointer
+ * @data_out_dma: physical address for WRITES
+ * @data_out_sz: data xfer size for WRITES
+ * @data_in_dma: physical address for READS
+ * @data_in_sz: data xfer size for READS
+ *
+ * The native SGL is built starting in the first PRP
  * entry of the NVMe message (PRP1).  If the data buffer is small enough to be
  * described entirely using PRP1, then PRP2 is not used.  If needed, PRP2 is
  * used to describe a larger data buffer.  If the data buffer is too large to
@@ -2133,7 +2142,7 @@ _base_build_sg(struct MPT3SAS_ADAPTER *i
  * Each 64-bit PRP entry comprises an address and an offset field.  The address
  * always points at the beginning of a 4KB physical memory page, and the offset
  * describes where within that 4KB page the memory segment begins.  Only the
- * first element in a PRP list may contain a non-zero offest, implying that all
+ * first element in a PRP list may contain a non-zero offset, implying that all
  * memory segments following the first begin at the start of a 4KB page.
  *
  * Each PRP element normally describes 4KB of physical memory, with exceptions
@@ -2147,14 +2156,6 @@ _base_build_sg(struct MPT3SAS_ADAPTER *i
  * Since PRP entries lack any indication of size, the overall data buffer length
  * is used to determine where the end of the data memory buffer is located, and
  * how many PRP entries are required to describe it.
- *
- * @ioc: per adapter object
- * @smid: system request message index for getting asscociated SGL
- * @nvme_encap_request: the NVMe request msg frame pointer
- * @data_out_dma: physical address for WRITES
- * @data_out_sz: data xfer size for WRITES
- * @data_in_dma: physical address for READS
- * @data_in_sz: data xfer size for READS
  */
 static void
 _base_build_nvme_prp(struct MPT3SAS_ADAPTER *ioc, u16 smid,
@@ -2311,8 +2312,8 @@ _base_build_nvme_prp(struct MPT3SAS_ADAP
 }
 
 /**
- * base_make_prp_nvme -
- * Prepare PRPs(Physical Region Page)- SGLs specific to NVMe drives only
+ * base_make_prp_nvme - Prepare PRPs (Physical Region Page) -
+ * 			SGLs specific to NVMe drives only
  *
  * @ioc:		per adapter object
  * @scmd:		SCSI command from the mid-layer
@@ -3155,7 +3156,7 @@ fall_back:
  *  - loaded driver with default max_msix_vectors module parameter and
  *  - system booted in non kdump mode
  *
- * returns nothing.
+ * Return: nothing.
  */
 static void
 _base_check_and_enable_high_iops_queues(struct MPT3SAS_ADAPTER *ioc,
@@ -3368,7 +3369,7 @@ _base_diag_reset(struct MPT3SAS_ADAPTER
  *     and if it is in fault state then issue diag reset.
  * @ioc: per adapter object
  *
- * Returns: 0 for success, non-zero for failure.
+ * Return: 0 for success, non-zero for failure.
  */
 static int
 _base_check_for_fault_and_issue_reset(struct MPT3SAS_ADAPTER *ioc)
@@ -3633,7 +3634,7 @@ mpt3sas_base_get_reply_virt_addr(struct
  * @ioc: per adapter object
  * @scmd: scsi_cmnd object
  *
- * returns msix index of general reply queues,
+ * Return: msix index of general reply queues,
  * i.e. reply queue on which IO request's reply
  * should be posted by the HBA firmware.
  */
@@ -3663,7 +3664,7 @@ _base_get_msix_index(struct MPT3SAS_ADAP
  * @ioc: per adapter object
  * @scmd: scsi_cmnd object
  *
- * Returns: msix index of high iops reply queues.
+ * Return: msix index of high iops reply queues.
  * i.e. high iops reply queue on which IO request's
  * reply should be posted by the HBA firmware.
  */
@@ -3910,7 +3911,7 @@ _base_writeq(__u64 b, volatile void __io
  * @ioc: per adapter object
  * @smid: system request message index
  *
- * returns msix index.
+ * Return: msix index.
  */
 static u8
 _base_set_and_get_msix_index(struct MPT3SAS_ADAPTER *ioc, u16 smid)
@@ -4005,7 +4006,7 @@ _base_put_smid_fast_path(struct MPT3SAS_
  * _base_put_smid_hi_priority - send Task Management request to firmware
  * @ioc: per adapter object
  * @smid: system request message index
- * @msix_task: msix_task will be same as msix of IO incase of task abort else 0.
+ * @msix_task: msix_task will be same as msix of IO in case of task abort else 0
  */
 static void
 _base_put_smid_hi_priority(struct MPT3SAS_ADAPTER *ioc, u16 smid,
@@ -4109,7 +4110,7 @@ _base_put_smid_default(struct MPT3SAS_AD
  * @smid: system request message index
  * @handle: device handle, unused in this function, for function type match
  *
- * Return nothing.
+ * Return: nothing.
  */
 static void
 _base_put_smid_scsi_io_atomic(struct MPT3SAS_ADAPTER *ioc, u16 smid,
@@ -4131,7 +4132,7 @@ _base_put_smid_scsi_io_atomic(struct MPT
  * @ioc: per adapter object
  * @smid: system request message index
  * @handle: device handle, unused in this function, for function type match
- * Return nothing
+ * Return: nothing
  */
 static void
 _base_put_smid_fast_path_atomic(struct MPT3SAS_ADAPTER *ioc, u16 smid,
@@ -4152,9 +4153,9 @@ _base_put_smid_fast_path_atomic(struct M
  * firmware using Atomic Request Descriptor
  * @ioc: per adapter object
  * @smid: system request message index
- * @msix_task: msix_task will be same as msix of IO incase of task abort else 0
+ * @msix_task: msix_task will be same as msix of IO in case of task abort else 0
  *
- * Return nothing.
+ * Return: nothing.
  */
 static void
 _base_put_smid_hi_priority_atomic(struct MPT3SAS_ADAPTER *ioc, u16 smid,
@@ -4176,7 +4177,7 @@ _base_put_smid_hi_priority_atomic(struct
  * @ioc: per adapter object
  * @smid: system request message index
  *
- * Return nothing.
+ * Return: nothing.
  */
 static void
 _base_put_smid_default_atomic(struct MPT3SAS_ADAPTER *ioc, u16 smid)
@@ -4547,7 +4548,7 @@ out:
 }
 
 /**
- * _base_display_ioc_capabilities - Disply IOC's capabilities.
+ * _base_display_ioc_capabilities - Display IOC's capabilities.
  * @ioc: per adapter object
  */
 static void
@@ -4750,7 +4751,7 @@ out:
  *    according to performance mode.
  * @ioc : per adapter object
  *
- * Return nothing.
+ * Return: nothing.
  */
 static void
 _base_update_ioc_page1_inlinewith_perf_mode(struct MPT3SAS_ADAPTER *ioc)
@@ -4815,7 +4816,7 @@ _base_update_ioc_page1_inlinewith_perf_m
  *				persistent pages
  * @ioc : per adapter object
  *
- * Return nothing.
+ * Return: nothing.
  */
 static void
 _base_get_event_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
@@ -4866,7 +4867,7 @@ _base_get_event_diag_triggers(struct MPT
  *				persistent pages
  * @ioc : per adapter object
  *
- * Return nothing.
+ * Return: nothing.
  */
 static void
 _base_get_scsi_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
@@ -4917,7 +4918,7 @@ _base_get_scsi_diag_triggers(struct MPT3
  *				persistent pages
  * @ioc : per adapter object
  *
- * Return nothing.
+ * Return: nothing.
  */
 static void
 _base_get_mpi_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
@@ -4970,7 +4971,7 @@ _base_get_mpi_diag_triggers(struct MPT3S
  *				persistent pages
  * @ioc : per adapter object
  *
- * Return nothing.
+ * Return: nothing.
  */
 static void
 _base_get_master_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
@@ -5006,8 +5007,8 @@ _base_get_master_diag_triggers(struct MP
  *					driver trigger pages or not
  * @ioc : per adapter object
  *
- * Returns trigger flags mask if HBA FW supports driver trigger pages,
- * otherwise returns EFAULT.
+ * Return: trigger flags mask if HBA FW supports driver trigger pages,
+ * otherwise returns %-EFAULT.
  */
 static int
 _base_check_for_trigger_pages_support(struct MPT3SAS_ADAPTER *ioc)
@@ -5035,7 +5036,7 @@ _base_check_for_trigger_pages_support(st
  *				persistent pages.
  * @ioc : per adapter object
  *
- * Return nothing.
+ * Return: nothing.
  */
 static void
 _base_get_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
@@ -5088,11 +5089,11 @@ _base_get_diag_triggers(struct MPT3SAS_A
 
 /**
  * _base_update_diag_trigger_pages - Update the driver trigger pages after
- *			online FW update, incase updated FW supports driver
+ *			online FW update, in case updated FW supports driver
  *			trigger pages.
  * @ioc : per adapter object
  *
- * Return nothing.
+ * Return: nothing.
  */
 static void
 _base_update_diag_trigger_pages(struct MPT3SAS_ADAPTER *ioc)
@@ -5421,7 +5422,6 @@ _base_reduce_hba_queue_depth(struct MPT3
  *			for pcie sgl pools.
  * @ioc: Adapter object
  * @sz: DMA Pool size
- * @ct: Chain tracker
  * Return: 0 for success, non-zero for failure.
  */
 
@@ -5485,7 +5485,6 @@ _base_allocate_pcie_sgl_pool(struct MPT3
  *			for chain dma pool.
  * @ioc: Adapter object
  * @sz: DMA Pool size
- * @ctr: Chain tracker
  * Return: 0 for success, non-zero for failure.
  */
 static int
@@ -6233,7 +6232,7 @@ _base_wait_on_iocstate(struct MPT3SAS_AD
  * _base_dump_reg_set -	This function will print hexdump of register set.
  * @ioc: per adapter object
  *
- * Returns nothing.
+ * Return: nothing.
  */
 static inline void
 _base_dump_reg_set(struct MPT3SAS_ADAPTER *ioc)
@@ -6467,7 +6466,7 @@ _base_send_ioc_reset(struct MPT3SAS_ADAP
  *
  * Return: Waits up to timeout seconds for the IOC to
  * become operational. Returns 0 if IOC is present
- * and operational; otherwise returns -EFAULT.
+ * and operational; otherwise returns %-EFAULT.
  */
 
 int
@@ -7868,7 +7867,7 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPT
 		/*
 		 * In SAS3.0,
 		 * SCSI_IO, SMP_PASSTHRU, SATA_PASSTHRU, Target Assist, and
-		 * Target Status - all require the IEEE formated scatter gather
+		 * Target Status - all require the IEEE formatted scatter gather
 		 * elements.
 		 */
 		ioc->build_sg_scmd = &_base_build_sg_scmd_ieee;
