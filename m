Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C4B7C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 08:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E130B611F2
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 08:31:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235255AbhD0IcX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 04:32:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:49710 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235186AbhD0IcC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 04:32:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 83654B127;
        Tue, 27 Apr 2021 08:31:06 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 23/40] nsp32: whitespace cleanup
Date:   Tue, 27 Apr 2021 10:30:29 +0200
Message-Id: <20210427083046.31620-24-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210427083046.31620-1-hare@suse.de>
References: <20210427083046.31620-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/nsp32.c | 415 +++++++++++++++++++++++--------------------
 1 file changed, 221 insertions(+), 194 deletions(-)

diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 134bbd2d8b66..6d29908017f0 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -176,38 +176,40 @@ static nsp32_sync_table nsp32_sync_table_pci[] = {
  * function declaration
  */
 /* module entry point */
-static int         nsp32_probe (struct pci_dev *, const struct pci_device_id *);
-static void        nsp32_remove(struct pci_dev *);
+static int nsp32_probe (struct pci_dev *, const struct pci_device_id *);
+static void nsp32_remove(struct pci_dev *);
 static int  __init init_nsp32  (void);
 static void __exit exit_nsp32  (void);
 
 /* struct struct scsi_host_template */
-static int         nsp32_show_info   (struct seq_file *, struct Scsi_Host *);
+static int	   nsp32_show_info   (struct seq_file *, struct Scsi_Host *);
 
-static int         nsp32_detect      (struct pci_dev *pdev);
-static int         nsp32_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
-static const char *nsp32_info        (struct Scsi_Host *);
-static int         nsp32_release     (struct Scsi_Host *);
+static int	   nsp32_detect      (struct pci_dev *pdev);
+static int	   nsp32_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
+static const char *nsp32_info	     (struct Scsi_Host *);
+static int	   nsp32_release     (struct Scsi_Host *);
 
 /* SCSI error handler */
-static int         nsp32_eh_abort     (struct scsi_cmnd *);
-static int         nsp32_eh_host_reset(struct scsi_cmnd *);
+static int	   nsp32_eh_abort     (struct scsi_cmnd *);
+static int	   nsp32_eh_host_reset(struct scsi_cmnd *);
 
 /* generate SCSI message */
 static void nsp32_build_identify(struct scsi_cmnd *);
 static void nsp32_build_nop     (struct scsi_cmnd *);
 static void nsp32_build_reject  (struct scsi_cmnd *);
-static void nsp32_build_sdtr    (struct scsi_cmnd *, unsigned char, unsigned char);
+static void nsp32_build_sdtr    (struct scsi_cmnd *, unsigned char,
+				 unsigned char);
 
 /* SCSI message handler */
 static int  nsp32_busfree_occur(struct scsi_cmnd *, unsigned short);
 static void nsp32_msgout_occur (struct scsi_cmnd *);
-static void nsp32_msgin_occur  (struct scsi_cmnd *, unsigned long, unsigned short);
+static void nsp32_msgin_occur  (struct scsi_cmnd *, unsigned long,
+				unsigned short);
 
 static int  nsp32_setup_sg_table    (struct scsi_cmnd *);
 static int  nsp32_selection_autopara(struct scsi_cmnd *);
 static int  nsp32_selection_autoscsi(struct scsi_cmnd *);
-static void nsp32_scsi_done         (struct scsi_cmnd *);
+static void nsp32_scsi_done	    (struct scsi_cmnd *);
 static int  nsp32_arbitration       (struct scsi_cmnd *, unsigned int);
 static int  nsp32_reselection       (struct scsi_cmnd *, unsigned char);
 static void nsp32_adjust_busfree    (struct scsi_cmnd *, unsigned int);
@@ -215,10 +217,13 @@ static void nsp32_restart_autoscsi  (struct scsi_cmnd *, unsigned short);
 
 /* SCSI SDTR */
 static void nsp32_analyze_sdtr       (struct scsi_cmnd *);
-static int  nsp32_search_period_entry(nsp32_hw_data *, nsp32_target *, unsigned char);
-static void nsp32_set_async          (nsp32_hw_data *, nsp32_target *);
-static void nsp32_set_max_sync       (nsp32_hw_data *, nsp32_target *, unsigned char *, unsigned char *);
-static void nsp32_set_sync_entry     (nsp32_hw_data *, nsp32_target *, int, unsigned char);
+static int  nsp32_search_period_entry(nsp32_hw_data *, nsp32_target *,
+				      unsigned char);
+static void nsp32_set_async	     (nsp32_hw_data *, nsp32_target *);
+static void nsp32_set_max_sync       (nsp32_hw_data *, nsp32_target *,
+				      unsigned char *, unsigned char *);
+static void nsp32_set_sync_entry     (nsp32_hw_data *, nsp32_target *,
+				      int, unsigned char);
 
 /* SCSI bus status handler */
 static void nsp32_wait_req    (nsp32_hw_data *, int);
@@ -234,16 +239,16 @@ static irqreturn_t do_nsp32_isr(int, void *);
 static int  nsp32hw_init(nsp32_hw_data *);
 
 /* EEPROM handler */
-static        int  nsp32_getprom_param (nsp32_hw_data *);
-static        int  nsp32_getprom_at24  (nsp32_hw_data *);
-static        int  nsp32_getprom_c16   (nsp32_hw_data *);
-static        void nsp32_prom_start    (nsp32_hw_data *);
-static        void nsp32_prom_stop     (nsp32_hw_data *);
-static        int  nsp32_prom_read     (nsp32_hw_data *, int);
-static        int  nsp32_prom_read_bit (nsp32_hw_data *);
-static        void nsp32_prom_write_bit(nsp32_hw_data *, int);
-static        void nsp32_prom_set      (nsp32_hw_data *, int, int);
-static        int  nsp32_prom_get      (nsp32_hw_data *, int);
+static int  nsp32_getprom_param (nsp32_hw_data *);
+static int  nsp32_getprom_at24  (nsp32_hw_data *);
+static int  nsp32_getprom_c16   (nsp32_hw_data *);
+static void nsp32_prom_start    (nsp32_hw_data *);
+static void nsp32_prom_stop     (nsp32_hw_data *);
+static int  nsp32_prom_read     (nsp32_hw_data *, int);
+static int  nsp32_prom_read_bit (nsp32_hw_data *);
+static void nsp32_prom_write_bit(nsp32_hw_data *, int);
+static void nsp32_prom_set      (nsp32_hw_data *, int, int);
+static int  nsp32_prom_get      (nsp32_hw_data *, int);
 
 /* debug/warning/info message */
 static void nsp32_message (const char *, int, char *, char *, ...);
@@ -356,8 +361,8 @@ static void nsp32_dmessage(const char *func, int line, int mask, char *fmt, ...)
 static void nsp32_build_identify(struct scsi_cmnd *SCpnt)
 {
 	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
-	int pos             = data->msgout_len;
-	int mode            = FALSE;
+	int pos		    = data->msgout_len;
+	int mode	    = FALSE;
 
 	/* XXX: Auto DiscPriv detection is progressing... */
 	if (disc_priv == 0) {
@@ -377,13 +382,13 @@ static void nsp32_build_sdtr(struct scsi_cmnd    *SCpnt,
 			     unsigned char offset)
 {
 	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
-	int pos             = data->msgout_len;
+	int pos = data->msgout_len;
 
 	data->msgoutbuf[pos] = EXTENDED_MESSAGE;  pos++;
 	data->msgoutbuf[pos] = EXTENDED_SDTR_LEN; pos++;
 	data->msgoutbuf[pos] = EXTENDED_SDTR;     pos++;
-	data->msgoutbuf[pos] = period;            pos++;
-	data->msgoutbuf[pos] = offset;            pos++;
+	data->msgoutbuf[pos] = period;		  pos++;
+	data->msgoutbuf[pos] = offset;		  pos++;
 
 	data->msgout_len = pos;
 }
@@ -394,7 +399,7 @@ static void nsp32_build_sdtr(struct scsi_cmnd    *SCpnt,
 static void nsp32_build_nop(struct scsi_cmnd *SCpnt)
 {
 	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
-	int            pos  = data->msgout_len;
+	int pos  = data->msgout_len;
 
 	if (pos != 0) {
 		nsp32_msg(KERN_WARNING,
@@ -412,12 +417,12 @@ static void nsp32_build_nop(struct scsi_cmnd *SCpnt)
 static void nsp32_build_reject(struct scsi_cmnd *SCpnt)
 {
 	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
-	int            pos  = data->msgout_len;
+	int pos  = data->msgout_len;
 
 	data->msgoutbuf[pos] = MESSAGE_REJECT; pos++;
 	data->msgout_len = pos;
 }
-	
+
 /*
  * timer
  */
@@ -450,7 +455,7 @@ static int nsp32_selection_autopara(struct scsi_cmnd *SCpnt)
 	unsigned char	phase;
 	int		i, ret;
 	unsigned int	msgout;
-	u16_le	        s;
+	u16_le		s;
 
 	nsp32_dbg(NSP32_DEBUG_AUTOSCSI, "in");
 
@@ -482,7 +487,7 @@ static int nsp32_selection_autopara(struct scsi_cmnd *SCpnt)
 			 * the sending order of the message is:
 			 *  MCNT 3: MSG#0 -> MSG#1 -> MSG#2
 			 *  MCNT 2:          MSG#1 -> MSG#2
-			 *  MCNT 1:                   MSG#2    
+			 *  MCNT 1:                   MSG#2
 			 */
 			msgout >>= 8;
 			msgout |= ((unsigned int)(data->msgoutbuf[i]) << 24);
@@ -494,7 +499,8 @@ static int nsp32_selection_autopara(struct scsi_cmnd *SCpnt)
 		msgout = 0;
 	}
 
-	// nsp_dbg(NSP32_DEBUG_AUTOSCSI, "sel time out=0x%x\n", nsp32_read2(base, SEL_TIME_OUT));
+	// nsp_dbg(NSP32_DEBUG_AUTOSCSI, "sel time out=0x%x\n",
+	// nsp32_read2(base, SEL_TIME_OUT));
 	// nsp32_write2(base, SEL_TIME_OUT,   SEL_TIMEOUT_TIME);
 
 	/*
@@ -520,10 +526,10 @@ static int nsp32_selection_autopara(struct scsi_cmnd *SCpnt)
 
 	/* command control */
 	param->command_control = cpu_to_le16(CLEAR_CDB_FIFO_POINTER |
-					     AUTOSCSI_START         |
-					     AUTO_MSGIN_00_OR_04    |
-					     AUTO_MSGIN_02          |
-					     AUTO_ATN               );
+					     AUTOSCSI_START |
+					     AUTO_MSGIN_00_OR_04 |
+					     AUTO_MSGIN_02 |
+					     AUTO_ATN );
 
 
 	/* transfer control */
@@ -555,9 +561,9 @@ static int nsp32_selection_autopara(struct scsi_cmnd *SCpnt)
 	/*
 	 * transfer parameter to ASIC
 	 */
-	nsp32_write4(base, SGT_ADR,         data->auto_paddr);
-	nsp32_write2(base, COMMAND_CONTROL, CLEAR_CDB_FIFO_POINTER |
-		                            AUTO_PARAMETER         );
+	nsp32_write4(base, SGT_ADR, data->auto_paddr);
+	nsp32_write2(base, COMMAND_CONTROL,
+		     CLEAR_CDB_FIFO_POINTER | AUTO_PARAMETER );
 
 	/*
 	 * Check arbitration
@@ -599,7 +605,7 @@ static int nsp32_selection_autoscsi(struct scsi_cmnd *SCpnt)
 		SCpnt->result = DID_BUS_BUSY << 16;
 		status = 1;
 		goto out;
-        }
+	}
 
 	/*
 	 * clear execph
@@ -616,13 +622,14 @@ static int nsp32_selection_autoscsi(struct scsi_cmnd *SCpnt)
 	 */
 	for (i = 0; i < SCpnt->cmd_len; i++) {
 		nsp32_write1(base, COMMAND_DATA, SCpnt->cmnd[i]);
-        }
+	}
 	nsp32_dbg(NSP32_DEBUG_CDB_CONTENTS, "CDB[0]=[0x%x]", SCpnt->cmnd[0]);
 
 	/*
 	 * set SCSIOUT LATCH(initiator)/TARGET(target) (OR-ed) ID
 	 */
-	nsp32_write1(base, SCSI_OUT_LATCH_TARGET_ID, BIT(host_id) | BIT(target));
+	nsp32_write1(base, SCSI_OUT_LATCH_TARGET_ID,
+		     BIT(host_id) | BIT(target));
 
 	/*
 	 * set SCSI MSGOUT REG
@@ -642,7 +649,7 @@ static int nsp32_selection_autoscsi(struct scsi_cmnd *SCpnt)
 			 * the sending order of the message is:
 			 *  MCNT 3: MSG#0 -> MSG#1 -> MSG#2
 			 *  MCNT 2:          MSG#1 -> MSG#2
-			 *  MCNT 1:                   MSG#2    
+			 *  MCNT 1:                   MSG#2
 			 */
 			msgout >>= 8;
 			msgout |= ((unsigned int)(data->msgoutbuf[i]) << 24);
@@ -662,7 +669,7 @@ static int nsp32_selection_autoscsi(struct scsi_cmnd *SCpnt)
 
 	/*
 	 * set SREQ hazard killer sampling rate
-	 * 
+	 *
 	 * TODO: sample_rate (BASE+0F) is 0 when internal clock = 40MHz.
 	 *      check other internal clock!
 	 */
@@ -687,7 +694,8 @@ static int nsp32_selection_autoscsi(struct scsi_cmnd *SCpnt)
 	nsp32_dbg(NSP32_DEBUG_AUTOSCSI,
 		  "syncreg=0x%x, ackwidth=0x%x, sgtpaddr=0x%x, id=0x%x",
 		  nsp32_read1(base, SYNC_REG), nsp32_read1(base, ACK_WIDTH),
-		  nsp32_read4(base, SGT_ADR), nsp32_read1(base, SCSI_OUT_LATCH_TARGET_ID));
+		  nsp32_read4(base, SGT_ADR),
+		  nsp32_read1(base, SCSI_OUT_LATCH_TARGET_ID));
 	nsp32_dbg(NSP32_DEBUG_AUTOSCSI, "msgout_len=%d, msgout=0x%x",
 		  data->msgout_len, msgout);
 
@@ -716,10 +724,10 @@ static int nsp32_selection_autoscsi(struct scsi_cmnd *SCpnt)
 	 * start AUTO SCSI, kick off arbitration
 	 */
 	command = (CLEAR_CDB_FIFO_POINTER |
-		   AUTOSCSI_START         |
+		   AUTOSCSI_START	  |
 		   AUTO_MSGIN_00_OR_04    |
-		   AUTO_MSGIN_02          |
-		   AUTO_ATN                );
+		   AUTO_MSGIN_02	  |
+		   AUTO_ATN);
 	nsp32_write2(base, COMMAND_CONTROL, command);
 
 	/*
@@ -739,9 +747,9 @@ static int nsp32_selection_autoscsi(struct scsi_cmnd *SCpnt)
 
 /*
  * Arbitration Status Check
- *	
+ *
  * Note: Arbitration counter is waited during ARBIT_GO is not lifting.
- *	 Using udelay(1) consumes CPU time and system time, but 
+ *	 Using udelay(1) consumes CPU time and system time, but
  *	 arbitration delay time is defined minimal 2.4us in SCSI
  *	 specification, thus udelay works as coarse grained wait timer.
  */
@@ -776,7 +784,7 @@ static int nsp32_arbitration(struct scsi_cmnd *SCpnt, unsigned int base)
 		nsp32_dbg(NSP32_DEBUG_AUTOSCSI, "arbit timeout");
 		SCpnt->result = DID_NO_CONNECT << 16;
 		status = FALSE;
-        }
+	}
 
 	/*
 	 * clear Arbit
@@ -822,7 +830,8 @@ static int nsp32_reselection(struct scsi_cmnd *SCpnt, unsigned char newlun)
 	 * or current nexus is not existed, unexpected
 	 * reselection is occurred. Send reject message.
 	 */
