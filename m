Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793794247;
	b=eJMEPj+7QcBiFt2euFebKPXeoVF7yYh7P2z58Up3YP/Lqb4mWVcTjvMhbtTKXVzZtr6c
	 9vye9wZdQSKByqcIAEAxXJDwUUhD+5NE2yLk+nylDAl4icwC3sgz5DEZ+7X/RzQEl5QuP
	 njnQ3liBq7irssB2Q/sLUbMSOjif7RBlLfg7AYbbdqT/+ZTxXgZ6CPFDoyrwECiat5QLM
	 qgZolB7O5mmxhIhARSrH9aLdCJHB5SNtONTx+A7Qr0VZ19PvaLO+sPVknDLJiC3OGDW0L
	 quaAmQgcKf3y+iivZlVITtlNgY6ksuJOAcV0Ypqs/NRXE/TJTl+0wQNZvlgIXxwYRXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793794247;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=cmfueqzGwoFvEv5uM0QKODsWHqiJE8tckrDOG8iRvHw=;
	b=nkN6SXgbtpWR+Bs6JFVWnWzCAg+LGKePscwTCqahGyx+6t8b4aCnunVZJ6n4Esn+2PPQ
	 FsiW/XCCexhDH+52itpe5waEEbTaksIXG5ssKy7A2aZrTtTIeQcxVvZZUOJFpLm0TayqQ
	 y6C0KOLYKDXRZUSaTp2PC/mJlgEHQQ1v4c3XVkiHNW0g+z0LCSlbgguvJXdEo0ZaEx123
	 vZ6nEfKBaiicbC9gH6FC3Gonb5Fhogy8R54475/Mo4fgyoFw20CiLRWi0zlO5iap0yDg4
	 H4bjymhdLI63Xs6d+A88cEAb4wQtTy8s217jp4JYoafOJEfUSVyWNvhAmZZG4SzaBKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=S2bo92ps;
	arc=none smtp.remote-ip=209.85.216.98
Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A47606A32C
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 12:10:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E6A47606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=S2bo92ps
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-3ac77270fbfso380329a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:10:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793794246; x=1794399046;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cmfueqzGwoFvEv5uM0QKODsWHqiJE8tckrDOG8iRvHw=;
        b=RvFlbGvMHhxGJCdsxxTFQY8ffUZC16n3jOmK1clOkpZ77xo0Aed7dmCNOyBgWyOPrc
         XQtpz+4G1cS3dHBDQS43vTNUgK9v0FuaF7JSmLxQbMgauD/Zj1Xvxpl1e+qcKb1Rc5AM
         azb34lTFHWH+K9aHJ1bugLrPhC4RohAGybZ3UuCZdURWaV7LR2xq93aIQ/3oMG3jvdtR
         hyNUqoP7UfgBBe5qa2ogBVo37UBHxC7kBNcqGWwi7mHzefSpUD4n+BVmrRN7HJQuLFO3
         im3iaZ+B24qzLe8sMWlOYwhmI501bUfyI01zMgS+7XdklflNaYnf4kWtwprh3igzsCpc
         Ep7Q==
X-Gm-Message-State: APuU4Z8aznV3Z4lnphlJ5ynjhjgzGVMorOpAZml8GKfZT1KsWNQdQB+z
	VHNkccs3RNvIS9D05tnMvmh2WngYXbCdXxCf3XTuLHHlv4eEjgGGJm1LGqBfUtAR45sDO0hNJPU
	pWgt1mu1opjS5Ezq/cER/ntPZWwRMqXc0Oow/FCMBFjtuX5iV6w21MDQ6iUE7u3ZafuvfB5lHu7
	hfBGWVA0NKICrSK2RAlBrIjdySzDg/tHHniTipDH3FolWmD8gtHH6gGIbN961YxrcCmWPLVdCAx
	hNNdJlsa3ybLRV8
