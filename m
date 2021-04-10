Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03953C43462
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 06:47:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A513E61205
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 06:47:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234376AbhDJGsL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 02:48:11 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:16885 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhDJGsJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2021 02:48:09 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FHQWJ4zLyzkhqm;
        Sat, 10 Apr 2021 14:46:04 +0800 (CST)
Received: from huawei.com (10.69.192.56) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.498.0; Sat, 10 Apr 2021
 14:47:44 +0800
From:   Luo Jiaxing <luojiaxing@huawei.com>
To:     <kashyap.desai@broadcom.com>, <sumit.saxena@broadcom.com>,
        <shivasharan.srikanteshwara@broadcom.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <megaraidlinux.pdl@broadcom.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        <luojiaxing@huawei.com>
Subject: [PATCH v1 3/8] scsi: megaraid: clean up for blank lines
Date:   Sat, 10 Apr 2021 14:48:02 +0800
Message-ID: <1618037287-460-4-git-send-email-luojiaxing@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1618037287-460-1-git-send-email-luojiaxing@huawei.com>
References: <1618037287-460-1-git-send-email-luojiaxing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There are some blank line alerts when running
checkpatch.pl, so fix them together here.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
---
 drivers/scsi/megaraid/mbox_defs.h            |  1 -
 drivers/scsi/megaraid/megaraid_ioctl.h       |  4 ---
 drivers/scsi/megaraid/megaraid_mm.h          |  1 -
 drivers/scsi/megaraid/megaraid_sas.h         | 46 ----------------------------
 drivers/scsi/megaraid/megaraid_sas_base.c    | 23 --------------
 drivers/scsi/megaraid/megaraid_sas_debugfs.c |  1 -
 drivers/scsi/megaraid/megaraid_sas_fusion.c  |  5 ---
 drivers/scsi/megaraid/megaraid_sas_fusion.h  |  1 -
 8 files changed, 82 deletions(-)

