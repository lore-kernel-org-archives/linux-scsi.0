Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.228
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795072805;
	b=T0e7be2ZEA242NdL3nIeUw4tOKSyK8URb9TExCZeOzrKosPS+P9c8iVL6dGNTTJEmhZg
	 bcHNsu19E2zBIfHggQRY/i7nUKfonp5ljPadcWzzJ7kBdJtHuRLkjNW3+MEQ68IF1xIzz
	 mVK3LMTk4HDIfNh8b6Xg2N7h59IYTfwyTM2edyeKYk4pKBWXNF4FTVTJZVNmWMnXEOS1J
	 57HA76GeDGP4aVroT/huN50pUBUxMB67EdrvZHBdI6EzV4ORQKRAN9Dbfw85TS2hPHJ4m
	 lM0KSYPR8TN0rjZ31L7FHHrGyFi2sWlWZ5PhGY3sYNRZZ099sbxueCRq1lVqhGLgHNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795072805;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=tkK8B5Ae5N8rGpWQn0hg6lArz1DEMVv76JZmuGYWiN4=;
	b=ymBuNkteyP/DFf+J/Y4sWmEoa+7xnf2zO92aTMFT9obYl8npC4uNwgB2sNf4rh3NWRXE
	 sn7TuOtSP+cjGlrTlNlv8cutQZZMW3z+T7gLQXfIpsZ+K9GtNdjKhdoB+VjVR0WLLWc48
	 Cyz+3TYYa9z+KccV9M1db4ozLLmTwD/1JGVsuA/dgDOe0sEFhhvUpNQ7UoHfNQA3GCAHf
	 br9bHTo2zNdh+cNhUBXQnmxffKjCRp5ZPNbfXRk1HisqGJXbbrE5V+/ZNGU4ZAtF7Md+q
	 5DWZ4qgUzn+WRvMZena551ziGPRg/4dHXc4Y7mt9WY/cTj6yMYlGjhJi5agYZy9pJxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=HTzxLhch;
	arc=none smtp.remote-ip=209.85.215.228
Received: from mail-pg1-f228.google.com (mail-pg1-f228.google.com [209.85.215.228])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB990606A324
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 07:20:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DB990606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=HTzxLhch
Received: by mail-pg1-f228.google.com with SMTP id 41be03b00d2f7-cdb2893531bso1312541a12.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:20:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795072804; x=1795677604;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tkK8B5Ae5N8rGpWQn0hg6lArz1DEMVv76JZmuGYWiN4=;
        b=L9foFykJGgjxSaLnxeM6iodbKCfe21SCQkRzYWyun/imi4yUiJJfXGrJCj991stVU4
         sE+KWLY+hH9wx5vHgWRWFJKDKKLVW3VisCtkeSGjd9F94+ANv65gXBuAvOiXNxPkgkUO
         xQrEDGVfXESORKXOtXKiK5H5q/mBt5kfVN6/1Zvsel5ZCUCw4gIbIhHMz79XaVN4+7iZ
         XUGNTOIe7MzQDXBjUAsq6ukoriys11vavPHael3NNa1FJUxkgCVWdXfYq6KPUsZPrhVB
         GYKoGSHhqhAuksLVBRWomWxriQ2nXAkJjdka8lWAZcYPvroRXsE2vKfjP5hL2q0OWLpX
         m3CQ==
X-Gm-Message-State: APuU4Z/3Y1wMbWZmAnoqTXZ8+LnGhe8HmNALmKRdMfj5y30NCPQ3l+/P
	2ec52LZB3y7xcYD4hoDdQs3L8bUfDkdmRDHVbBW6y4sJzeBheLziRF27C/cZI9dYPrLonVX5UOz
	Tf980AMJlXsjHkZHeSGzs1qXx0+EYynypE7htcWMZ8RH4yIhhKJLLMHkqhtd7zq74eYM8Cx0qwU
	wL1W/UeJzvXKb7/0stiiq4Ys2oKTMbwkQ5ocV75ZJXT7cg9AjPnmiFlpQGdp6ptbwwYTlb/Sb/e
	Pg8/sfVBdQtqtq/