X-Gm-Gg: AYBFou2zLYrzdGoH9JhYzzs5F86tdsGMG+hR6cO3nxfd2cW0CDOoEmc3URTFsA7ImTW
	ABiLM7efIW10Q9QDsxPAYCpjCz+0vAZ2vvfU7rrDQV83a87dD/t29K/0A/j/SDJlRrm9i4DAOru
	ho9e4AMtOMW8kn2x3xsifKgZAGi76f72g/nKYmq91pnrDdnSRuY1bk8ZS6LCiD94Iq8XC3xO16y
	DngrEkHlLT3/QztuArdjeMTHQtPqme5aLaaiFez4NaWVv5TZHL0JvCWM6zy8g7rk4Og64k9BiaR
	6bJFynR6Eo20aB56iEDMNC1d4vcWgDKgNQiIvLJdoq0X9tPojmZ9THcH3qh0CbfFiWkQSc4cjXh
	3+dGwSJrOvzqOttu8s8LZ4WpXtbJkQL+MB+cpaY64RnZMypS0p+l3HD4YsOiqVHC73MUdsPvgvF
	4BHSzITr54ThE13Gg+aCyyhEqn/NwbQzKHpvQ=
X-Received: by 2002:a17:90b:584c:b0:3ac:fe93:a731 with SMTP id 98e67ed59e1d1-3ae8981e640mr12106878a91.56.1793794246178;
        Wed, 04 Nov 2026 04:10:46 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b096bd09e8sm505423a91.4.2026.11.04.04.10.45
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2026 04:10:46 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-1aa0fb7f157so1165785c88.0
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:10:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793794244; x=1794399044; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cmfueqzGwoFvEv5uM0QKODsWHqiJE8tckrDOG8iRvHw=;
        b=S2bo92psaqSd93luupy77qFDUhFiKKc8z3Njk/yOSKa7eqNPwQbBn6NTSyEourMRcA
         G1VXZMC2kdi60pu7WlZFh1Tw5vNMEL5q0fzi0wDkjTWP2cJAgYVDqPRnEB27p62e/Ng5
         mypmr2tnUfn/G+mODB6AEgMzSYutha4Noh/Qk=
X-Received: by 2002:a05:7022:1509:b0:151:f0c5:7a09 with SMTP id a92af1059eb24-1ac5e22adbamr27313269c88.43.1793794243885;
        Wed, 04 Nov 2026 04:10:43 -0800 (PST)
X-Received: by 2002:a05:7022:1509:b0:151:f0c5:7a09 with SMTP id a92af1059eb24-1ac5e22adbamr27313219c88.43.1793794242947;
        Wed, 04 Nov 2026 04:10:42 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c6f0dcsm9377095c88.21.2026.11.04.04.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 04:10:42 -0800 (PST)
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
Subject: [PATCH 16/21] scsi: mpi3mr: Fix sense buffer use after free on BSG command completion
Date: Wed,  4 Nov 2026 17:30:57 +0530
Message-ID: <20261104120103.503871-17-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261104120103.503871-1-ranjan.kumar@broadcom.com>
References: <20261104120103.503871-1-ranjan.kumar@broadcom.com>
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
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h     |  1 +
 drivers/scsi/mpi3mr/mpi3mr_app.c | 35 ++++++++++++++++++++++++--------
 drivers/scsi/mpi3mr/mpi3mr_fw.c  |  8 ++++++++
 drivers/scsi/mpi3mr/mpi3mr_os.c  |  3 +++
 4 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 8738fc2ce7e7..deb8a1eea917 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -898,6 +898,7 @@ struct mpi3mr_sdev_priv_data {
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
index 67d41e4a0a0a..ed9e83a4119c 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5582,6 +5582,7 @@ static inline void mpi3mr_init_drv_cmd(struct mpi3mr_drv_cmd *cmdptr,
 	u16 host_tag)
 {
 	mutex_init(&cmdptr->mutex);
+	spin_lock_init(&cmdptr->state_lock);
 	cmdptr->reply = NULL;
 	cmdptr->state = MPI3MR_CMD_NOTUSED;
 	cmdptr->dev_handle = MPI3MR_INVALID_DEV_HANDLE;
@@ -5732,6 +5733,8 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	mpi3mr_init_drv_cmd(&mrioc->cfg_cmds, MPI3MR_HOSTTAG_CFG_CMDS);
 	mpi3mr_init_drv_cmd(&mrioc->transport_cmds,
 	    MPI3MR_HOSTTAG_TRANSPORT_CMDS);
+	mpi3mr_init_drv_cmd(&mrioc->pel_cmds, MPI3MR_HOSTTAG_PEL_WAIT);
+	mpi3mr_init_drv_cmd(&mrioc->pel_abort_cmd, MPI3MR_HOSTTAG_PEL_ABORT);
 
 	for (i = 0; i < MPI3MR_NUM_DEVRMCMD; i++)
 		mpi3mr_init_drv_cmd(&mrioc->dev_rmhs_cmds[i],
-- 
2.47.3

