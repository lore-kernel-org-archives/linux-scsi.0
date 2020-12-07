Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6B28C4361B
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 12:49:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65DDF23405
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 12:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgLGMtN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 07:49:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:42038 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726048AbgLGMtN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Dec 2020 07:49:13 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7376EAD07;
        Mon,  7 Dec 2020 12:48:31 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 03/35] 3w-9xxx: Whitespace cleanup
Date:   Mon,  7 Dec 2020 13:47:47 +0100
Message-Id: <20201207124819.95822-4-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20201207124819.95822-1-hare@suse.de>
References: <20201207124819.95822-1-hare@suse.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/3w-9xxx.c |  56 +++++++++---------
 drivers/scsi/3w-9xxx.h | 156 +++++++++++++++++++++++++++----------------------
 2 files changed, 113 insertions(+), 99 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 3337b1e80412..48fcc0ad1db7 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -128,14 +128,14 @@ static int twa_fill_sense(TW_Device_Extension *tw_dev, int request_id, int copy_
 static void twa_free_request_id(TW_Device_Extension *tw_dev,int request_id);
 static void twa_get_request_id(TW_Device_Extension *tw_dev, int *request_id);
 static int twa_initconnection(TW_Device_Extension *tw_dev, int message_credits,
- 			      u32 set_features, unsigned short current_fw_srl, 
-			      unsigned short current_fw_arch_id, 
-			      unsigned short current_fw_branch, 
-			      unsigned short current_fw_build, 
-			      unsigned short *fw_on_ctlr_srl, 
-			      unsigned short *fw_on_ctlr_arch_id, 
-			      unsigned short *fw_on_ctlr_branch, 
-			      unsigned short *fw_on_ctlr_build, 
+			      u32 set_features, unsigned short current_fw_srl,
+			      unsigned short current_fw_arch_id,
+			      unsigned short current_fw_branch,
+			      unsigned short current_fw_build,
+			      unsigned short *fw_on_ctlr_srl,
+			      unsigned short *fw_on_ctlr_arch_id,
+			      unsigned short *fw_on_ctlr_branch,
+			      unsigned short *fw_on_ctlr_build,
 			      u32 *init_connect_result);
 static void twa_load_sgl(TW_Device_Extension *tw_dev, TW_Command_Full *full_command_packet, int request_id, dma_addr_t dma_handle, int length);
 static int twa_poll_response(TW_Device_Extension *tw_dev, int request_id, int seconds);
@@ -171,7 +171,7 @@ static ssize_t twa_show_stats(struct device *dev,
 		       "Last sector count:         %4d\n"
 		       "Max sector count:          %4d\n"
 		       "SCSI Host Resets:          %4d\n"
-		       "AEN's:                     %4d\n", 
+		       "AEN's:                     %4d\n",
 		       TW_DRIVER_VERSION,
 		       tw_dev->posted_request_count,
 		       tw_dev->max_posted_request_count,
@@ -190,7 +190,7 @@ static ssize_t twa_show_stats(struct device *dev,
 /* Create sysfs 'stats' entry */
 static struct device_attribute twa_host_stats_attr = {
 	.attr = {
-		.name = 	"stats",
+		.name =		"stats",
 		.mode =		S_IRUGO,
 	},
 	.show = twa_show_stats
@@ -242,7 +242,7 @@ static int twa_aen_complete(TW_Device_Extension *tw_dev, int request_id)
 		/* Keep reading the queue in case there are more aen's */
 		if (twa_aen_read_queue(tw_dev, request_id))
 			goto out2;
-	        else {
+		else {
 			retval = 0;
 			goto out;
 		}
@@ -497,7 +497,7 @@ static void twa_aen_sync_time(TW_Device_Extension *tw_dev, int request_id)
 	param->parameter_id = cpu_to_le16(0x3); /* SchedulerTime */
 	param->parameter_size_bytes = cpu_to_le16(4);
 
-	/* Convert system time in UTC to local time seconds since last 
+	/* Convert system time in UTC to local time seconds since last
            Sunday 12:00AM */
 	local_time = (ktime_get_real_seconds() - (sys_tz.tz_minuteswest * 60));
 	div_u64_rem(local_time - (3 * 86400), 604800, &schedulertime);
@@ -729,7 +729,7 @@ static long twa_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long
 
 		/* Now copy in the command packet response */
 		memcpy(&(tw_ioctl->firmware_command), tw_dev->command_packet_virt[request_id], sizeof(TW_Command_Full));
-		
+
 		/* Now complete the io */
 		spin_lock_irqsave(tw_dev->host->host_lock, flags);
 		tw_dev->posted_request_count--;
@@ -766,7 +766,7 @@ static long twa_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long
 			if (tw_dev->aen_clobber) {
 				tw_ioctl->driver_command.status = TW_IOCTL_ERROR_STATUS_AEN_CLOBBER;
 				tw_dev->aen_clobber = 0;
-			} else 
+			} else
 				tw_ioctl->driver_command.status = 0;
 			event_index = tw_dev->error_index;
 		} else {
@@ -1067,8 +1067,8 @@ static void *twa_get_param(TW_Device_Extension *tw_dev, int request_id, int tabl
 	command_packet = &full_command_packet->command.oldcommand;
 
 	command_packet->opcode__sgloffset = TW_OPSGL_IN(2, TW_OP_GET_PARAM);
-	command_packet->size              = TW_COMMAND_SIZE;
-	command_packet->request_id        = request_id;
+	command_packet->size		  = TW_COMMAND_SIZE;
+	command_packet->request_id	  = request_id;
 	command_packet->byte6_offset.block_count = cpu_to_le16(1);
 
 	/* Now setup the param */
@@ -1106,14 +1106,14 @@ static void twa_get_request_id(TW_Device_Extension *tw_dev, int *request_id)
 
 /* This function will send an initconnection command to controller */
 static int twa_initconnection(TW_Device_Extension *tw_dev, int message_credits,
- 			      u32 set_features, unsigned short current_fw_srl, 
-			      unsigned short current_fw_arch_id, 
-			      unsigned short current_fw_branch, 
-			      unsigned short current_fw_build, 
-			      unsigned short *fw_on_ctlr_srl, 
-			      unsigned short *fw_on_ctlr_arch_id, 
-			      unsigned short *fw_on_ctlr_branch, 
-			      unsigned short *fw_on_ctlr_build, 
+			      u32 set_features, unsigned short current_fw_srl,
+			      unsigned short current_fw_arch_id,
+			      unsigned short current_fw_branch,
+			      unsigned short current_fw_build,
+			      unsigned short *fw_on_ctlr_srl,
+			      unsigned short *fw_on_ctlr_arch_id,
+			      unsigned short *fw_on_ctlr_branch,
+			      unsigned short *fw_on_ctlr_build,
 			      u32 *init_connect_result)
 {
 	TW_Command_Full *full_command_packet;
@@ -1124,7 +1124,7 @@ static int twa_initconnection(TW_Device_Extension *tw_dev, int message_credits,
 	full_command_packet = tw_dev->command_packet_virt[request_id];
 	memset(full_command_packet, 0, sizeof(TW_Command_Full));
 	full_command_packet->header.header_desc.size_header = 128;
-	
+
 	tw_initconnect = (TW_Initconnect *)&full_command_packet->command.oldcommand;
 	tw_initconnect->opcode__reserved = TW_OPRES_IN(0, TW_OP_INIT_CONNECTION);
 	tw_initconnect->request_id = request_id;
@@ -1142,7 +1142,7 @@ static int twa_initconnection(TW_Device_Extension *tw_dev, int message_credits,
 		tw_initconnect->fw_arch_id = cpu_to_le16(current_fw_arch_id);
 		tw_initconnect->fw_branch = cpu_to_le16(current_fw_branch);
 		tw_initconnect->fw_build = cpu_to_le16(current_fw_build);
-	} else 
+	} else
 		tw_initconnect->size = TW_INIT_COMMAND_PACKET_SIZE;
 
 	/* Send command packet to the board */
@@ -1455,7 +1455,7 @@ static int twa_poll_response(TW_Device_Extension *tw_dev, int request_id, int se
 /* This function will poll the status register for a flag */
 static int twa_poll_status(TW_Device_Extension *tw_dev, u32 flag, int seconds)
 {
-	u32 status_reg_value; 
+	u32 status_reg_value;
 	unsigned long before;
 	int retval = 1;
 
@@ -1770,7 +1770,7 @@ static int twa_scsi_queue_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_
 
 	/* Save done function into scsi_cmnd struct */
 	SCpnt->scsi_done = done;
-		
+
 	/* Get a free request id */
 	twa_get_request_id(tw_dev, &request_id);
 
diff --git a/drivers/scsi/3w-9xxx.h b/drivers/scsi/3w-9xxx.h
index d88cd3499bd5..d3f479324527 100644
--- a/drivers/scsi/3w-9xxx.h
+++ b/drivers/scsi/3w-9xxx.h
@@ -49,8 +49,8 @@
 
 /* AEN string type */
 typedef struct TAG_twa_message_type {
-  unsigned int   code;
-  char*          text;
+	unsigned int   code;
+	char*	       text;
 } twa_message_type;
 
 /* AEN strings */
@@ -263,9 +263,9 @@ static twa_message_type twa_error_table[] = {
 #define TW_CONTROL_ENABLE_INTERRUPTS	       0x00000080
 #define TW_CONTROL_DISABLE_INTERRUPTS	       0x00000040
 #define TW_CONTROL_ISSUE_HOST_INTERRUPT	       0x00000020
-#define TW_CONTROL_CLEAR_PARITY_ERROR          0x00800000
-#define TW_CONTROL_CLEAR_QUEUE_ERROR           0x00400000
-#define TW_CONTROL_CLEAR_PCI_ABORT             0x00100000
+#define TW_CONTROL_CLEAR_PARITY_ERROR	       0x00800000
+#define TW_CONTROL_CLEAR_QUEUE_ERROR	       0x00400000
+#define TW_CONTROL_CLEAR_PCI_ABORT	       0x00100000
 
 /* Status register bit definitions */
 #define TW_STATUS_MAJOR_VERSION_MASK	       0xF0000000
@@ -284,25 +284,25 @@ static twa_message_type twa_error_table[] = {
 #define TW_STATUS_COMMAND_QUEUE_EMPTY	       0x00001000
 #define TW_STATUS_EXPECTED_BITS		       0x00002000
 #define TW_STATUS_UNEXPECTED_BITS	       0x00F00000
-#define TW_STATUS_VALID_INTERRUPT              0x00DF0000
+#define TW_STATUS_VALID_INTERRUPT	       0x00DF0000
 
 /* PCI related defines */
 #define TW_PCI_CLEAR_PARITY_ERRORS 0xc100
 #define TW_PCI_CLEAR_PCI_ABORT     0x2000
 
 /* Command packet opcodes used by the driver */
-#define TW_OP_INIT_CONNECTION 0x1
-#define TW_OP_GET_PARAM	      0x12
-#define TW_OP_SET_PARAM	      0x13
-#define TW_OP_EXECUTE_SCSI    0x10
+#define TW_OP_INIT_CONNECTION	0x1
+#define TW_OP_GET_PARAM		0x12
+#define TW_OP_SET_PARAM		0x13
+#define TW_OP_EXECUTE_SCSI	0x10
 #define TW_OP_DOWNLOAD_FIRMWARE 0x16
-#define TW_OP_RESET             0x1C
+#define TW_OP_RESET		0x1C
 
 /* Asynchronous Event Notification (AEN) codes used by the driver */
-#define TW_AEN_QUEUE_EMPTY       0x0000
-#define TW_AEN_SOFT_RESET        0x0001
+#define TW_AEN_QUEUE_EMPTY	0x0000
+#define TW_AEN_SOFT_RESET	0x0001
 #define TW_AEN_SYNC_TIME_WITH_HOST 0x031
-#define TW_AEN_SEVERITY_ERROR    0x1
+#define TW_AEN_SEVERITY_ERROR	0x1
 #define TW_AEN_SEVERITY_DEBUG    0x4
 #define TW_AEN_NOT_RETRIEVED 0x1
 #define TW_AEN_RETRIEVED 0x2
@@ -323,9 +323,9 @@ static twa_message_type twa_error_table[] = {
 
 /* Misc defines */
 #define TW_9550SX_DRAIN_COMPLETED	      0xFFFF
-#define TW_SECTOR_SIZE                        512
-#define TW_ALIGNMENT_9000                     4  /* 4 bytes */
-#define TW_ALIGNMENT_9000_SGL                 0x3
+#define TW_SECTOR_SIZE			      512
+#define TW_ALIGNMENT_9000		      4  /* 4 bytes */
+#define TW_ALIGNMENT_9000_SGL		      0x3
 #define TW_MAX_UNITS			      16
 #define TW_MAX_UNITS_9650SE		      32
 #define TW_INIT_MESSAGE_CREDITS		      0x100
@@ -338,7 +338,7 @@ static twa_message_type twa_error_table[] = {
 #define TW_BASE_FW_SRL			      24
 #define TW_BASE_FW_BRANCH		      0
 #define TW_BASE_FW_BUILD		      1
-#define TW_FW_SRL_LUNS_SUPPORTED              28
+#define TW_FW_SRL_LUNS_SUPPORTED	      28
 #define TW_Q_LENGTH			      256
 #define TW_Q_START			      0
 #define TW_MAX_SLOT			      32
@@ -346,19 +346,19 @@ static twa_message_type twa_error_table[] = {
 #define TW_MAX_CMDS_PER_LUN		      254
 #define TW_MAX_RESPONSE_DRAIN		      256
 #define TW_MAX_AEN_DRAIN		      255
-#define TW_IN_RESET                           2
+#define TW_IN_RESET			      2
 #define TW_USING_MSI			      3
 #define TW_IN_ATTENTION_LOOP		      4
-#define TW_MAX_SECTORS                        256
-#define TW_AEN_WAIT_TIME                      1000
-#define TW_IOCTL_WAIT_TIME                    (1 * HZ) /* 1 second */
-#define TW_MAX_CDB_LEN                        16
-#define TW_ISR_DONT_COMPLETE                  2
-#define TW_ISR_DONT_RESULT                    3
-#define TW_IOCTL_CHRDEV_TIMEOUT               60 /* 60 seconds */
-#define TW_IOCTL_CHRDEV_FREE                  -1
-#define TW_COMMAND_OFFSET                     128 /* 128 bytes */
-#define TW_VERSION_TABLE                      0x0402
+#define TW_MAX_SECTORS			      256
+#define TW_AEN_WAIT_TIME		      1000
+#define TW_IOCTL_WAIT_TIME		      (1 * HZ) /* 1 second */
+#define TW_MAX_CDB_LEN			      16
+#define TW_ISR_DONT_COMPLETE		      2
+#define TW_ISR_DONT_RESULT		      3
+#define TW_IOCTL_CHRDEV_TIMEOUT		      60 /* 60 seconds */
+#define TW_IOCTL_CHRDEV_FREE		      -1
+#define TW_COMMAND_OFFSET		      128 /* 128 bytes */
+#define TW_VERSION_TABLE		      0x0402
 #define TW_TIMEKEEP_TABLE		      0x040A
 #define TW_INFORMATION_TABLE		      0x0403
 #define TW_PARAM_FWVER			      3
@@ -367,22 +367,22 @@ static twa_message_type twa_error_table[] = {
 #define TW_PARAM_BIOSVER_LENGTH		      16
 #define TW_PARAM_PORTCOUNT		      3
 #define TW_PARAM_PORTCOUNT_LENGTH	      1
-#define TW_MIN_SGL_LENGTH                     0x200 /* 512 bytes */
-#define TW_MAX_SENSE_LENGTH                   256
-#define TW_EVENT_SOURCE_AEN                   0x1000
-#define TW_EVENT_SOURCE_COMMAND               0x1001
-#define TW_EVENT_SOURCE_PCHIP                 0x1002
-#define TW_EVENT_SOURCE_DRIVER                0x1003
+#define TW_MIN_SGL_LENGTH		      0x200 /* 512 bytes */
+#define TW_MAX_SENSE_LENGTH		      256
+#define TW_EVENT_SOURCE_AEN		      0x1000
+#define TW_EVENT_SOURCE_COMMAND		      0x1001
+#define TW_EVENT_SOURCE_PCHIP		      0x1002
+#define TW_EVENT_SOURCE_DRIVER		      0x1003
 #define TW_IOCTL_GET_COMPATIBILITY_INFO	      0x101
-#define TW_IOCTL_GET_LAST_EVENT               0x102
-#define TW_IOCTL_GET_FIRST_EVENT              0x103
-#define TW_IOCTL_GET_NEXT_EVENT               0x104
-#define TW_IOCTL_GET_PREVIOUS_EVENT           0x105
-#define TW_IOCTL_GET_LOCK                     0x106
-#define TW_IOCTL_RELEASE_LOCK                 0x107
-#define TW_IOCTL_FIRMWARE_PASS_THROUGH        0x108
+#define TW_IOCTL_GET_LAST_EVENT		      0x102
+#define TW_IOCTL_GET_FIRST_EVENT	      0x103
+#define TW_IOCTL_GET_NEXT_EVENT		      0x104
+#define TW_IOCTL_GET_PREVIOUS_EVENT	      0x105
+#define TW_IOCTL_GET_LOCK		      0x106
+#define TW_IOCTL_RELEASE_LOCK		      0x107
+#define TW_IOCTL_FIRMWARE_PASS_THROUGH	      0x108
 #define TW_IOCTL_ERROR_STATUS_NOT_LOCKED      0x1001 // Not locked
-#define TW_IOCTL_ERROR_STATUS_LOCKED          0x1002 // Already locked
+#define TW_IOCTL_ERROR_STATUS_LOCKED	      0x1002 // Already locked
 #define TW_IOCTL_ERROR_STATUS_NO_MORE_EVENTS  0x1003 // No more events
 #define TW_IOCTL_ERROR_STATUS_AEN_CLOBBER     0x1004 // AEN clobber occurred
 #define TW_IOCTL_ERROR_OS_EFAULT	      -EFAULT // Bad address
@@ -397,12 +397,12 @@ static twa_message_type twa_error_table[] = {
 #define TW_SENSE_DATA_LENGTH		      18
 #define TW_STATUS_CHECK_CONDITION	      2
 #define TW_ERROR_LOGICAL_UNIT_NOT_SUPPORTED   0x10a
-#define TW_ERROR_UNIT_OFFLINE                 0x128
+#define TW_ERROR_UNIT_OFFLINE		      0x128
 #define TW_MESSAGE_SOURCE_CONTROLLER_ERROR    3
 #define TW_MESSAGE_SOURCE_CONTROLLER_EVENT    4
-#define TW_MESSAGE_SOURCE_LINUX_DRIVER        6
+#define TW_MESSAGE_SOURCE_LINUX_DRIVER	      6
 #define TW_DRIVER TW_MESSAGE_SOURCE_LINUX_DRIVER
-#define TW_MESSAGE_SOURCE_LINUX_OS            9
+#define TW_MESSAGE_SOURCE_LINUX_OS	      9
 #define TW_OS TW_MESSAGE_SOURCE_LINUX_OS
 #ifndef PCI_DEVICE_ID_3WARE_9000
 #define PCI_DEVICE_ID_3WARE_9000 0x1002
@@ -434,24 +434,38 @@ static twa_message_type twa_error_table[] = {
 #define TW_RESID_OUT(x) ((x >> 4) & 0xff)
 
 /* request_id: 12, lun: 4 */
-#define TW_REQ_LUN_IN(lun, request_id) (((lun << 12) & 0xf000) | (request_id & 0xfff))
+#define TW_REQ_LUN_IN(lun, request_id)			\
+	(((lun << 12) & 0xf000) | (request_id & 0xfff))
 #define TW_LUN_OUT(lun) ((lun >> 12) & 0xf)
 
 /* Macros */
 #define TW_CONTROL_REG_ADDR(x) (x->base_addr)
 #define TW_STATUS_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr + 0x4)
-#define TW_COMMAND_QUEUE_REG_ADDR(x) (sizeof(dma_addr_t) > 4 ? ((unsigned char __iomem *)x->base_addr + 0x20) : ((unsigned char __iomem *)x->base_addr + 0x8))
-#define TW_COMMAND_QUEUE_REG_ADDR_LARGE(x) ((unsigned char __iomem *)x->base_addr + 0x20)
-#define TW_RESPONSE_QUEUE_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr + 0xC)
-#define TW_RESPONSE_QUEUE_REG_ADDR_LARGE(x) ((unsigned char __iomem *)x->base_addr + 0x30)
-#define TW_CLEAR_ALL_INTERRUPTS(x) (writel(TW_STATUS_VALID_INTERRUPT, TW_CONTROL_REG_ADDR(x)))
-#define TW_CLEAR_ATTENTION_INTERRUPT(x) (writel(TW_CONTROL_CLEAR_ATTENTION_INTERRUPT, TW_CONTROL_REG_ADDR(x)))
-#define TW_CLEAR_HOST_INTERRUPT(x) (writel(TW_CONTROL_CLEAR_HOST_INTERRUPT, TW_CONTROL_REG_ADDR(x)))
-#define TW_DISABLE_INTERRUPTS(x) (writel(TW_CONTROL_DISABLE_INTERRUPTS, TW_CONTROL_REG_ADDR(x)))
-#define TW_ENABLE_AND_CLEAR_INTERRUPTS(x) (writel(TW_CONTROL_CLEAR_ATTENTION_INTERRUPT | TW_CONTROL_UNMASK_RESPONSE_INTERRUPT | TW_CONTROL_ENABLE_INTERRUPTS, TW_CONTROL_REG_ADDR(x)))
-#define TW_MASK_COMMAND_INTERRUPT(x) (writel(TW_CONTROL_MASK_COMMAND_INTERRUPT, TW_CONTROL_REG_ADDR(x)))
-#define TW_UNMASK_COMMAND_INTERRUPT(x) (writel(TW_CONTROL_UNMASK_COMMAND_INTERRUPT, TW_CONTROL_REG_ADDR(x)))
-#define TW_SOFT_RESET(x) (writel(TW_CONTROL_ISSUE_SOFT_RESET | \
+#define TW_COMMAND_QUEUE_REG_ADDR(x) \
+	(sizeof(dma_addr_t) > 4 ? ((unsigned char __iomem *)x->base_addr + 0x20) : ((unsigned char __iomem *)x->base_addr + 0x8))
+#define TW_COMMAND_QUEUE_REG_ADDR_LARGE(x) \
+	((unsigned char __iomem *)x->base_addr + 0x20)
+#define TW_RESPONSE_QUEUE_REG_ADDR(x) \
+	((unsigned char __iomem *)x->base_addr + 0xC)
+#define TW_RESPONSE_QUEUE_REG_ADDR_LARGE(x) \
+	((unsigned char __iomem *)x->base_addr + 0x30)
+#define TW_CLEAR_ALL_INTERRUPTS(x) \
+	(writel(TW_STATUS_VALID_INTERRUPT, TW_CONTROL_REG_ADDR(x)))
+#define TW_CLEAR_ATTENTION_INTERRUPT(x) \
+	(writel(TW_CONTROL_CLEAR_ATTENTION_INTERRUPT, TW_CONTROL_REG_ADDR(x)))
+#define TW_CLEAR_HOST_INTERRUPT(x) \
+	(writel(TW_CONTROL_CLEAR_HOST_INTERRUPT, TW_CONTROL_REG_ADDR(x)))
+#define TW_DISABLE_INTERRUPTS(x) \
+	(writel(TW_CONTROL_DISABLE_INTERRUPTS, TW_CONTROL_REG_ADDR(x)))
+#define TW_ENABLE_AND_CLEAR_INTERRUPTS(x)				\
+	(writel(TW_CONTROL_CLEAR_ATTENTION_INTERRUPT |			\
+		TW_CONTROL_UNMASK_RESPONSE_INTERRUPT |			\
+		TW_CONTROL_ENABLE_INTERRUPTS, TW_CONTROL_REG_ADDR(x)))
+#define TW_MASK_COMMAND_INTERRUPT(x)					\
+	(writel(TW_CONTROL_MASK_COMMAND_INTERRUPT, TW_CONTROL_REG_ADDR(x)))
+#define TW_UNMASK_COMMAND_INTERRUPT(x)					\
+	(writel(TW_CONTROL_UNMASK_COMMAND_INTERRUPT, TW_CONTROL_REG_ADDR(x)))
+#define TW_SOFT_RESET(x) (writel(TW_CONTROL_ISSUE_SOFT_RESET |	\
 			TW_CONTROL_CLEAR_HOST_INTERRUPT | \
 			TW_CONTROL_CLEAR_ATTENTION_INTERRUPT | \
 			TW_CONTROL_MASK_COMMAND_INTERRUPT | \
@@ -586,7 +600,7 @@ typedef struct TAG_TW_Ioctl_Driver_Command {
 
 typedef struct TAG_TW_Ioctl_Apache {
 	TW_Ioctl_Driver_Command driver_command;
-        char padding[488];
+	char padding[488];
 	TW_Command_Full firmware_command;
 	char data_buffer[1];
 } TW_Ioctl_Buf_Apache;
@@ -634,10 +648,10 @@ typedef struct TAG_TW_Compatibility_Info
 #pragma pack()
 
 typedef struct TAG_TW_Device_Extension {
-	u32                     __iomem *base_addr;
-	unsigned long	       	*generic_buffer_virt[TW_Q_LENGTH];
-	dma_addr_t	       	generic_buffer_phys[TW_Q_LENGTH];
-	TW_Command_Full	       	*command_packet_virt[TW_Q_LENGTH];
+	u32			__iomem *base_addr;
+	unsigned long		*generic_buffer_virt[TW_Q_LENGTH];
+	dma_addr_t		generic_buffer_phys[TW_Q_LENGTH];
+	TW_Command_Full		*command_packet_virt[TW_Q_LENGTH];
 	dma_addr_t		command_packet_phys[TW_Q_LENGTH];
 	struct pci_dev		*tw_pci_dev;
 	struct scsi_cmnd	*srb[TW_Q_LENGTH];
@@ -647,10 +661,10 @@ typedef struct TAG_TW_Device_Extension {
 	unsigned char		pending_queue[TW_Q_LENGTH];
 	unsigned char		pending_head;
 	unsigned char		pending_tail;
-	int     		state[TW_Q_LENGTH];
+	int			state[TW_Q_LENGTH];
 	unsigned int		posted_request_count;
 	unsigned int		max_posted_request_count;
-	unsigned int	        pending_request_count;
+	unsigned int		pending_request_count;
 	unsigned int		max_pending_request_count;
 	unsigned int		max_sgl_entries;
 	unsigned int		sgl_entries;
@@ -661,12 +675,12 @@ typedef struct TAG_TW_Device_Extension {
 	struct Scsi_Host	*host;
 	long			flags;
 	int			reset_print;
-	TW_Event                *event_queue[TW_Q_LENGTH];
-	unsigned char           error_index;
+	TW_Event		*event_queue[TW_Q_LENGTH];
+	unsigned char		error_index;
 	unsigned char		event_queue_wrapped;
-	unsigned int            error_sequence_id;
-	int                     ioctl_sem_lock;
-	ktime_t                 ioctl_time;
+	unsigned int		error_sequence_id;
+	int			ioctl_sem_lock;
+	ktime_t			ioctl_time;
 	int			chrdev_request_id;
 	wait_queue_head_t	ioctl_wqueue;
 	struct mutex		ioctl_lock;
-- 
2.16.4