X-Gm-Gg: AZFdTZcs1c2camPmefOkowQ1LufDQ2rMXa1fslX9F83JbJN4uLRkCthY24/31fJk+Wx
	tCBu6o92nVoL8o+phh95oud2OF58UbAGtLgAAlfB3dbpOZMSG1anmYYHaB1Sd2NYtDwSq4KnGP0
	4Z8oRe412PuTQlWankPBMgZ4lr18vgHyIuTT0gcsecGmJDo8OAtST2vSQMvDSt3CERvdaKDYHlN
	mpTQWznU35IsK4NoP0raTIY+LG3IuzKZt9j6P3yHtHHw+v4mA3z3e0yL4ECUFbUqtLndQKJkqdv
	9FncwTQjyym5xMRivXfzgrS4tmSjXN9fWn9SSImvMHB8M55i29QYqrsrxgBD7b+zx/l2c3+7Wke
	5XzJ4LgxwzdcHjTNWfNLTFwV4e2102z+MIu7Mk/EDIdcgUeL0gCxVsUqWawjFkklEG1ZrpHnELI
	ccFtBf1vh9a61VwrltqFFOd65iKDxppCV+eFY=
X-Received: by 2002:a17:90b:3f0b:b0:3ad:aa1a:312e with SMTP id 98e67ed59e1d1-3b3d0641fd8mr5548111a91.3.1795072804074;
        Wed, 18 Nov 2026 23:20:04 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b405cece29sm514934a91.6.2026.11.18.23.20.03
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 23:20:04 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cc4216aee8fso2319113a12.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:20:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1795072802; x=1795677602; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tkK8B5Ae5N8rGpWQn0hg6lArz1DEMVv76JZmuGYWiN4=;
        b=HTzxLhchvz9JaxrwPrueLUX5nJ7jCE9k7iJ3t1gc3BMrVuHEzk2+bf0/w33G/NlqIX
         QbuKnRsuo9m49c1zhf5p9LhfdGl2TKoUdSOyzcy+cpeijH21UUZX+dz528ndovfx+4iT
         XnZJRrI4wZR2ZYvyLc3LEUhaKdGSrao5G49o4=
X-Received: by 2002:a17:90b:4d04:b0:3ac:9d14:fe9f with SMTP id 98e67ed59e1d1-3b3d0762449mr5178185a91.31.1795072801995;
        Wed, 18 Nov 2026 23:20:01 -0800 (PST)
X-Received: by 2002:a17:90b:4d04:b0:3ac:9d14:fe9f with SMTP id 98e67ed59e1d1-3b3d0762449mr5178162a91.31.1795072801491;
        Wed, 18 Nov 2026 23:20:01 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b402981814sm748560a91.2.2026.11.18.23.19.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 23:20:01 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v2 16/20] scsi: mpi3mr: Fix sense buffer use after free on BSG command completion
Date: Thu, 19 Nov 2026 12:41:28 +0530
Message-ID: <20261119071133.127282-17-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261119071133.127282-1-ranjan.kumar@broadcom.com>
References: <20261119071133.127282-1-ranjan.kumar@broadcom.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The interrupt handler writes the reply and sense data of a BSG command
into the command tracker while the ioctl can time out, clear the sense
buffer pointer and free the buffer at the same time.

Add a lock to the command tracker and take it in the handler, the reset
flush and the ioctl. The callbacks run under it and never sleep. Also
initialize the two PEL trackers, which never had their lock set up.