diff --git a/drivers/scsi/megaraid/mbox_defs.h b/drivers/scsi/megaraid/mbox_defs.h
index 3efbfdb..e9b3093 100644
--- a/drivers/scsi/megaraid/mbox_defs.h
+++ b/drivers/scsi/megaraid/mbox_defs.h
@@ -244,7 +244,6 @@ typedef struct {
 } __attribute__ ((packed)) mraid_passthru_t;
 
 typedef struct {
-
 	uint32_t		dataxferaddr_lo;
 	uint32_t		dataxferaddr_hi;
 	mraid_passthru_t	pthru32;
diff --git a/drivers/scsi/megaraid/megaraid_ioctl.h b/drivers/scsi/megaraid/megaraid_ioctl.h
index d0ae6f9..87b880fe 100644
--- a/drivers/scsi/megaraid/megaraid_ioctl.h
+++ b/drivers/scsi/megaraid/megaraid_ioctl.h
@@ -112,7 +112,6 @@
  *		: format sent by applications would be converted to this.
  */
 typedef struct uioc {
-
 /* User Apps: */
 
 	uint8_t			signature[EXT_IOCTL_SIGN_SZ];
@@ -175,7 +174,6 @@ struct uioc_timeout {
  * that total size of the structure remains 256 bytes.
  */
 typedef struct mraid_hba_info {
-
 	uint16_t	pci_vendor_id;
 	uint16_t	pci_device_id;
 	uint16_t	subsys_vendor_id;
@@ -209,7 +207,6 @@ typedef struct mraid_hba_info {
  * @uid		: unique id
  */
 typedef struct mcontroller {
-
 	uint64_t	base;
 	uint8_t		irq;
 	uint8_t		numldrv;
@@ -267,7 +264,6 @@ typedef struct mm_dmapool {
  */
 
 typedef struct mraid_mmadp {
-
 /* Filled by driver */
 
 	uint32_t		unique_id;
diff --git a/drivers/scsi/megaraid/megaraid_mm.h b/drivers/scsi/megaraid/megaraid_mm.h
index bf40115..c48c1d9 100644
--- a/drivers/scsi/megaraid/megaraid_mm.h
+++ b/drivers/scsi/megaraid/megaraid_mm.h
@@ -58,7 +58,6 @@
  */
 
 typedef struct mimd {
-
 	uint32_t inlen;
 	uint32_t outlen;
 
diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index b652a84..fb0fbeeb 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -336,7 +336,6 @@ enum _MR_CRASH_BUF_STATUS {
 #define MFI_MBOX_SIZE				12
 
 enum MR_EVT_CLASS {
-
 	MR_EVT_CLASS_DEBUG = -2,
 	MR_EVT_CLASS_PROGRESS = -1,
 	MR_EVT_CLASS_INFO = 0,
@@ -344,11 +343,9 @@ enum MR_EVT_CLASS {
 	MR_EVT_CLASS_CRITICAL = 2,
 	MR_EVT_CLASS_FATAL = 3,
 	MR_EVT_CLASS_DEAD = 4,
-
 };
 
 enum MR_EVT_LOCALE {
-
 	MR_EVT_LOCALE_LD = 0x0001,
 	MR_EVT_LOCALE_PD = 0x0002,
 	MR_EVT_LOCALE_ENCL = 0x0004,
@@ -362,7 +359,6 @@ enum MR_EVT_LOCALE {
 };
 
 enum MR_EVT_ARGS {
-
 	MR_EVT_ARGS_NONE,
 	MR_EVT_ARGS_CDB_SENSE,
 	MR_EVT_ARGS_LD,
@@ -824,7 +820,6 @@ struct MR_HOST_DEVICE_LIST {
  * SAS controller properties
  */
 struct megasas_ctrl_prop {
-
 	u16 seq_num;
 	u16 pred_fail_poll_interval;
 	u16 intr_throttle_count;
@@ -939,7 +934,6 @@ struct megasas_ctrl_info {
 	 * Host interface information
 	 */
 	struct {
-
 		u8 PCIX:1;
 		u8 PCIE:1;
 		u8 iSCSI:1;
@@ -949,14 +943,12 @@ struct megasas_ctrl_info {
 		u8 reserved_1[6];
 		u8 port_count;
 		u64 port_addr[8];
-
 	} __attribute__ ((packed)) host_interface;
 
 	/*
 	 * Device (backend) interface information
 	 */
 	struct {
-
 		u8 SPI:1;
 		u8 SAS_3G:1;
 		u8 SATA_1_5G:1;
@@ -965,7 +957,6 @@ struct megasas_ctrl_info {
 		u8 reserved_1[6];
 		u8 port_count;
 		u64 port_addr[8];
-
 	} __attribute__ ((packed)) device_interface;
 
 	/*
@@ -975,12 +966,10 @@ struct megasas_ctrl_info {
 	__le32 image_component_count;
 
 	struct {
-
 		char name[8];
 		char version[32];
 		char build_date[16];
 		char built_time[16];
-
 	} __attribute__ ((packed)) image_component[8];
 
 	/*
@@ -992,12 +981,10 @@ struct megasas_ctrl_info {
 	__le32 pending_image_component_count;
 
 	struct {
-
 		char name[8];
 		char version[32];
 		char build_date[16];
 		char build_time[16];
-
 	} __attribute__ ((packed)) pending_image_component[8];
 
 	u8 max_arms;
@@ -1013,13 +1000,11 @@ struct megasas_ctrl_info {
 	 * presence of the hardware
 	 */
 	struct {
-
 		u32 bbu:1;
 		u32 alarm:1;
 		u32 nvram:1;
 		u32 uart:1;
 		u32 reserved:28;
-
 	} __attribute__ ((packed)) hw_present;
 
 	__le32 current_fw_time;
@@ -1071,18 +1056,15 @@ struct megasas_ctrl_info {
 	 * Controller capabilities structures
 	 */
 	struct {
-
 		u32 raid_level_0:1;
 		u32 raid_level_1:1;
 		u32 raid_level_5:1;
 		u32 raid_level_1E:1;
 		u32 raid_level_6:1;
 		u32 reserved:27;
-
 	} __attribute__ ((packed)) raid_levels;
 
 	struct {
-
 		u32 rbld_rate:1;
 		u32 cc_rate:1;
 		u32 bgi_rate:1;
@@ -1099,22 +1081,18 @@ struct megasas_ctrl_info {
 		u32 mixed_redundancy_arr:1;
 		u32 global_hot_spares:1;
 		u32 reserved:17;
-
 	} __attribute__ ((packed)) adapter_operations;
 
 	struct {
-
 		u32 read_policy:1;
 		u32 write_policy:1;
 		u32 io_policy:1;
 		u32 access_policy:1;
 		u32 disk_cache_policy:1;
 		u32 reserved:27;
-
 	} __attribute__ ((packed)) ld_operations;
 
 	struct {
-
 		u8 min;
 		u8 max;
 		u8 reserved[2];
@@ -1122,7 +1100,6 @@ struct megasas_ctrl_info {
 	} __attribute__ ((packed)) stripe_sz_ops;
 
 	struct {
-
 		u32 force_online:1;
 		u32 force_offline:1;
 		u32 force_rebuild:1;
@@ -1131,7 +1108,6 @@ struct megasas_ctrl_info {
 	} __attribute__ ((packed)) pd_operations;
 
 	struct {
-
 		u32 ctrl_supports_sas:1;
 		u32 ctrl_supports_sata:1;
 		u32 allow_mix_in_encl:1;
@@ -1698,14 +1674,12 @@ struct megasas_register_set {
 } __attribute__ ((packed));
 
 struct megasas_sge32 {
-
 	__le32 phys_addr;
 	__le32 length;
 
 } __attribute__ ((packed));
 
 struct megasas_sge64 {
-
 	__le64 phys_addr;
 	__le32 length;
 
@@ -1718,7 +1692,6 @@ struct megasas_sge_skinny {
 } __packed;
 
 union megasas_sgl {
-
 	struct megasas_sge32 sge32[1];
 	struct megasas_sge64 sge64[1];
 	struct megasas_sge_skinny sge_skinny[1];
@@ -1726,7 +1699,6 @@ union megasas_sgl {
 } __attribute__ ((packed));
 
 struct megasas_header {
-
 	u8 cmd;			/*00h */
 	u8 sense_len;		/*01h */
 	u8 cmd_status;		/*02h */
@@ -1747,7 +1719,6 @@ struct megasas_header {
 } __attribute__ ((packed));
 
 union megasas_sgl_frame {
-
 	struct megasas_sge32 sge32[8];
 	struct megasas_sge64 sge64[5];
 
@@ -1797,7 +1768,6 @@ typedef union _MFI_CAPABILITIES {
 } MFI_CAPABILITIES;
 
 struct megasas_init_frame {
-
 	u8 cmd;			/*00h */
 	u8 reserved_0;		/*01h */
 	u8 cmd_status;		/*02h */
@@ -1824,7 +1794,6 @@ struct megasas_init_frame {
 } __attribute__ ((packed));
 
 struct megasas_init_queue_info {
-
 	__le32 init_flags;		/*00h */
 	__le32 reply_queue_entries;	/*04h */
 
@@ -1838,7 +1807,6 @@ struct megasas_init_queue_info {
 } __attribute__ ((packed));
 
 struct megasas_io_frame {
-
 	u8 cmd;			/*00h */
 	u8 sense_len;		/*01h */
 	u8 cmd_status;		/*02h */
@@ -1867,7 +1835,6 @@ struct megasas_io_frame {
 } __attribute__ ((packed));
 
 struct megasas_pthru_frame {
-
 	u8 cmd;			/*00h */
 	u8 sense_len;		/*01h */
 	u8 cmd_status;		/*02h */
@@ -1894,7 +1861,6 @@ struct megasas_pthru_frame {
 } __attribute__ ((packed));
 
 struct megasas_dcmd_frame {
-
 	u8 cmd;			/*00h */
 	u8 reserved_0;		/*01h */
 	u8 cmd_status;		/*02h */
@@ -1921,7 +1887,6 @@ struct megasas_dcmd_frame {
 } __attribute__ ((packed));
 
 struct megasas_abort_frame {
-
 	u8 cmd;			/*00h */
 	u8 reserved_0;		/*01h */
 	u8 cmd_status;		/*02h */
@@ -1947,7 +1912,6 @@ struct megasas_abort_frame {
 } __attribute__ ((packed));
 
 struct megasas_smp_frame {
-
 	u8 cmd;			/*00h */
 	u8 reserved_1;		/*01h */
 	u8 cmd_status;		/*02h */
@@ -1973,7 +1937,6 @@ struct megasas_smp_frame {
 } __attribute__ ((packed));
 
 struct megasas_stp_frame {
-
 	u8 cmd;			/*00h */
 	u8 reserved_1;		/*01h */
 	u8 cmd_status;		/*02h */
@@ -2002,7 +1965,6 @@ struct megasas_stp_frame {
 } __attribute__ ((packed));
 
 union megasas_frame {
-
 	struct megasas_header hdr;
 	struct megasas_init_frame init;
 	struct megasas_io_frame io;
@@ -2033,7 +1995,6 @@ struct MR_PRIV_DEVICE {
 struct megasas_cmd;
 
 union megasas_evt_class_locale {
-
 	struct {
 #ifndef __BIG_ENDIAN_BITFIELD
 		u16 locale;
@@ -2060,14 +2021,12 @@ struct megasas_evt_log_info {
 } __attribute__ ((packed));
 
 struct megasas_progress {
-
 	__le16 progress;
 	__le16 elapsed_seconds;
 
 } __attribute__ ((packed));
 
 struct megasas_evtarg_ld {
-
 	u16 target_id;
 	u8 ld_index;
 	u8 reserved;
@@ -2082,7 +2041,6 @@ struct megasas_evtarg_pd {
 } __attribute__ ((packed));
 
 struct megasas_evt_detail {
-
 	__le32 seq_num;
 	__le32 time_stamp;
 	__le32 code;
@@ -2263,7 +2221,6 @@ enum MR_PERF_MODE {
 		 "Unknown")
 
 struct megasas_instance {
-
 	unsigned int *reply_map;
 	__le32 *producer;
 	dma_addr_t producer_h;
@@ -2555,7 +2512,6 @@ struct megasas_instance_template {
 	scp->device->id)
 
 struct megasas_cmd {
-
 	union megasas_frame *frame;
 	dma_addr_t frame_phys_addr;
 	u8 *sense;
@@ -2586,7 +2542,6 @@ struct megasas_cmd {
 #define MAX_IOCTL_SGE			16
 
 struct megasas_iocpacket {
-
 	u16 host_no;
 	u16 __pad1;
 	u32 sgl_off;
@@ -2629,7 +2584,6 @@ struct compat_megasas_iocpacket {
 #define MEGASAS_IOC_GET_AEN	_IOW('M', 3, struct megasas_aen)
 
 struct megasas_mgmt_info {
-
 	u16 count;
 	struct megasas_instance *instance[MAX_MGMT_ADAPTERS];
 	int max_index;
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index b2a34f7..7ff5820 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -146,7 +146,6 @@ static void megasas_get_pd_info(struct megasas_instance *instance,
  * PCI ID table for all supported controllers
  */
 static struct pci_device_id megasas_pci_table[] = {
-
 	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_SAS1064R)},
 	/* xscale IOP */
 	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_SAS1078R)},
@@ -369,7 +368,6 @@ megasas_return_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
 	list_add(&cmd->list, (&instance->cmd_pool)->next);
 
 	spin_unlock_irqrestore(&instance->mfi_pool_lock, flags);
-
 }
 
 static const char *
@@ -598,7 +596,6 @@ megasas_check_reset_xscale(struct megasas_instance *instance,
 }
 
 static struct megasas_instance_template megasas_instance_template_xscale = {
-
 	.fire_cmd = megasas_fire_cmd_xscale,
 	.enable_intr = megasas_enable_intr_xscale,
 	.disable_intr = megasas_disable_intr_xscale,
@@ -737,7 +734,6 @@ megasas_check_reset_ppc(struct megasas_instance *instance,
 }
 
 static struct megasas_instance_template megasas_instance_template_ppc = {
-
 	.fire_cmd = megasas_fire_cmd_ppc,
 	.enable_intr = megasas_enable_intr_ppc,
 	.disable_intr = megasas_disable_intr_ppc,
@@ -878,7 +874,6 @@ megasas_check_reset_skinny(struct megasas_instance *instance,
 }
 
 static struct megasas_instance_template megasas_instance_template_skinny = {
-
 	.fire_cmd = megasas_fire_cmd_skinny,
 	.enable_intr = megasas_enable_intr_skinny,
 	.disable_intr = megasas_disable_intr_skinny,
@@ -1078,7 +1073,6 @@ megasas_check_reset_gen2(struct megasas_instance *instance,
 }
 
 static struct megasas_instance_template megasas_instance_template_gen2 = {
-
 	.fire_cmd = megasas_fire_cmd_gen2,
 	.enable_intr = megasas_enable_intr_gen2,
 	.disable_intr = megasas_disable_intr_gen2,
@@ -1589,7 +1583,6 @@ megasas_build_ldio(struct megasas_instance *instance, struct scsi_cmnd *scp,
 						 ((u32) scp->cmnd[3] << 16) |
 						 ((u32) scp->cmnd[4] << 8) |
 						 (u32) scp->cmnd[5]);
-
 	}
 
 	/*
@@ -2995,7 +2988,6 @@ megasas_dump_fusion_io(struct scsi_cmnd *scmd)
 		megasas_dump(cmd->sg_frame,
 			     instance->max_chain_frame_sz, 8);
 	}
-
 }
 
 /*
@@ -3473,7 +3465,6 @@ static struct device_attribute *megaraid_host_attrs[] = {
  * Scsi host template for megaraid_sas driver
  */
 static struct scsi_host_template megasas_template = {
-
 	.module = THIS_MODULE,
 	.name = "Avago SAS based MegaRAID driver",
 	.proc_name = "megaraid_sas",
@@ -4246,7 +4237,6 @@ static void megasas_teardown_frame_pool(struct megasas_instance *instance)
 	 * Return all frames to pool
 	 */
 	for (i = 0; i < max_cmd; i++) {
-
 		cmd = instance->cmd_list[i];
 
 		if (cmd->frame)
@@ -4331,7 +4321,6 @@ static int megasas_create_frame_pool(struct megasas_instance *instance)
 	 * always use 32bit context regardless of the architecture
 	 */
 	for (i = 0; i < max_cmd; i++) {
-
 		cmd = instance->cmd_list[i];
 
 		cmd->frame = dma_pool_zalloc(instance->frame_dma_pool,
@@ -4428,7 +4417,6 @@ int megasas_alloc_cmds(struct megasas_instance *instance)
 						GFP_KERNEL);
 
 		if (!instance->cmd_list[i]) {
-
 			for (j = 0; j < i; j++)
 				kfree(instance->cmd_list[j]);
 
@@ -4470,7 +4458,6 @@ int megasas_alloc_cmds(struct megasas_instance *instance)
  */
 inline int
 dcmd_timeout_ocr_possible(struct megasas_instance *instance) {
-
 	if (instance->adapter_type == MFI_SERIES)
 		return KILL_ADAPTER;
 	else if (instance->unload ||
@@ -4684,7 +4671,6 @@ megasas_get_pd_list(struct megasas_instance *instance)
 		memcpy(instance->pd_list, instance->local_pd_list,
 			sizeof(instance->pd_list));
 		break;
-
 	}
 
 	if (ret != DCMD_TIMEOUT)
@@ -5342,7 +5328,6 @@ megasas_get_ctrl_info(struct megasas_instance *instance)
 	case DCMD_FAILED:
 		megaraid_sas_kill_hba(instance);
 		break;
-
 	}
 
 	if (ret != DCMD_TIMEOUT)
@@ -5939,7 +5924,6 @@ megasas_alloc_irq_vectors(struct megasas_instance *instance)
 
 		instance->iopoll_q_count = 0;
 		i = __megasas_alloc_irq_vectors(instance);
-
 	}
 
 	dev_info(&instance->pdev->dev,
@@ -6099,7 +6083,6 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	msix_enable = (instance->instancet->read_fw_status_reg(instance) &
 		       0x4000000) >> 0x1a;
 	if (msix_enable && !msix_disable) {
-
 		scratch_pad_1 = megasas_readl
 			(instance, &instance->reg_set->outbound_scratch_pad_1);
 		/* Check max MSI-X vectors */
@@ -6223,7 +6206,6 @@ static int megasas_init_fw(struct megasas_instance *instance)
 			 */
 			if (!intr_coalescing)
 				instance->perf_mode = MR_LATENCY_PERF_MODE;
-
 		}
 
 		if (instance->perf_mode == MR_BALANCED_PERF_MODE)
@@ -7002,7 +6984,6 @@ megasas_set_dma_mask(struct megasas_instance *instance)
 fail_set_dma_mask:
 	dev_err(&pdev->dev, "Failed to set DMA mask\n");
 	return -1;
-
 }
 
 /*
@@ -7194,7 +7175,6 @@ int megasas_alloc_ctrl_dma_buffers(struct megasas_instance *instance)
 				"Failed to allocate targetid list buffer\n");
 			return -ENOMEM;
 		}
-
 	}
 
 	instance->pd_list_buf =
@@ -7350,7 +7330,6 @@ void megasas_free_ctrl_dma_buffers(struct megasas_instance *instance)
 				  HOST_DEVICE_LIST_SZ,
 				  instance->host_device_list_buf,
 				  instance->host_device_list_buf_h);
-
 }
 
 /*
@@ -8606,7 +8585,6 @@ static SIMPLE_DEV_PM_OPS(megasas_pm_ops, megasas_suspend, megasas_resume);
  * PCI hotplug support registration structure
  */
 static struct pci_driver megasas_pci_driver = {
-
 	.name = "megaraid_sas",
 	.id_table = megasas_pci_table,
 	.probe = megasas_probe_one,
@@ -8815,7 +8793,6 @@ void megasas_add_remove_devices(struct megasas_instance *instance,
 			}
 		}
 	}
-
 }
 
 static void
diff --git a/drivers/scsi/megaraid/megaraid_sas_debugfs.c b/drivers/scsi/megaraid/megaraid_sas_debugfs.c
index c6976077..5c94380 100644
--- a/drivers/scsi/megaraid/megaraid_sas_debugfs.c
+++ b/drivers/scsi/megaraid/megaraid_sas_debugfs.c
@@ -151,7 +151,6 @@ megasas_setup_debugfs(struct megasas_instance *instance)
 			return;
 		}
 	}
-
 }
 
 /*
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 2221175..7d10448 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -576,7 +576,6 @@ static int megasas_create_sg_sense_fusion(struct megasas_instance *instance)
 		offset = SCSI_SENSE_BUFFERSIZE * i;
 		cmd->sense = (u8 *)fusion->sense + offset;
 		cmd->sense_phys_addr = fusion->sense_phys_addr + offset;
-
 	}
 
 	return 0;
@@ -921,7 +920,6 @@ megasas_free_rdpq_fusion(struct megasas_instance *instance) {
 			dma_pool_free(fusion->rdpq_tracker[i].dma_pool_ptr,
 				      fusion->rdpq_tracker[i].pool_entry_virt,
 				      fusion->rdpq_tracker[i].pool_entry_phys);
-
 	}
 
 	dma_pool_destroy(fusion->reply_frames_desc_pool);
@@ -946,7 +944,6 @@ megasas_free_reply_fusion(struct megasas_instance *instance) {
 			fusion->reply_frames_desc_phys[0]);
 
 	dma_pool_destroy(fusion->reply_frames_desc_pool);
-
 }
 
 
@@ -4602,7 +4599,6 @@ megasas_issue_tm(struct megasas_instance *instance, u16 device_handle,
 	}
 
 	return rc;
-
 }
 
 /*
@@ -4761,7 +4757,6 @@ int megasas_task_abort_fusion(struct scsi_cmnd *scmd)
 
 int megasas_reset_target_fusion(struct scsi_cmnd *scmd)
 {
-
 	struct megasas_instance *instance;
 	int ret = FAILED;
 	u16 devhandle;
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index ce84f81..820a0f8 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -1191,7 +1191,6 @@ struct MR_DRV_RAID_MAP {
  * And it is mainly for code re-use purpose.
  */
 struct MR_DRV_RAID_MAP_ALL {
-
 	struct MR_DRV_RAID_MAP raidMap;
 	struct MR_LD_SPAN_MAP ldSpanMap[MAX_LOGICAL_DRIVES_DYN - 1];
 } __packed;
-- 
2.7.4

