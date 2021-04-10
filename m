Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EE0AC43460
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 06:47:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD19C61208
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 06:47:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234388AbhDJGsM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 02:48:12 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:16886 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233606AbhDJGsJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2021 02:48:09 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FHQWJ6ZnZzkht2;
        Sat, 10 Apr 2021 14:46:04 +0800 (CST)
Received: from huawei.com (10.69.192.56) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.498.0; Sat, 10 Apr 2021
 14:47:43 +0800
From:   Luo Jiaxing <luojiaxing@huawei.com>
To:     <kashyap.desai@broadcom.com>, <sumit.saxena@broadcom.com>,
        <shivasharan.srikanteshwara@broadcom.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <megaraidlinux.pdl@broadcom.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        <luojiaxing@huawei.com>
Subject: [PATCH v1 1/8] scsi: megaraid: clean up for white space
Date:   Sat, 10 Apr 2021 14:48:00 +0800
Message-ID: <1618037287-460-2-git-send-email-luojiaxing@huawei.com>
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

Several kinds of error about white space is reported when running
checkpatch.pl:

ERROR: space required after that ',' (ctx:VxV)
+                              "commands to complete\n",i,outstanding);

ERROR: trailing whitespace
+^I^I^Idma_pool_free(pool->handle, kioc->buf_vaddr, $

ERROR: need consistent spacing around '*' (ctx:WxV)
+       u32 reply_q_sz = sizeof(u32) *(instance->max_mfi_cmds + 1);

so fix them together here.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
---
 drivers/scsi/megaraid/mbox_defs.h         | 20 +++++++++----------
 drivers/scsi/megaraid/megaraid_ioctl.h    |  4 ++--
 drivers/scsi/megaraid/megaraid_mbox.c     | 24 +++++++++++-----------
 drivers/scsi/megaraid/megaraid_mm.c       | 26 ++++++++++++------------
 drivers/scsi/megaraid/megaraid_sas_base.c | 33 ++++++++++++++++++++-----------
 5 files changed, 58 insertions(+), 49 deletions(-)

diff --git a/drivers/scsi/megaraid/mbox_defs.h b/drivers/scsi/megaraid/mbox_defs.h
index f0ef8f7..5001624 100644
--- a/drivers/scsi/megaraid/mbox_defs.h
+++ b/drivers/scsi/megaraid/mbox_defs.h
@@ -588,7 +588,7 @@ typedef struct {
 typedef struct {
 	uint8_t		channel;
 	uint8_t		target;
-}__attribute__ ((packed)) adap_device_t;
+} __attribute__ ((packed)) adap_device_t;
 
 
 /**
@@ -600,7 +600,7 @@ typedef struct {
 	uint32_t	start_blk;
 	uint32_t	num_blks;
 	adap_device_t	device[MAX_ROW_SIZE_40LD];
-}__attribute__ ((packed)) adap_span_40ld_t;
+} __attribute__ ((packed)) adap_span_40ld_t;
 
 
 /**
@@ -612,7 +612,7 @@ typedef struct {
 	uint32_t	start_blk;
 	uint32_t	num_blks;
 	adap_device_t	device[MAX_ROW_SIZE_8LD];
-}__attribute__ ((packed)) adap_span_8ld_t;
+} __attribute__ ((packed)) adap_span_8ld_t;
 
 
 /**
@@ -647,7 +647,7 @@ typedef struct {
 typedef struct {
 	logdrv_param_t		lparam;
 	adap_span_40ld_t	span[SPAN_DEPTH_8_SPANS];
-}__attribute__ ((packed)) logdrv_40ld_t;
+} __attribute__ ((packed)) logdrv_40ld_t;
 
 
 /**
@@ -660,7 +660,7 @@ typedef struct {
 typedef struct {
 	logdrv_param_t	lparam;
 	adap_span_8ld_t	span[SPAN_DEPTH_8_SPANS];
-}__attribute__ ((packed)) logdrv_8ld_span8_t;
+} __attribute__ ((packed)) logdrv_8ld_span8_t;
 
 
 /**
@@ -673,7 +673,7 @@ typedef struct {
 typedef struct {
 	logdrv_param_t	lparam;
 	adap_span_8ld_t	span[SPAN_DEPTH_4_SPANS];
-}__attribute__ ((packed)) logdrv_8ld_span4_t;
+} __attribute__ ((packed)) logdrv_8ld_span4_t;
 
 
 /**
@@ -690,7 +690,7 @@ typedef struct {
 	uint8_t		tag_depth;
 	uint8_t		sync_neg;
 	uint32_t	size;
-}__attribute__ ((packed)) phys_drive_t;
+} __attribute__ ((packed)) phys_drive_t;
 
 
 /**
@@ -705,7 +705,7 @@ typedef struct {
 	uint8_t		resvd[3];
 	logdrv_40ld_t	ldrv[MAX_LOGICAL_DRIVES_40LD];
 	phys_drive_t	pdrv[MBOX_MAX_PHYSICAL_DRIVES];
-}__attribute__ ((packed)) disk_array_40ld_t;
+} __attribute__ ((packed)) disk_array_40ld_t;
 
 
 /**
@@ -722,7 +722,7 @@ typedef struct {
 	uint8_t			resvd[3];
 	logdrv_8ld_span8_t	ldrv[MAX_LOGICAL_DRIVES_8LD];
 	phys_drive_t		pdrv[MBOX_MAX_PHYSICAL_DRIVES];
-}__attribute__ ((packed)) disk_array_8ld_span8_t;
+} __attribute__ ((packed)) disk_array_8ld_span8_t;
 
 
 /**
@@ -739,7 +739,7 @@ typedef struct {
 	uint8_t			resvd[3];
 	logdrv_8ld_span4_t	ldrv[MAX_LOGICAL_DRIVES_8LD];
 	phys_drive_t		pdrv[MBOX_MAX_PHYSICAL_DRIVES];
-}__attribute__ ((packed)) disk_array_8ld_span4_t;
+} __attribute__ ((packed)) disk_array_8ld_span4_t;
 
 
 /**
diff --git a/drivers/scsi/megaraid/megaraid_ioctl.h b/drivers/scsi/megaraid/megaraid_ioctl.h
index ae9c2ff..d0ae6f9 100644
--- a/drivers/scsi/megaraid/megaraid_ioctl.h
+++ b/drivers/scsi/megaraid/megaraid_ioctl.h
@@ -76,7 +76,7 @@
 #define DRVRTYPE_MBOX		0x00000001	/* regular mbox driver	*/
 #define DRVRTYPE_HPE		0x00000002	/* new hpe driver	*/
 
-#define MKADAP(adapno)	(MEGAIOC_MAGIC << 8 | (adapno) )
+#define MKADAP(adapno)	(MEGAIOC_MAGIC << 8 | (adapno))
 #define GETADAP(mkadap)	((mkadap) ^ MEGAIOC_MAGIC << 8)
 
 #define MAX_DMA_POOLS		5		/* 4k, 8k, 16k, 32k, 64k*/
@@ -148,7 +148,7 @@ typedef struct uioc {
 
 	uint8_t			timedout;
 
-} __attribute__ ((aligned(1024),packed)) uioc_t;
+} __attribute__ ((aligned(1024), packed)) uioc_t;
 
 /* For on-stack uioc timers. */
 struct uioc_timeout {
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index 145fde3..6d76b15 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -736,7 +736,7 @@ megaraid_init_mbox(adapter_t *adapter)
 	if (!raid_dev->baseaddr) {
 
 		con_log(CL_ANN, (KERN_WARNING
-			"megaraid: could not map hba memory\n") );
+			"megaraid: could not map hba memory\n"));
 
 		goto out_release_regions;
 	}