Fixes: f762326b2baa ("scsi: mpi3mr: Propagate sense data for admin queue SCSI I/O")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260818231426.58105-1-chandrakanth.patil@broadcom.com?part=1
Closes: https://sashiko.dev/#/patchset/20260825210411.301535-1-chandrakanth.patil@broadcom.com?part=1
Closes: https://sashiko.dev/#/patchset/20260825210411.301535-1-chandrakanth.patil@broadcom.com?part=4
Closes: https://sashiko.dev/#/patchset/20261104120103.503871-1-ranjan.kumar@broadcom.com?part=16
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h     |  2 ++
 drivers/scsi/mpi3mr/mpi3mr_app.c | 35 ++++++++++++++++++++++++--------
 drivers/scsi/mpi3mr/mpi3mr_fw.c  |  8 ++++++++
 drivers/scsi/mpi3mr/mpi3mr_os.c  |  3 +++
 4 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index c516c00a1dd1..403ca56c26ac 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -885,6 +885,7 @@ struct mpi3mr_sdev_priv_data {
  * struct mpi3mr_drv_cmd - Internal command tracker
  *
  * @mutex: Command mutex
+ * @state_lock: Protects the state, the sense buffer and the callback
  * @done: Completeor for wakeup
  * @reply: Firmware reply for internal commands
  * @sensebuf: Sensebuf for SCSI IO commands
@@ -901,6 +902,7 @@ struct mpi3mr_sdev_priv_data {
  */
 struct mpi3mr_drv_cmd {
 	struct mutex mutex;
+	spinlock_t state_lock;
 	struct completion done;
 	void *reply;
 	u8 *sensebuf;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 30a01b02a9fc..fb54bd8093da 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2447,7 +2447,9 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 	u8 *sgl_iter = NULL, *sgl_din_iter = NULL, *sgl_dout_iter = NULL;
 	u16 rmc_size  = 0, desc_count = 0;
 	size_t req_min, buf_left;
-	bool prp_owned = false, timed_out = false;
+	bool prp_owned = false, timed_out = false, completed;
+	unsigned long flags;
+	u16 cmd_state;
 
 	bsg_req = job->request;
 	karg = (struct mpi3mr_bsg_mptcmd *)&bsg_req->cmd.mptcmd;
@@ -2795,11 +2797,13 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 			block_seq = mpi3mr_tgtdev_block_io_inc(mrioc, tgtdev);
 	}
 
+	spin_lock_irqsave(&mrioc->bsg_cmds.state_lock, flags);
 	mrioc->bsg_cmds.state = MPI3MR_CMD_PENDING;
 	mrioc->bsg_cmds.is_waiting = 1;
 	mrioc->bsg_cmds.callback = NULL;
 	mrioc->bsg_cmds.is_sense = 0;
 	mrioc->bsg_cmds.sensebuf = sense_buff_k;
+	spin_unlock_irqrestore(&mrioc->bsg_cmds.state_lock, flags);
 	memset(mrioc->bsg_cmds.reply, 0, mrioc->reply_sz);
 	mpi_header->host_tag = cpu_to_le16(MPI3MR_HOSTTAG_BSG_CMDS);
 	if (mrioc->logging_level & MPI3_DEBUG_BSG_INFO) {
@@ -2820,7 +2824,9 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 
 
 	if (rval) {
+		spin_lock_irqsave(&mrioc->bsg_cmds.state_lock, flags);
 		mrioc->bsg_cmds.is_waiting = 0;
+		spin_unlock_irqrestore(&mrioc->bsg_cmds.state_lock, flags);
 		dprint_bsg_err(mrioc,
 		    "%s: posting bsg request is failed\n", __func__);
 		rval = -EAGAIN;
@@ -2836,11 +2842,16 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 		mpi3mr_tgtdev_block_io_dec(mrioc, tgtdev, block_seq);
 		mpi3mr_tgtdev_put(tgtdev);
 	}
-	if (!(mrioc->bsg_cmds.state & MPI3MR_CMD_COMPLETE)) {
-		timed_out = true;
+	spin_lock_irqsave(&mrioc->bsg_cmds.state_lock, flags);
+	cmd_state = mrioc->bsg_cmds.state;
+	completed = cmd_state & MPI3MR_CMD_COMPLETE;
+	if (!completed)
 		mrioc->bsg_cmds.is_waiting = 0;
+	spin_unlock_irqrestore(&mrioc->bsg_cmds.state_lock, flags);
+	if (!completed) {
+		timed_out = true;
 		rval = -EAGAIN;
-		if (mrioc->bsg_cmds.state & MPI3MR_CMD_RESET)
+		if (cmd_state & MPI3MR_CMD_RESET)
 			goto out_unlock;
 		if (((mpi_header->function != MPI3_FUNCTION_SCSI_IO) &&
 		    (mpi_header->function != MPI3_FUNCTION_NVME_ENCAPSULATED))
@@ -2870,8 +2881,11 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 			    MPI3MR_HOSTTAG_BLK_TMS, MPI3MR_RESETTM_TIMEOUT,
 			    &mrioc->host_tm_cmds, &resp_code, NULL);
 		}
-		if (!(mrioc->bsg_cmds.state & MPI3MR_CMD_COMPLETE) &&
-		    !(mrioc->bsg_cmds.state & MPI3MR_CMD_RESET))
+		spin_lock_irqsave(&mrioc->bsg_cmds.state_lock, flags);
+		cmd_state = mrioc->bsg_cmds.state;
+		spin_unlock_irqrestore(&mrioc->bsg_cmds.state_lock, flags);
+		if (!(cmd_state & MPI3MR_CMD_COMPLETE) &&
+		    !(cmd_state & MPI3MR_CMD_RESET))
 			mpi3mr_soft_reset_handler(mrioc,
 			    MPI3MR_RESET_FROM_APP_TIMEOUT, 1);
 		goto out_unlock;
@@ -2947,14 +2961,17 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 
 out_unlock:
 	if (prp_owned) {
+		spin_lock_irqsave(&mrioc->bsg_cmds.state_lock, flags);
+		cmd_state = mrioc->bsg_cmds.state;
+		spin_unlock_irqrestore(&mrioc->bsg_cmds.state_lock, flags);
 		/*
 		 * Do not free the PRP list if a timed out command may still be
 		 * using it. Leaking it is safer than letting the controller read
 		 * freed memory.
 		 */
 		if (!timed_out ||
-		    (mrioc->bsg_cmds.state & MPI3MR_CMD_COMPLETE) ||
-		    ((mrioc->bsg_cmds.state & MPI3MR_CMD_RESET) &&
+		    (cmd_state & MPI3MR_CMD_COMPLETE) ||
+		    ((cmd_state & MPI3MR_CMD_RESET) &&
 		    !mrioc->unrecoverable))
 			dma_free_coherent(&mrioc->pdev->dev, mrioc->prp_sz,
 			    mrioc->prp_list_virt, mrioc->prp_list_dma);
@@ -2966,9 +2983,11 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 					    job->reply_payload.sg_cnt,
 					    din_buf, job->reply_payload.payload_len);
 	}
+	spin_lock_irqsave(&mrioc->bsg_cmds.state_lock, flags);
 	mrioc->bsg_cmds.is_sense = 0;
 	mrioc->bsg_cmds.sensebuf = NULL;
 	mrioc->bsg_cmds.state = MPI3MR_CMD_NOTUSED;
+	spin_unlock_irqrestore(&mrioc->bsg_cmds.state_lock, flags);
 	mutex_unlock(&mrioc->bsg_cmds.mutex);
 out:
 	kfree(sense_buff_k);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index eb3f41f50649..6d43112aebb7 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -442,6 +442,9 @@ static void mpi3mr_process_admin_reply_desc(struct mpi3mr_ioc *mrioc,
 
 	cmdptr = mpi3mr_get_drv_cmd(mrioc, host_tag, def_reply);
 	if (cmdptr) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&cmdptr->state_lock, flags);
 		if (cmdptr->state & MPI3MR_CMD_PENDING) {
 			cmdptr->state |= MPI3MR_CMD_COMPLETE;
 			cmdptr->ioc_loginfo = ioc_loginfo;
@@ -466,6 +469,7 @@ static void mpi3mr_process_admin_reply_desc(struct mpi3mr_ioc *mrioc,
 			} else if (cmdptr->callback)
 				cmdptr->callback(mrioc, cmdptr);
 		}
+		spin_unlock_irqrestore(&cmdptr->state_lock, flags);
 	}
 out:
 	if (sense_buf)
@@ -5333,6 +5337,9 @@ void mpi3mr_cleanup_ioc(struct mpi3mr_ioc *mrioc)
 static inline void mpi3mr_drv_cmd_comp_reset(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_drv_cmd *cmdptr)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&cmdptr->state_lock, flags);
 	if (cmdptr->state & MPI3MR_CMD_PENDING) {
 		cmdptr->state |= MPI3MR_CMD_RESET;
 		cmdptr->state &= ~MPI3MR_CMD_PENDING;
@@ -5342,6 +5349,7 @@ static inline void mpi3mr_drv_cmd_comp_reset(struct mpi3mr_ioc *mrioc,
 		} else if (cmdptr->callback)
 			cmdptr->callback(mrioc, cmdptr);
 	}
+	spin_unlock_irqrestore(&cmdptr->state_lock, flags);
 }
 
 /**
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 7a8bd20844e6..3fb9d4de2d65 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5585,6 +5585,7 @@ static inline void mpi3mr_init_drv_cmd(struct mpi3mr_drv_cmd *cmdptr,
 	u16 host_tag)
 {
 	mutex_init(&cmdptr->mutex);
+	spin_lock_init(&cmdptr->state_lock);
 	cmdptr->reply = NULL;
 	cmdptr->state = MPI3MR_CMD_NOTUSED;
 	cmdptr->dev_handle = MPI3MR_INVALID_DEV_HANDLE;
@@ -5735,6 +5736,8 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	mpi3mr_init_drv_cmd(&mrioc->cfg_cmds, MPI3MR_HOSTTAG_CFG_CMDS);
 	mpi3mr_init_drv_cmd(&mrioc->transport_cmds,
 	    MPI3MR_HOSTTAG_TRANSPORT_CMDS);
+	mpi3mr_init_drv_cmd(&mrioc->pel_cmds, MPI3MR_HOSTTAG_PEL_WAIT);
+	mpi3mr_init_drv_cmd(&mrioc->pel_abort_cmd, MPI3MR_HOSTTAG_PEL_ABORT);
 
 	for (i = 0; i < MPI3MR_NUM_DEVRMCMD; i++)
 		mpi3mr_init_drv_cmd(&mrioc->dev_rmhs_cmds[i],
-- 
2.47.3