-	if (newid >= ARRAY_SIZE(data->lunt) || newlun >= ARRAY_SIZE(data->lunt[0])) {
+	if (newid >= ARRAY_SIZE(data->lunt) ||
+	    newlun >= ARRAY_SIZE(data->lunt[0])) {
 		nsp32_msg(KERN_WARNING, "unknown id/lun");
 		return FALSE;
 	} else if(data->lunt[newid][newlun].SCpnt == NULL) {
@@ -876,7 +885,8 @@ static int nsp32_setup_sg_table(struct scsi_cmnd *SCpnt)
 
 			if (le32_to_cpu(sgt[i].len) > 0x10000) {
 				nsp32_msg(KERN_ERR,
-					"can't transfer over 64KB at a time, size=0x%x", le32_to_cpu(sgt[i].len));
+					"can't transfer over 64KB at a time, "
+					"size=0x%lx", le32_to_cpu(sgt[i].len));
 				return FALSE;
 			}
 			nsp32_dbg(NSP32_DEBUG_SGLIST,
@@ -894,7 +904,8 @@ static int nsp32_setup_sg_table(struct scsi_cmnd *SCpnt)
 	return TRUE;
 }
 
-static int nsp32_queuecommand_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
+static int nsp32_queuecommand_lck(struct scsi_cmnd *SCpnt,
+				  void (*done)(struct scsi_cmnd *))
 {
 	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
 	nsp32_target *target;
@@ -904,8 +915,9 @@ static int nsp32_queuecommand_lck(struct scsi_cmnd *SCpnt, void (*done)(struct s
 	nsp32_dbg(NSP32_DEBUG_QUEUECOMMAND,
 		  "enter. target: 0x%x LUN: 0x%llx cmnd: 0x%x cmndlen: 0x%x "
 		  "use_sg: 0x%x reqbuf: 0x%lx reqlen: 0x%x",
-		  SCpnt->device->id, SCpnt->device->lun, SCpnt->cmnd[0], SCpnt->cmd_len,
-		  scsi_sg_count(SCpnt), scsi_sglist(SCpnt), scsi_bufflen(SCpnt));
+		  SCpnt->device->id, SCpnt->device->lun, SCpnt->cmnd[0],
+		  SCpnt->cmd_len, scsi_sg_count(SCpnt), scsi_sglist(SCpnt),
+		  scsi_bufflen(SCpnt));
 
 	if (data->CurrentSC != NULL) {
 		nsp32_msg(KERN_ERR, "Currentsc != NULL. Cancel this command request");
@@ -966,7 +978,7 @@ static int nsp32_queuecommand_lck(struct scsi_cmnd *SCpnt, void (*done)(struct s
 	/* Build IDENTIFY */
 	nsp32_build_identify(SCpnt);
 
-	/* 
+	/*
 	 * If target is the first time to transfer after the reset
 	 * (target don't have SDTR_DONE and SDTR_INITIATOR), sync
 	 * message SDTR is needed to do synchronous transfer.
@@ -1051,9 +1063,9 @@ static int nsp32hw_init(nsp32_hw_data *data)
 		nsp32_index_write2(base, CFG_LATE_CACHE, lc_reg & 0xffff);
 	}
 
-	nsp32_write2(base, IRQ_CONTROL,        IRQ_CONTROL_ALL_IRQ_MASK);
-	nsp32_write2(base, TRANSFER_CONTROL,   0);
-	nsp32_write4(base, BM_CNT,             0);
+	nsp32_write2(base, IRQ_CONTROL, IRQ_CONTROL_ALL_IRQ_MASK);
+	nsp32_write2(base, TRANSFER_CONTROL, 0);
+	nsp32_write4(base, BM_CNT, 0);
 	nsp32_write2(base, SCSI_EXECUTE_PHASE, 0);
 
 	do {
@@ -1081,12 +1093,13 @@ static int nsp32hw_init(nsp32_hw_data *data)
 		  nsp32_index_read1(base, FIFO_EMPTY_SHLD_COUNT));
 
 	nsp32_index_write1(base, CLOCK_DIV, data->clock);
-	nsp32_index_write1(base, BM_CYCLE,  MEMRD_CMD1 | SGT_AUTO_PARA_MEMED_CMD);
+	nsp32_index_write1(base, BM_CYCLE,
+			   MEMRD_CMD1 | SGT_AUTO_PARA_MEMED_CMD);
 	nsp32_write1(base, PARITY_CONTROL, 0);	/* parity check is disable */
 
 	/*
 	 * initialize MISC_WRRD register
-	 * 
+	 *
 	 * Note: Designated parameters is obeyed as following:
 	 *	MISC_SCSI_DIRECTION_DETECTOR_SELECT: It must be set.
 	 *	MISC_MASTER_TERMINATION_SELECT:      It must be set.
@@ -1101,10 +1114,10 @@ static int nsp32hw_init(nsp32_hw_data *data)
 	 */
 	nsp32_index_write2(base, MISC_WR,
 			   (SCSI_DIRECTION_DETECTOR_SELECT |
-			    DELAYED_BMSTART                |
-			    MASTER_TERMINATION_SELECT      |
-			    BMREQ_NEGATE_TIMING_SEL        |
-			    AUTOSEL_TIMING_SEL             |
+			    DELAYED_BMSTART |
+			    MASTER_TERMINATION_SELECT |
+			    BMREQ_NEGATE_TIMING_SEL |
+			    AUTOSEL_TIMING_SEL |
 			    BMSTOP_CHANGE2_NONDATA_PHASE));
 
 	nsp32_index_write1(base, TERM_PWR_CONTROL, 0);
@@ -1125,15 +1138,16 @@ static int nsp32hw_init(nsp32_hw_data *data)
 	 * enable to select designated IRQ (except for
 	 * IRQSELECT_SERR, IRQSELECT_PERR, IRQSELECT_BMCNTERR)
 	 */
-	nsp32_index_write2(base, IRQ_SELECT, IRQSELECT_TIMER_IRQ         |
-			                     IRQSELECT_SCSIRESET_IRQ     |
-			                     IRQSELECT_FIFO_SHLD_IRQ     |
-			                     IRQSELECT_RESELECT_IRQ      |
-			                     IRQSELECT_PHASE_CHANGE_IRQ  |
-			                     IRQSELECT_AUTO_SCSI_SEQ_IRQ |
-			                  //   IRQSELECT_BMCNTERR_IRQ      |
-			                     IRQSELECT_TARGET_ABORT_IRQ  |
-			                     IRQSELECT_MASTER_ABORT_IRQ );
+	nsp32_index_write2(base, IRQ_SELECT,
+			   IRQSELECT_TIMER_IRQ |
+			   IRQSELECT_SCSIRESET_IRQ |
+			   IRQSELECT_FIFO_SHLD_IRQ |
+			   IRQSELECT_RESELECT_IRQ |
+			   IRQSELECT_PHASE_CHANGE_IRQ |
+			   IRQSELECT_AUTO_SCSI_SEQ_IRQ |
+			   //   IRQSELECT_BMCNTERR_IRQ      |
+			   IRQSELECT_TARGET_ABORT_IRQ |
+			   IRQSELECT_MASTER_ABORT_IRQ );
 	nsp32_write2(base, IRQ_CONTROL, 0);
 
 	/* PCI LED off */
@@ -1163,11 +1177,12 @@ static irqreturn_t do_nsp32_isr(int irq, void *dev_id)
 	 * IRQ check, then enable IRQ mask
 	 */
 	irq_stat = nsp32_read2(base, IRQ_STATUS);
-	nsp32_dbg(NSP32_DEBUG_INTR, 
+	nsp32_dbg(NSP32_DEBUG_INTR,
 		  "enter IRQ: %d, IRQstatus: 0x%x", irq, irq_stat);
 	/* is this interrupt comes from Ninja asic? */
 	if ((irq_stat & IRQSTATUS_ANY_IRQ) == 0) {
-		nsp32_dbg(NSP32_DEBUG_INTR, "shared interrupt: irq other 0x%x", irq_stat);
+		nsp32_dbg(NSP32_DEBUG_INTR,
+			  "shared interrupt: irq other 0x%x", irq_stat);
 		goto out2;
 	}
 	handled = 1;
@@ -1207,7 +1222,8 @@ static irqreturn_t do_nsp32_isr(int irq, void *dev_id)
 
 	if (SCpnt == NULL) {
 		nsp32_msg(KERN_WARNING, "SCpnt==NULL this can't be happened");
-		nsp32_msg(KERN_WARNING, "irq_stat=0x%x trans_stat=0x%x", irq_stat, trans_stat);
+		nsp32_msg(KERN_WARNING, "irq_stat=0x%x trans_stat=0x%x",
+			  irq_stat, trans_stat);
 		goto out;
 	}
 
@@ -1265,13 +1281,13 @@ static irqreturn_t do_nsp32_isr(int irq, void *dev_id)
 				  "Data in/out phase processed");
 
 			/* read BMCNT, SGT pointer addr */
-			nsp32_dbg(NSP32_DEBUG_INTR, "BMCNT=0x%lx", 
+			nsp32_dbg(NSP32_DEBUG_INTR, "BMCNT=0x%lx",
 				    nsp32_read4(base, BM_CNT));
-			nsp32_dbg(NSP32_DEBUG_INTR, "addr=0x%lx", 
+			nsp32_dbg(NSP32_DEBUG_INTR, "addr=0x%lx",
 				    nsp32_read4(base, SGT_ADR));
-			nsp32_dbg(NSP32_DEBUG_INTR, "SACK=0x%lx", 
+			nsp32_dbg(NSP32_DEBUG_INTR, "SACK=0x%lx",
 				    nsp32_read4(base, SACK_CNT));
-			nsp32_dbg(NSP32_DEBUG_INTR, "SSACK=0x%lx", 
+			nsp32_dbg(NSP32_DEBUG_INTR, "SSACK=0x%lx",
 				    nsp32_read4(base, SAVED_SACK_CNT));
 
 			scsi_set_resid(SCpnt, 0); /* all data transferred! */
@@ -1306,7 +1322,7 @@ static irqreturn_t do_nsp32_isr(int irq, void *dev_id)
 			 * Read CSB and substitute CSB for SCpnt->result
 			 * to save status phase stutas byte.
 			 * scsi error handler checks host_byte (DID_*:
-			 * low level driver to indicate status), then checks 
+			 * low level driver to indicate status), then checks
 			 * status_byte (SCSI status byte).
 			 */
 			SCpnt->result =	(int)nsp32_read1(base, SCSI_CSB_IN);
@@ -1314,7 +1330,7 @@ static irqreturn_t do_nsp32_isr(int irq, void *dev_id)
 
 		if (auto_stat & ILLEGAL_PHASE) {
 			/* Illegal phase is detected. SACK is not back. */
-			nsp32_msg(KERN_WARNING, 
+			nsp32_msg(KERN_WARNING,
 				  "AUTO SCSI ILLEGAL PHASE OCCUR!!!!");
 
 			/* TODO: currently we don't have any action... bus reset? */
@@ -1367,7 +1383,8 @@ static irqreturn_t do_nsp32_isr(int irq, void *dev_id)
 			break;
 		default:
 			nsp32_dbg(NSP32_DEBUG_INTR, "fifo/other phase");
-			nsp32_dbg(NSP32_DEBUG_INTR, "irq_stat=0x%x trans_stat=0x%x", irq_stat, trans_stat);
+			nsp32_dbg(NSP32_DEBUG_INTR, "irq_stat=0x%x trans_stat=0x%x",
+				  irq_stat, trans_stat);
 			show_busphase(busphase);
 			break;
 		}
@@ -1433,32 +1450,39 @@ static int nsp32_show_info(struct seq_file *m, struct Scsi_Host *host)
 {
 	unsigned long     flags;
 	nsp32_hw_data    *data;
-	int               hostno;
+	int		  hostno;
 	unsigned int      base;
 	unsigned char     mode_reg;
-	int               id, speed;
-	long              model;
+	int		  id, speed;
+	long		  model;
 
 	hostno = host->host_no;
 	data = (nsp32_hw_data *)host->hostdata;
 	base = host->io_port;
 
 	seq_puts(m, "NinjaSCSI-32 status\n\n");
-	seq_printf(m, "Driver version:        %s, $Revision: 1.33 $\n", nsp32_release_version);
-	seq_printf(m, "SCSI host No.:         %d\n",		hostno);
-	seq_printf(m, "IRQ:                   %d\n",		host->irq);
-	seq_printf(m, "IO:                    0x%lx-0x%lx\n", host->io_port, host->io_port + host->n_io_port - 1);
-	seq_printf(m, "MMIO(virtual address): 0x%lx-0x%lx\n",	host->base, host->base + data->MmioLength - 1);
-	seq_printf(m, "sg_tablesize:          %d\n",		host->sg_tablesize);
-	seq_printf(m, "Chip revision:         0x%x\n",		(nsp32_read2(base, INDEX_REG) >> 8) & 0xff);
+	seq_printf(m, "Driver version:        %s, $Revision: 1.33 $\n",
+		   nsp32_release_version);
+	seq_printf(m, "SCSI host No.:         %d\n", hostno);
+	seq_printf(m, "IRQ:                   %d\n", host->irq);
+	seq_printf(m, "IO:                    0x%lx-0x%lx\n",
+		   host->io_port, host->io_port + host->n_io_port - 1);
+	seq_printf(m, "MMIO(virtual address): 0x%lx-0x%lx\n",
+		   host->base, host->base + data->MmioLength - 1);
+	seq_printf(m, "sg_tablesize:          %d\n",
+		   host->sg_tablesize);
+	seq_printf(m, "Chip revision:         0x%x\n",
+		   (nsp32_read2(base, INDEX_REG) >> 8) & 0xff);
 
 	mode_reg = nsp32_index_read1(base, CHIP_MODE);
 	model    = data->pci_devid->driver_data;
 
 #ifdef CONFIG_PM
-	seq_printf(m, "Power Management:      %s\n",          (mode_reg & OPTF) ? "yes" : "no");
+	seq_printf(m, "Power Management:      %s\n",
+		   (mode_reg & OPTF) ? "yes" : "no");
 #endif
-	seq_printf(m, "OEM:                   %ld, %s\n",     (mode_reg & (OEM0|OEM1)), nsp32_model[model]);
+	seq_printf(m, "OEM:                   %ld, %s\n",
+		   (mode_reg & (OEM0|OEM1)), nsp32_model[model]);
 
 	spin_lock_irqsave(&(data->Lock), flags);
 	seq_printf(m, "CurrentSC:             0x%p\n\n",      data->CurrentSC);
@@ -1476,7 +1500,7 @@ static int nsp32_show_info(struct seq_file *m, struct Scsi_Host *host)
 		}
 
 		if (data->target[id].sync_flag == SDTR_DONE) {
-			if (data->target[id].period == 0            &&
+			if (data->target[id].period == 0 &&
 			    data->target[id].offset == ASYNC_OFFSET ) {
 				seq_puts(m, "async");
 			} else {
@@ -1518,7 +1542,7 @@ static void nsp32_scsi_done(struct scsi_cmnd *SCpnt)
 	 * clear TRANSFERCONTROL_BM_START
 	 */
 	nsp32_write2(base, TRANSFER_CONTROL, 0);
-	nsp32_write4(base, BM_CNT,           0);
+	nsp32_write4(base, BM_CNT, 0);
 
 	/*
 	 * call scsi_done
@@ -1528,10 +1552,10 @@ static void nsp32_scsi_done(struct scsi_cmnd *SCpnt)
 	/*
 	 * reset parameters
 	 */
-	data->cur_lunt->SCpnt = NULL;
-	data->cur_lunt        = NULL;
-	data->cur_target      = NULL;
-	data->CurrentSC      = NULL;
+	data->cur_lunt->SCpnt	= NULL;
+	data->cur_lunt		= NULL;
+	data->cur_target	= NULL;
+	data->CurrentSC		= NULL;
 }
 
 
@@ -1553,7 +1577,7 @@ static int nsp32_busfree_occur(struct scsi_cmnd *SCpnt, unsigned short execph)
 	nsp32_dbg(NSP32_DEBUG_BUSFREE, "enter execph=0x%x", execph);
 	show_autophase(execph);
 
-	nsp32_write4(base, BM_CNT,           0);
+	nsp32_write4(base, BM_CNT, 0);
 	nsp32_write2(base, TRANSFER_CONTROL, 0);
 
 	/*
@@ -1561,7 +1585,7 @@ static int nsp32_busfree_occur(struct scsi_cmnd *SCpnt, unsigned short execph)
 	 *
 	 * VALID:
 	 *   Save Data Pointer is received. Adjust pointer.
-	 *   
+	 *
 	 * NO-VALID:
 	 *   SCSI-3 says if Save Data Pointer is not received, then we restart
 	 *   processing and we can't adjust any SCSI data pointer in next data
@@ -1574,7 +1598,7 @@ static int nsp32_busfree_occur(struct scsi_cmnd *SCpnt, unsigned short execph)
 		 * Check sack_cnt/saved_sack_cnt, then adjust sg table if
 		 * needed.
 		 */
-		if (!(execph & MSGIN_00_VALID) && 
+		if (!(execph & MSGIN_00_VALID) &&
 		    ((execph & DATA_IN_PHASE) || (execph & DATA_OUT_PHASE))) {
 			unsigned int sacklen, s_sacklen;
 
@@ -1617,7 +1641,7 @@ static int nsp32_busfree_occur(struct scsi_cmnd *SCpnt, unsigned short execph)
 		 * no processing.
 		 */
 	}
-	
+
 	if (execph & MSGIN_03_VALID) {
 		/* MsgIn03 was valid to be processed. No need processing. */
 	}
@@ -1639,7 +1663,7 @@ static int nsp32_busfree_occur(struct scsi_cmnd *SCpnt, unsigned short execph)
 		 * negotiating.
 		 */
 		if (execph & (MSGIN_00_VALID | MSGIN_04_VALID)) {
-			/* 
+			/*
 			 * If valid message is received, then
 			 * negotiation is succeeded.
 			 */
@@ -1667,12 +1691,12 @@ static int nsp32_busfree_occur(struct scsi_cmnd *SCpnt, unsigned short execph)
 
 		SCpnt->SCp.Status  = nsp32_read1(base, SCSI_CSB_IN);
 		SCpnt->SCp.Message = 0;
-		nsp32_dbg(NSP32_DEBUG_BUSFREE, 
+		nsp32_dbg(NSP32_DEBUG_BUSFREE,
 			  "normal end stat=0x%x resid=0x%x\n",
 			  SCpnt->SCp.Status, scsi_get_resid(SCpnt));
-		SCpnt->result = (DID_OK             << 16) |
-			        (SCpnt->SCp.Message <<  8) |
-			        (SCpnt->SCp.Status  <<  0);
+		SCpnt->result = (DID_OK << 16) |
+			(SCpnt->SCp.Message << 8) |
+			(SCpnt->SCp.Status << 0);
 		nsp32_scsi_done(SCpnt);
 		/* All operation is done */
 		return TRUE;
@@ -1680,7 +1704,7 @@ static int nsp32_busfree_occur(struct scsi_cmnd *SCpnt, unsigned short execph)
 		/* MsgIn 04: Disconnect */
 		SCpnt->SCp.Status  = nsp32_read1(base, SCSI_CSB_IN);
 		SCpnt->SCp.Message = 4;
-		
+
 		nsp32_dbg(NSP32_DEBUG_BUSFREE, "disconnect");
 		return TRUE;
 	} else {
@@ -1706,12 +1730,12 @@ static int nsp32_busfree_occur(struct scsi_cmnd *SCpnt, unsigned short execph)
 static void nsp32_adjust_busfree(struct scsi_cmnd *SCpnt, unsigned int s_sacklen)
 {
 	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
-	int                   old_entry = data->cur_entry;
-	int                   new_entry;
-	int                   sg_num = data->cur_lunt->sg_num;
-	nsp32_sgtable *sgt    = data->cur_lunt->sglun->sgt;
-	unsigned int          restlen, sentlen;
-	u32_le                len, addr;
+	int old_entry = data->cur_entry;
+	int new_entry;
+	int sg_num = data->cur_lunt->sg_num;
+	nsp32_sgtable *sgt = data->cur_lunt->sglun->sgt;
+	unsigned int restlen, sentlen;
+	u32_le len, addr;
 
 	nsp32_dbg(NSP32_DEBUG_SGLIST, "old resid=0x%x", scsi_get_resid(SCpnt));
 
@@ -1719,7 +1743,7 @@ static void nsp32_adjust_busfree(struct scsi_cmnd *SCpnt, unsigned int s_sacklen
 	s_sacklen -= le32_to_cpu(sgt[old_entry].addr) & 3;
 
 	/*
-	 * calculate new_entry from sack count and each sgt[].len 
+	 * calculate new_entry from sack count and each sgt[].len
 	 * calculate the byte which is intent to send
 	 */
 	sentlen = 0;
@@ -1737,8 +1761,10 @@ static void nsp32_adjust_busfree(struct scsi_cmnd *SCpnt, unsigned int s_sacklen
 
 	if (sentlen == s_sacklen) {
 		/* XXX: confirm it's ok or not */
-		/* In this case, it's ok because we are at 
-		   the head element of the sg. restlen is correctly calculated. */
+		/* In this case, it's ok because we are at
+		 * the head element of the sg. restlen is correctly
+		 * calculated.
+		 */
 	}
 
 	/* calculate the rest length for transferring */
@@ -1753,7 +1779,7 @@ static void nsp32_adjust_busfree(struct scsi_cmnd *SCpnt, unsigned int s_sacklen
 
 	/* set cur_entry with new_entry */
 	data->cur_entry = new_entry;
- 
+
 	return;
 
  last:
@@ -1781,7 +1807,7 @@ static void nsp32_msgout_occur(struct scsi_cmnd *SCpnt)
 	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
 	unsigned int base   = SCpnt->device->host->io_port;
 	int i;
-	
+
 	nsp32_dbg(NSP32_DEBUG_MSGOUTOCCUR,
 		  "enter: msgout_len: 0x%x", data->msgout_len);
 
@@ -1815,10 +1841,10 @@ static void nsp32_msgout_occur(struct scsi_cmnd *SCpnt)
 			//nsp32_restart_autoscsi(SCpnt, command);
 			nsp32_write2(base, COMMAND_CONTROL,
 					 (CLEAR_CDB_FIFO_POINTER |
-					  AUTO_COMMAND_PHASE     |
-					  AUTOSCSI_RESTART       |
-					  AUTO_MSGIN_00_OR_04    |
-					  AUTO_MSGIN_02          ));
+					  AUTO_COMMAND_PHASE |
+					  AUTOSCSI_RESTART |
+					  AUTO_MSGIN_00_OR_04 |
+					  AUTO_MSGIN_02 ));
 		}
 		/*
 		 * Write data with SACK, then wait sack is
@@ -1918,9 +1944,9 @@ static void nsp32_msgin_occur(struct scsi_cmnd     *SCpnt,
 	unsigned char  msgtype;
 	unsigned char  newlun;
 	unsigned short command  = 0;
-	int            msgclear = TRUE;
-	long           new_sgtp;
-	int            ret;
+	int	       msgclear = TRUE;
+	long	       new_sgtp;
+	int	       ret;
 
 	/*
 	 * read first message
@@ -1960,7 +1986,7 @@ static void nsp32_msgin_occur(struct scsi_cmnd     *SCpnt,
 			goto reject;
 		}
 	}
-	
+
 	/*
 	 * processing messages except for IDENTIFY
 	 *
@@ -1976,10 +2002,10 @@ static void nsp32_msgin_occur(struct scsi_cmnd     *SCpnt,
 		 * These messages should not be occurred.
 		 * They should be processed on AutoSCSI sequencer.
 		 */
-		nsp32_msg(KERN_WARNING, 
+		nsp32_msg(KERN_WARNING,
 			   "unexpected message of AutoSCSI MsgIn: 0x%x", msg);
 		break;
-		
+
 	case RESTORE_POINTERS:
 		/*
 		 * AutoMsgIn03 is disabled, and HBA gets this message.
@@ -2005,7 +2031,7 @@ static void nsp32_msgin_occur(struct scsi_cmnd     *SCpnt,
 		/*
 		 * set new sg pointer
 		 */
-		new_sgtp = data->cur_lunt->sglun_paddr + 
+		new_sgtp = data->cur_lunt->sglun_paddr +
 			(data->cur_lunt->cur_entry * sizeof(nsp32_sgtable));
 		nsp32_write4(base, SGT_ADR, new_sgtp);
 
@@ -2016,13 +2042,13 @@ static void nsp32_msgin_occur(struct scsi_cmnd     *SCpnt,
 		 * These messages should not be occurred.
 		 * They should be processed on AutoSCSI sequencer.
 		 */
-		nsp32_msg (KERN_WARNING, 
+		nsp32_msg (KERN_WARNING,
 			   "unexpected message of AutoSCSI MsgIn: SAVE_POINTERS");
-		
+
 		break;
-		
+
 	case MESSAGE_REJECT:
-		/* If previous message_out is sending SDTR, and get 
+		/* If previous message_out is sending SDTR, and get
 		   message_reject from target, SDTR negotiation is failed */
 		if (data->cur_target->sync_flag &
 				(SDTR_INITIATOR | SDTR_TARGET)) {
@@ -2041,7 +2067,7 @@ static void nsp32_msgin_occur(struct scsi_cmnd     *SCpnt,
 	case LINKED_CMD_COMPLETE:
 	case LINKED_FLG_CMD_COMPLETE:
 		/* queue tag is not supported currently */
-		nsp32_msg (KERN_WARNING, 
+		nsp32_msg (KERN_WARNING,
 			   "unsupported message: 0x%x", msgtype);
 		break;
 
@@ -2094,7 +2120,7 @@ static void nsp32_msgin_occur(struct scsi_cmnd     *SCpnt,
 		}
 
 		/*
-		 * Reach here means regular length of each type of 
+		 * Reach here means regular length of each type of
 		 * extended messages.
 		 */
 		switch (data->msginbuf[2]) {
@@ -2129,12 +2155,12 @@ static void nsp32_msgin_occur(struct scsi_cmnd     *SCpnt,
 			goto reject; /* not implemented yet */
 
 			break;
-			
+
 		default:
 			goto reject;
 		}
 		break;
-		
+
 	default:
 		goto reject;
 	}
@@ -2150,7 +2176,7 @@ static void nsp32_msgin_occur(struct scsi_cmnd     *SCpnt,
 		 * AutoSCSI restart, at the same time MsgOutOccur should be
 		 * happened (however, such situation is really possible...?).
 		 */
-		if (data->msgout_len > 0) {	
+		if (data->msgout_len > 0) {
 			nsp32_write4(base, SCSI_MSG_OUT, 0);
 			command |= AUTO_ATN;
 		}
@@ -2192,7 +2218,7 @@ static void nsp32_msgin_occur(struct scsi_cmnd     *SCpnt,
 	return;
 
  reject:
-	nsp32_msg(KERN_WARNING, 
+	nsp32_msg(KERN_WARNING,
 		  "invalid or unsupported MessageIn, rejected. "
 		  "current msg: 0x%x (len: 0x%x), processing msg: 0x%x",
 		  msg, data->msgin_len, msgtype);
@@ -2203,15 +2229,15 @@ static void nsp32_msgin_occur(struct scsi_cmnd     *SCpnt,
 }
 
 /*
- * 
+ *
  */
 static void nsp32_analyze_sdtr(struct scsi_cmnd *SCpnt)
 {
 	nsp32_hw_data   *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
-	nsp32_target     *target     = data->cur_target;
-	unsigned char     get_period = data->msginbuf[3];
-	unsigned char     get_offset = data->msginbuf[4];
-	int               entry;
+	nsp32_target    *target     = data->cur_target;
+	unsigned char    get_period = data->msginbuf[3];
+	unsigned char    get_offset = data->msginbuf[4];
+	int		 entry;
 
 	nsp32_dbg(NSP32_DEBUG_MSGINOCCUR, "enter");
 
@@ -2219,16 +2245,16 @@ static void nsp32_analyze_sdtr(struct scsi_cmnd *SCpnt)
 	 * If this inititor sent the SDTR message, then target responds SDTR,
 	 * initiator SYNCREG, ACKWIDTH from SDTR parameter.
 	 * Messages are not appropriate, then send back reject message.
-	 * If initiator did not send the SDTR, but target sends SDTR, 
+	 * If initiator did not send the SDTR, but target sends SDTR,
 	 * initiator calculator the appropriate parameter and send back SDTR.
-	 */	
+	 */
 	if (target->sync_flag & SDTR_INITIATOR) {
 		/*
 		 * Initiator sent SDTR, the target responds and
 		 * send back negotiation SDTR.
 		 */
 		nsp32_dbg(NSP32_DEBUG_MSGINOCCUR, "target responds SDTR");
-	
+
 		target->sync_flag &= ~SDTR_INITIATOR;
 		target->sync_flag |= SDTR_DONE;
 
@@ -2242,7 +2268,7 @@ static void nsp32_analyze_sdtr(struct scsi_cmnd *SCpnt)
 			 */
 			goto reject;
 		}
-		
+
 		if (get_offset == ASYNC_OFFSET) {
 			/*
 			 * Negotiation is succeeded, the target want
@@ -2273,7 +2299,7 @@ static void nsp32_analyze_sdtr(struct scsi_cmnd *SCpnt)
 
 		if (entry < 0) {
 			/*
-			 * Target want to use long period which is not 
+			 * Target want to use long period which is not
 			 * acceptable NinjaSCSI-32Bi/UDE.
 			 */
 			goto reject;
@@ -2286,7 +2312,7 @@ static void nsp32_analyze_sdtr(struct scsi_cmnd *SCpnt)
 	} else {
 		/* Target send SDTR to initiator. */
 		nsp32_dbg(NSP32_DEBUG_MSGINOCCUR, "target send SDTR");
-	
+
 		target->sync_flag |= SDTR_INITIATOR;
 
 		/* offset: */
@@ -2409,7 +2435,7 @@ static void nsp32_set_max_sync(nsp32_hw_data *data,
  */
 static void nsp32_set_sync_entry(nsp32_hw_data *data,
 				 nsp32_target  *target,
-				 int            entry,
+				 int		entry,
 				 unsigned char  offset)
 {
 	unsigned char period, ackwidth, sample_rate;
@@ -2438,7 +2464,7 @@ static void nsp32_set_sync_entry(nsp32_hw_data *data,
 static void nsp32_wait_req(nsp32_hw_data *data, int state)
 {
 	unsigned int  base      = data->BaseAddress;
-	int           wait_time = 0;
+	int	      wait_time = 0;
 	unsigned char bus, req_bit;
 
 	if (!((state == ASSERT) || (state == NEGATE))) {
@@ -2450,7 +2476,7 @@ static void nsp32_wait_req(nsp32_hw_data *data, int state)
 	do {
 		bus = nsp32_read1(base, SCSI_BUS_MONITOR);
 		if ((bus & BUSMON_REQ) == req_bit) {
-			nsp32_dbg(NSP32_DEBUG_WAIT, 
+			nsp32_dbg(NSP32_DEBUG_WAIT,
 				  "wait_time: %d", wait_time);
 			return;
 		}
@@ -2467,7 +2493,7 @@ static void nsp32_wait_req(nsp32_hw_data *data, int state)
 static void nsp32_wait_sack(nsp32_hw_data *data, int state)
 {
 	unsigned int  base      = data->BaseAddress;
-	int           wait_time = 0;
+	int	      wait_time = 0;
 	unsigned char bus, ack_bit;
 
 	if (!((state == ASSERT) || (state == NEGATE))) {
@@ -2532,8 +2558,8 @@ static int nsp32_detect(struct pci_dev *pdev)
 	struct Scsi_Host *host;	/* registered host structure */
 	struct resource  *res;
 	nsp32_hw_data    *data;
-	int               ret;
-	int               i, j;
+	int		  ret;
+	int		  i, j;
 
 	nsp32_dbg(NSP32_DEBUG_REGISTER, "enter");
 
@@ -2610,7 +2636,7 @@ static int nsp32_detect(struct pci_dev *pdev)
 	 */
 
 	/*
-	 * setup DMA 
+	 * setup DMA
 	 */
 	if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(32)) != 0) {
 		nsp32_msg (KERN_ERR, "failed to set PCI DMA mask");
@@ -2710,16 +2736,16 @@ static int nsp32_detect(struct pci_dev *pdev)
 		goto free_sg_list;
 	}
 
-        /*
+	/*
          * PCI IO register
          */
 	res = request_region(host->io_port, host->n_io_port, "nsp32");
 	if (res == NULL) {
-		nsp32_msg(KERN_ERR, 
+		nsp32_msg(KERN_ERR,
 			  "I/O region 0x%x+0x%x is already used",
 			  data->BaseAddress, data->NumAddress);
 		goto free_irq;
-        }
+	}
 
 	ret = scsi_add_host(host, &pdev->dev);
 	if (ret) {
@@ -2743,7 +2769,7 @@ static int nsp32_detect(struct pci_dev *pdev)
  free_autoparam:
 	dma_free_coherent(&pdev->dev, sizeof(nsp32_autoparam),
 			    data->autoparam, data->auto_paddr);
-	
+
  scsi_unregister:
 	scsi_host_put(host);
 
@@ -2810,7 +2836,7 @@ static int nsp32_eh_abort(struct scsi_cmnd *SCpnt)
 	}
 
 	nsp32_write2(base, TRANSFER_CONTROL, 0);
-	nsp32_write2(base, BM_CNT,           0);
+	nsp32_write2(base, BM_CNT, 0);
 
 	SCpnt->result = DID_ABORT << 16;
 	nsp32_scsi_done(SCpnt);
@@ -2833,8 +2859,8 @@ static void nsp32_do_bus_reset(nsp32_hw_data *data)
 	 * clear counter
 	 */
 	nsp32_write2(base, TRANSFER_CONTROL, 0);
-	nsp32_write4(base, BM_CNT,           0);
-	nsp32_write4(base, CLR_COUNTER,      CLRCOUNTER_ALLMASK);
+	nsp32_write4(base, BM_CNT, 0);
+	nsp32_write4(base, CLR_COUNTER, CLRCOUNTER_ALLMASK);
 
 	/*
 	 * fall back to asynchronous transfer mode
@@ -2856,7 +2882,7 @@ static void nsp32_do_bus_reset(nsp32_hw_data *data)
 	for(i = 0; i < 5; i++) {
 		intrdat = nsp32_read2(base, IRQ_STATUS); /* dummy read */
 		nsp32_dbg(NSP32_DEBUG_BUSRESET, "irq:1: 0x%x", intrdat);
-        }
+	}
 
 	data->CurrentSC = NULL;
 }
@@ -2867,7 +2893,7 @@ static int nsp32_eh_host_reset(struct scsi_cmnd *SCpnt)
 	unsigned int      base = SCpnt->device->host->io_port;
 	nsp32_hw_data    *data = (nsp32_hw_data *)host->hostdata;
 
-	nsp32_msg(KERN_INFO, "Host Reset");	
+	nsp32_msg(KERN_INFO, "Host Reset");
 	nsp32_dbg(NSP32_DEBUG_BUSRESET, "SCpnt=0x%x", SCpnt);
 
 	spin_lock_irq(SCpnt->device->host->host_lock);
@@ -2942,13 +2968,13 @@ static int nsp32_getprom_param(nsp32_hw_data *data)
  * AT24C01A (Logitec: LHA-600S), AT24C02 (Melco Buffalo: IFC-USLP) data map:
  *
  *   ROMADDR
- *   0x00 - 0x06 :  Device Synchronous Transfer Period (SCSI ID 0 - 6) 
+ *   0x00 - 0x06 :  Device Synchronous Transfer Period (SCSI ID 0 - 6)
  *			Value 0x0: ASYNC, 0x0c: Ultra-20M, 0x19: Fast-10M
  *   0x07        :  HBA Synchronous Transfer Period
  *			Value 0: AutoSync, 1: Manual Setting
  *   0x08 - 0x0f :  Not Used? (0x0)
  *   0x10        :  Bus Termination
- * 			Value 0: Auto[ON], 1: ON, 2: OFF
+ *			Value 0: Auto[ON], 1: ON, 2: OFF
  *   0x11        :  Not Used? (0)
  *   0x12        :  Bus Reset Delay Time (0x03)
  *   0x13        :  Bootable CD Support
@@ -2956,7 +2982,7 @@ static int nsp32_getprom_param(nsp32_hw_data *data)
  *   0x14        :  Device Scan
  *			Bit   7  6  5  4  3  2  1  0
  *			      |  <----------------->
- * 			      |    SCSI ID: Value 0: Skip, 1: YES
+ *			      |    SCSI ID: Value 0: Skip, 1: YES
  *			      |->  Value 0: ALL scan,  Value 1: Manual
  *   0x15 - 0x1b :  Not Used? (0)
  *   0x1c        :  Constant? (0x01) (clock div?)
@@ -2967,10 +2993,10 @@ static int nsp32_getprom_param(nsp32_hw_data *data)
  */
 static int nsp32_getprom_at24(nsp32_hw_data *data)
 {
-	int           ret, i;
-	int           auto_sync;
+	int	      ret, i;
+	int	      auto_sync;
 	nsp32_target *target;
-	int           entry;
+	int	      entry;
 
 	/*
 	 * Reset time which is designated by EEPROM.
@@ -3036,7 +3062,7 @@ static int nsp32_getprom_at24(nsp32_hw_data *data)
  * C16 110 (I-O Data: SC-NBD) data map:
  *
  *   ROMADDR
- *   0x00 - 0x06 :  Device Synchronous Transfer Period (SCSI ID 0 - 6) 
+ *   0x00 - 0x06 :  Device Synchronous Transfer Period (SCSI ID 0 - 6)
  *			Value 0x0: 20MB/S, 0x1: 10MB/S, 0x2: 5MB/S, 0x3: ASYNC
  *   0x07        :  0 (HBA Synchronous Transfer Period: Auto Sync)
  *   0x08 - 0x0f :  Not Used? (0x0)
@@ -3044,7 +3070,7 @@ static int nsp32_getprom_at24(nsp32_hw_data *data)
  *			Value 0: PIO, 1: Busmater
  *   0x11        :  Bus Reset Delay Time (0x00-0x20)
  *   0x12        :  Bus Termination
- * 			Value 0: Disable, 1: Enable
+ *			Value 0: Disable, 1: Enable
  *   0x13 - 0x19 :  Disconnection
  *			Value 0: Disable, 1: Enable
  *   0x1a - 0x7c :  Not Used? (0)
@@ -3054,9 +3080,9 @@ static int nsp32_getprom_at24(nsp32_hw_data *data)
  */
 static int nsp32_getprom_c16(nsp32_hw_data *data)
 {
-	int           ret, i;
+	int	      ret, i;
 	nsp32_target *target;
-	int           entry, val;
+	int	      entry, val;
 
 	/*
 	 * Reset time which is designated by EEPROM.
@@ -3156,7 +3182,7 @@ static int nsp32_prom_read(nsp32_hw_data *data, int romaddr)
 	for (i = 7; i >= 0; i--) {
 		val += (nsp32_prom_read_bit(data) << i);
 	}
-	
+
 	/* no ack */
 	nsp32_prom_write_bit(data, 1);
 
@@ -3281,7 +3307,8 @@ static int nsp32_resume(struct pci_dev *pdev)
 	nsp32_hw_data    *data = (nsp32_hw_data *)host->hostdata;
 	unsigned short    reg;
 
-	nsp32_msg(KERN_INFO, "pci-resume: pdev=0x%p, slot=%s, host=0x%p", pdev, pci_name(pdev), host);
+	nsp32_msg(KERN_INFO, "pci-resume: pdev=0x%p, slot=%s, host=0x%p",
+		  pdev, pci_name(pdev), host);
 
 	pci_set_power_state(pdev, PCI_D0);
 	pci_enable_wake    (pdev, PCI_D0, 0);
@@ -3316,13 +3343,13 @@ static int nsp32_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	nsp32_dbg(NSP32_DEBUG_REGISTER, "enter");
 
-        ret = pci_enable_device(pdev);
+	ret = pci_enable_device(pdev);
 	if (ret) {
 		nsp32_msg(KERN_ERR, "failed to enable pci device");
 		return ret;
 	}
 
-	data->Pci         = pdev;
+	data->Pci	  = pdev;
 	data->pci_devid   = id;
 	data->IrqNumber   = pdev->irq;
 	data->BaseAddress = pci_resource_start(pdev, 0);
@@ -3351,7 +3378,7 @@ static void nsp32_remove(struct pci_dev *pdev)
 
 	nsp32_dbg(NSP32_DEBUG_REGISTER, "enter");
 
-        scsi_remove_host(host);
+	scsi_remove_host(host);
 
 	nsp32_release(host);
 
@@ -3364,8 +3391,8 @@ static struct pci_driver nsp32_driver = {
 	.probe		= nsp32_probe,
 	.remove		= nsp32_remove,
 #ifdef CONFIG_PM
-	.suspend	= nsp32_suspend, 
-	.resume		= nsp32_resume, 
+	.suspend	= nsp32_suspend,
+	.resume		= nsp32_resume,
 #endif
 };
 
-- 
2.29.2