@@ -1396,7 +1396,7 @@ mbox_post_cmd(adapter_t *adapter, scb_t *scb)
 			udelay(1);
 			i++;
 			rmb();
-		} while(mbox->busy && (i < max_mbox_busy_wait));
+		} while (mbox->busy && (i < max_mbox_busy_wait));
 
 		if (mbox->busy) {
 
@@ -1629,7 +1629,7 @@ megaraid_mbox_build_cmd(adapter_t *adapter, struct scsi_cmnd *scp, int *busy)
 							scb);
 
 			mbox->xferaddr		= 0xFFFFFFFF;
-			mbox64->xferaddr_lo	= (uint32_t )ccb->pthru_dma_h;
+			mbox64->xferaddr_lo	= (uint32_t)ccb->pthru_dma_h;
 			mbox64->xferaddr_hi	= 0;
 
 			return scb;
@@ -1660,7 +1660,7 @@ megaraid_mbox_build_cmd(adapter_t *adapter, struct scsi_cmnd *scp, int *busy)
 			 * A little HACK: 2nd bit is zero for all scsi read
 			 * commands and is set for all scsi write commands
 			 */
-			mbox->cmd = (scp->cmnd[0] & 0x02) ?  MBOXCMD_LWRITE64:
+			mbox->cmd = (scp->cmnd[0] & 0x02) ?  MBOXCMD_LWRITE64 :
 					MBOXCMD_LREAD64 ;
 
 			/*
@@ -1719,7 +1719,7 @@ megaraid_mbox_build_cmd(adapter_t *adapter, struct scsi_cmnd *scp, int *busy)
 			scb->dma_direction = scp->sc_data_direction;
 
 			// Calculate Scatter-Gather info
-			mbox64->xferaddr_lo	= (uint32_t )ccb->sgl_dma_h;
+			mbox64->xferaddr_lo	= (uint32_t)ccb->sgl_dma_h;
 			mbox->numsge		= megaraid_mbox_mksgl(adapter,
 							scb);
 			mbox->xferaddr		= 0xFFFFFFFF;
@@ -1775,7 +1775,7 @@ megaraid_mbox_build_cmd(adapter_t *adapter, struct scsi_cmnd *scp, int *busy)
 		// over, reset the fast_load flag so that during a possible
 		// next scan, devices can be made available
 		if (rdev->fast_load && (target == 15) &&
-			(SCP2CHANNEL(scp) == adapter->max_channel -1)) {
+			(SCP2CHANNEL(scp) == adapter->max_channel - 1)) {
 
 			con_log(CL_ANN, (KERN_INFO
 			"megaraid[%d]: physical device scan re-enabled\n",
@@ -1946,7 +1946,7 @@ megaraid_mbox_prepare_pthru(adapter_t *adapter, scb_t *scb,
 	target	= scb->dev_target;
 
 	// 0=6sec, 1=60sec, 2=10min, 3=3hrs, 4=NO timeout
-	pthru->timeout		= 4;	
+	pthru->timeout		= 4;
 	pthru->ars		= 1;
 	pthru->islogical	= 0;
 	pthru->channel		= 0;
@@ -1995,7 +1995,7 @@ megaraid_mbox_prepare_epthru(adapter_t *adapter, scb_t *scb,
 	target	= scb->dev_target;
 
 	// 0=6sec, 1=60sec, 2=10min, 3=3hrs, 4=NO timeout
-	epthru->timeout		= 4;	
+	epthru->timeout		= 4;
 	epthru->ars		= 1;
 	epthru->islogical	= 0;
 	epthru->channel		= 0;
@@ -2113,7 +2113,7 @@ megaraid_ack_sequence(adapter_t *adapter)
 		// Acknowledge interrupt
 		WRINDOOR(raid_dev, 0x02);
 
-	} while(1);
+	} while (1);
 
 	spin_unlock_irqrestore(MAILBOX_LOCK(raid_dev), flags);
 
@@ -2267,7 +2267,7 @@ megaraid_mbox_dpc(unsigned long devp)
 				c = 0;
 			}
 
-			if ((c & 0x1F ) == TYPE_DISK) {
+			if ((c & 0x1F) == TYPE_DISK) {
 				pdev_index = (scb->dev_channel * 16) +
 					scb->dev_target;
 				pdev_state =
@@ -2785,7 +2785,7 @@ mbox_post_sync_cmd(adapter_t *adapter, uint8_t raw_mbox[])
 
 blocked_mailbox:
 
-	con_log(CL_ANN, (KERN_WARNING "megaraid: blocked mailbox\n") );
+	con_log(CL_ANN, (KERN_WARNING "megaraid: blocked mailbox\n"));
 	return -1;
 }
 
@@ -3291,7 +3291,7 @@ megaraid_mbox_fire_sync_cmd(adapter_t *adapter)
 	/* Check for interrupt line */
 	dword = RDOUTDOOR(raid_dev);
 	WROUTDOOR(raid_dev, dword);
-	WRINDOOR(raid_dev,2);
+	WRINDOOR(raid_dev, 2);
 
 	return status;
 
diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
index abf7b40..2939f0e 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -136,7 +136,7 @@ mraid_mm_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	/*
 	 * At present, we don't support the new ioctl packet
 	 */
-	if (!old_ioctl )
+	if (!old_ioctl)
 		return (-EINVAL);
 
 	/*
@@ -162,7 +162,7 @@ mraid_mm_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	if (!adp->quiescent) {
 		con_log(CL_ANN, (KERN_WARNING
 			"megaraid cmm: controller cannot accept cmds due to "
-			"earlier errors\n" ));
+			"earlier errors\n"));
 		return -EFAULT;
 	}
 
@@ -611,7 +611,7 @@ mraid_mm_alloc_kioc(mraid_mmadp_t *adp)
 
 	kioc->buf_vaddr		= NULL;
 	kioc->buf_paddr		= 0;
-	kioc->pool_index	=-1;
+	kioc->pool_index	= -1;
 	kioc->free_buf		= 0;
 	kioc->user_data		= NULL;
 	kioc->user_data_len	= 0;
@@ -639,15 +639,15 @@ mraid_mm_dealloc_kioc(mraid_mmadp_t *adp, uioc_t *kioc)
 		spin_lock_irqsave(&pool->lock, flags);
 
 		/*
-		 * While attaching the dma buffer, if we didn't get the 
-		 * required buffer from the pool, we would have allocated 
-		 * it at the run time and set the free_buf flag. We must 
-		 * free that buffer. Otherwise, just mark that the buffer is 
+		 * While attaching the dma buffer, if we didn't get the
+		 * required buffer from the pool, we would have allocated
+		 * it at the run time and set the free_buf flag. We must
+		 * free that buffer. Otherwise, just mark that the buffer is
 		 * not in use
 		 */
 		if (kioc->free_buf == 1)
-			dma_pool_free(pool->handle, kioc->buf_vaddr, 
-							kioc->buf_paddr);
+			dma_pool_free(pool->handle, kioc->buf_vaddr,
+				      kioc->buf_paddr);
 		else
 			pool->in_use = 0;
 
@@ -748,7 +748,7 @@ ioctl_done(uioc_t *kioc)
 		adapter		= NULL;
 		adapno		= kioc->adapno;
 
-		con_log(CL_ANN, ( KERN_WARNING "megaraid cmm: completed "
+		con_log(CL_ANN, (KERN_WARNING "megaraid cmm: completed "
 					"ioctl that was timedout before\n"));
 
 		list_for_each_entry(adapter, &adapters_list_g, list) {
@@ -758,7 +758,7 @@ ioctl_done(uioc_t *kioc)
 		kioc->timedout = 0;
 
 		if (adapter) {
-			mraid_mm_dealloc_kioc( adapter, kioc );
+			mraid_mm_dealloc_kioc(adapter, kioc);
 		}
 	}
 	else {
@@ -1067,7 +1067,7 @@ mraid_mm_setup_dma_pools(mraid_mmadp_t *adp)
 	 */
 	bufsize = MRAID_MM_INIT_BUFF_SIZE;
 
-	for (i = 0; i < MAX_DMA_POOLS; i++){
+	for (i = 0; i < MAX_DMA_POOLS; i++) {
 
 		pool = &adp->dma_pool_list[i];
 
@@ -1226,7 +1226,7 @@ mraid_mm_init(void)
 static void __exit
 mraid_mm_exit(void)
 {
-	con_log(CL_DLEVEL1 , ("exiting common mod\n"));
+	con_log(CL_DLEVEL1, ("exiting common mod\n"));
 
 	misc_deregister(&megaraid_mm_dev);
 }
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 4d4e9db..b2a34f7 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1666,26 +1666,33 @@ static inline void
 megasas_dump_pending_frames(struct megasas_instance *instance)
 {
 	struct megasas_cmd *cmd;
-	int i,n;
+	int i, n;
 	union megasas_sgl *mfi_sgl;
 	struct megasas_io_frame *ldio;
 	struct megasas_pthru_frame *pthru;
 	u32 sgcount;
 	u16 max_cmd = instance->max_fw_cmds;
 
-	dev_err(&instance->pdev->dev, "[%d]: Dumping Frame Phys Address of all pending cmds in FW\n",instance->host->host_no);
-	dev_err(&instance->pdev->dev, "[%d]: Total OS Pending cmds : %d\n",instance->host->host_no,atomic_read(&instance->fw_outstanding));
+	dev_err(&instance->pdev->dev, "[%d]: Dumping Frame Phys Address of all pending cmds in FW\n",
+		instance->host->host_no);
+	dev_err(&instance->pdev->dev, "[%d]: Total OS Pending cmds : %d\n",
+		instance->host->host_no, atomic_read(&instance->fw_outstanding));
 	if (IS_DMA64)
-		dev_err(&instance->pdev->dev, "[%d]: 64 bit SGLs were sent to FW\n",instance->host->host_no);
+		dev_err(&instance->pdev->dev, "[%d]: 64 bit SGLs were sent to FW\n",
+			instance->host->host_no);
 	else
-		dev_err(&instance->pdev->dev, "[%d]: 32 bit SGLs were sent to FW\n",instance->host->host_no);
+		dev_err(&instance->pdev->dev, "[%d]: 32 bit SGLs were sent to FW\n",
+			instance->host->host_no);
 
-	dev_err(&instance->pdev->dev, "[%d]: Pending OS cmds in FW : \n",instance->host->host_no);
+	dev_err(&instance->pdev->dev, "[%d]: Pending OS cmds in FW :\n",
+		instance->host->host_no);
 	for (i = 0; i < max_cmd; i++) {
 		cmd = instance->cmd_list[i];
 		if (!cmd->scmd)
 			continue;
-		dev_err(&instance->pdev->dev, "[%d]: Frame addr :0x%08lx : ",instance->host->host_no,(unsigned long)cmd->frame_phys_addr);
+		dev_err(&instance->pdev->dev, "[%d]: Frame addr :0x%08lx : ",
+			instance->host->host_no,
+			(unsigned long)cmd->frame_phys_addr);
 		if (megasas_cmd_type(cmd->scmd) == READ_WRITE_LDIO) {
 			ldio = (struct megasas_io_frame *)cmd->frame;
 			mfi_sgl = &ldio->sgl;
@@ -1718,7 +1725,8 @@ megasas_dump_pending_frames(struct megasas_instance *instance)
 			}
 		}
 	} /*for max_cmd*/
-	dev_err(&instance->pdev->dev, "[%d]: Pending Internal cmds in FW : \n",instance->host->host_no);
+	dev_err(&instance->pdev->dev, "[%d]: Pending Internal cmds in FW :\n",
+		instance->host->host_no);
 	for (i = 0; i < max_cmd; i++) {
 
 		cmd = instance->cmd_list[i];
@@ -1726,7 +1734,8 @@ megasas_dump_pending_frames(struct megasas_instance *instance)
 		if (cmd->sync_cmd == 1)
 			dev_err(&instance->pdev->dev, "0x%08lx : ", (unsigned long)cmd->frame_phys_addr);
 	}
-	dev_err(&instance->pdev->dev, "[%d]: Dumping Done\n\n",instance->host->host_no);
+	dev_err(&instance->pdev->dev, "[%d]: Dumping Done\n\n",
+		instance->host->host_no);
 }
 
 u32
@@ -2779,7 +2788,7 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
 
 		if (!(i % MEGASAS_RESET_NOTICE_INTERVAL)) {
 			dev_notice(&instance->pdev->dev, "[%2d]waiting for %d "
-			       "commands to complete\n",i,outstanding);
+			       "commands to complete\n", i, outstanding);
 			/*
 			 * Call cmd completion routine. Cmd to be
 			 * be completed directly without depending on isr.
@@ -4412,7 +4421,7 @@ int megasas_alloc_cmds(struct megasas_instance *instance)
 		return -ENOMEM;
 	}
 
-	memset(instance->cmd_list, 0, sizeof(struct megasas_cmd *) *max_cmd);
+	memset(instance->cmd_list, 0, sizeof(struct megasas_cmd *) * max_cmd);
 
 	for (i = 0; i < max_cmd; i++) {
 		instance->cmd_list[i] = kmalloc(sizeof(struct megasas_cmd),
@@ -6494,7 +6503,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
  */
 static void megasas_release_mfi(struct megasas_instance *instance)
 {
-	u32 reply_q_sz = sizeof(u32) *(instance->max_mfi_cmds + 1);
+	u32 reply_q_sz = sizeof(u32) * (instance->max_mfi_cmds + 1);
 
 	if (instance->reply_queue)
 		dma_free_coherent(&instance->pdev->dev, reply_q_sz,
-- 
2.7.4

