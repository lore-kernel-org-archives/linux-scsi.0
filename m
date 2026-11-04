Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793794239;
	b=Cbi/jQdkKabeVxpJqKgQOa4SaoKWX+6xl9EAeY8+pH4h9KSLJmk+935R0lztLZODjH4z
	 pjCyydbddPEOkemfr9jQ/Jz4YLd8c/ffjbt7dGN9XZKuN4Sc4sm6DOf+p6wUzBZSUuU71
	 +qgI1QWWrKjnhxQSBVFGg7Ktd5+r1KN/gCXEN3PSsaFRbSlpBvaiOTNeFBAS62A2xO/Y1
	 7krsBT53tt1bt8xJwexKHysXmhCrc3WNz9r1CP9PaA0H5G7/X9XzoBnzS1wlZv3YAhrzP
	 ScbRN5oVQVMlFV4mCcVO/MMp+YkJlMEsz4vSJG7LPqtS7oFvc/EXcFeKNYu1bikrQbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793794239;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=+cf3Ln9MMScgvm+FsTh0nTph/tgABNJ19lQjeccgv5U=;
	b=ss8uAq8kasrzYSc6vIAjOVbscj6BkXz7BzQEE9I2blsZIsjQJKB5YsvAenvpW72hYXWq
	 s6CirpFGdLZKUqReZWTYixDOu57mT7lm1DtUJRLbrV8RBS1K7Fl1o20LyxEwRHRpkaAZO
	 Tdc4PaKoYPDHu8YC0LOEl/tGpGdIttvgvhfdByj5+zHEalRQvbIMo3Clx15GTCWLkFI/7
	 0iVLYkGK9GXkDDNL5HrsbXmh5iRO2FmZNeHQiP/jxBQLzNc0s3lHxPmy40ykKBxpFYuP7
	 9A6kjNlfYQhDOsX+yUExWm/atfN3xZsAlBVq8uyNUqibLrkqHxbKHLhj+jq6Ta/f3qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Q3xotSBO;
	arc=none smtp.remote-ip=209.85.216.98
Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B990606A31B
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 12:10:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B990606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Q3xotSBO
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-3ae2b7e1e17so445428a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:10:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793794239; x=1794399039;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+cf3Ln9MMScgvm+FsTh0nTph/tgABNJ19lQjeccgv5U=;
        b=agMr1Vm3y25rrh9Kup0JmfeKxx5axHytGr6etKQVNPidkj0w6odtHayA0MgKm6LkrX
         X0rr6Mfw6vSptu70wuCRlbi+6EFO/GEGd45yG5Hhl2dY6OLfuwNrVNvpAMxvwqm2kTk6
         aMBFHmSgb2mG2O4n6T4fCvLX6gVAKhUl+Rwi7VGxbylB6BJkla4asYgcG9n6MejV2Q2K
         6fWmHDj1zgkmZ+YLy99oPSyuv7VTCwHlERizcSxTT4C6vJucp0UpEOZaSJMSc/1hx6y7
         9p2QiPHG1OveahG7voP8HTimpA8FmztmNax1x0YNloG84Uc2fIDmCwleR/9Zo6yAd8ex
         RPiw==
X-Gm-Message-State: APuU4Z+J7s3G7neVwhmJOdopqUEyT/dqM5JDc86t/hXTkxu0MMMBk0+1
	k/mFJe41tnhlQvJzKNU8FsEXUem1ZhX/cGkcTgIQic0mjM2vJXdGwaQMAULdTA7BeMSdWgswv3j
	3gOEVZtsL9K1rl3MOE2sH6GiwMzaL+zT6rtcNmhVw/lAMshCmGhEoa47brnYbCZumy8F0wSpj6I
	xP3HKIpX83WgVs8ENqNffGjkppJzT8puWlsuul+LpXVJ5I/xsFsaAbqsLgOo+kEBe6gcTspApTa
	YfsKOIDdekWC4s8
X-Gm-Gg: AYBFou0N731d0O1kwHGtbZrvd/0ym2fC62g2ZFVzPg+AO9qDRRmds7COF+IuBndXZcb
	mZLB8ruAf8QOm3ILONBdLKGEBMYijMVf7o8QQTJAz+Uw6YO0FXTyyzjslV0mWgqBNXZdZOgvgbB
	iqGV8FXJ7ylBr3RSot2AT+mJOEwksuWcVe4nka2bn8LEy1uGatkmlIRDxrCAj6tLkWJQyAqwIs1
	vgUGN2LC8DUgZHAiwQU63Tb9vQzBqCrjXGpRicnvjyP792Kh9xO1xzKIphVOtv9eVTwJFc2+MuR
	0mkU+wXdnlAopkr0nOucm7W4JRHHpkytTJSAw2uoLPILCYEhCWI+/hWqHF6ig5oddpCBYr6PM0w
	wf5sklWyEksgGCLyfyFxUzl77VyaijWsHenx6jqRtb19x+0cSRBia4tO7cr7ZEtlwxPbnQvf8WQ
	SIz5MZQJy00t07owUrVc1t
X-Received: by 2002:a17:90b:268d:b0:3a5:147a:3b63 with SMTP id 98e67ed59e1d1-3ae895a5bdemr12614252a91.8.1793794238140;
        Wed, 04 Nov 2026 04:10:38 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b07cab84edsm3838918a91.7.2026.11.04.04.10.37
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2026 04:10:38 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-33c35f5ca6cso1254364eec.1
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:10:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793794236; x=1794399036; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+cf3Ln9MMScgvm+FsTh0nTph/tgABNJ19lQjeccgv5U=;
        b=Q3xotSBOE8K9I8bscH9b9QzSQagmpIsjqIG0fbp3go71K/IfR/3WmLBxutzWVdZi6A
         /4z8Xe3QJbNAGIRTKYSTHnkwfzcMhQg9Vb95VYV5XYDmqsz/MwSb4Jd4fuQTwt2l0zs9
         pvImTV4aj55WfAogFqhTq+bJ4LmIlfoMgFglI=
X-Received: by 2002:a05:7022:158c:b0:1b2:44b3:8ed2 with SMTP id a92af1059eb24-1b244b38efcmr5003209c88.42.1793794236019;
        Wed, 04 Nov 2026 04:10:36 -0800 (PST)
X-Received: by 2002:a05:7022:158c:b0:1b2:44b3:8ed2 with SMTP id a92af1059eb24-1b244b38efcmr5003168c88.42.1793794235148;
        Wed, 04 Nov 2026 04:10:35 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c6f0dcsm9377095c88.21.2026.11.04.04.10.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 04:10:34 -0800 (PST)
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
Subject: [PATCH 14/21] scsi: mpi3mr: Fix target private data use after free in BSG passthrough
Date: Wed,  4 Nov 2026 17:30:55 +0530
Message-ID: <20261104120103.503871-15-ranjan.kumar@broadcom.com>
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

A BSG task management request raises block_io on the SCSI target private
data and lowers it after the command completes. The pointer is read
without a lock and the target device reference is dropped before the
wait. If the device is removed meanwhile, the private data is freed and
block_io is decremented in freed memory.

Do the lookup and the update under the target device lock, free the
private data under the same lock, and keep the target device reference
until the count is released.

Fixes: 506bc1a0d6ba ("scsi: mpi3mr: Add support for MPT commands")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260818231426.58105-1-chandrakanth.patil@broadcom.com?part=3
Closes: https://sashiko.dev/#/patchset/20260818231426.58105-1-chandrakanth.patil@broadcom.com?part=4
Closes: https://sashiko.dev/#/patchset/20260825210411.301535-1-chandrakanth.patil@broadcom.com?part=1
Closes: https://sashiko.dev/#/patchset/20260825210411.301535-1-chandrakanth.patil@broadcom.com?part=3
Closes: https://sashiko.dev/#/patchset/20260825210411.301535-1-chandrakanth.patil@broadcom.com?part=4
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h     |  5 +++
 drivers/scsi/mpi3mr/mpi3mr_app.c | 24 +++++++-------
 drivers/scsi/mpi3mr/mpi3mr_os.c  | 55 ++++++++++++++++++++++++++++++--
 3 files changed, 69 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index d6e16707fd97..da47100d895e 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -1533,6 +1533,11 @@ int mpi3mr_issue_tm(struct mpi3mr_ioc *mrioc, u8 tm_type,
 	u16 handle, uint lun, u16 htag, ulong timeout,
 	struct mpi3mr_drv_cmd *drv_cmd,
 	u8 *resp_code, struct scsi_cmnd *scmd);
+struct mpi3mr_stgt_priv_data *mpi3mr_tgtdev_block_io_inc(struct mpi3mr_ioc *mrioc,
+							 struct mpi3mr_tgt_dev *tgtdev);
+void mpi3mr_tgtdev_block_io_dec(struct mpi3mr_ioc *mrioc,
+				struct mpi3mr_tgt_dev *tgtdev,
+				struct mpi3mr_stgt_priv_data *stgt_priv);
 struct mpi3mr_tgt_dev *mpi3mr_get_tgtdev_by_handle(
 	struct mpi3mr_ioc *mrioc, u16 handle);
 void mpi3mr_pel_get_seqnum_complete(struct mpi3mr_ioc *mrioc,
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index db27bff58c27..4df0dc81358b 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2439,7 +2439,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 	struct mpi3_scsi_task_mgmt_request *tm_req;
 	u32 erbsz = MPI3MR_SENSE_BUF_SZ, tmplen;
 	u16 dev_handle;
-	struct mpi3mr_tgt_dev *tgtdev;
+	struct mpi3mr_tgt_dev *tgtdev = NULL;
 	struct mpi3mr_stgt_priv_data *stgt_priv = NULL;
 	struct mpi3mr_bsg_in_reply_buf *bsg_reply_buf = NULL;
 	u32 din_size = 0, dout_size = 0;
@@ -2791,14 +2791,8 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 	}
 	if (block_io) {
 		tgtdev = mpi3mr_get_tgtdev_by_handle(mrioc, dev_handle);
-		if (tgtdev) {
-			if (tgtdev->starget && tgtdev->starget->hostdata) {
-				stgt_priv = (struct mpi3mr_stgt_priv_data *)
-				    tgtdev->starget->hostdata;
-				atomic_inc(&stgt_priv->block_io);
-			}
-			mpi3mr_tgtdev_put(tgtdev);
-		}
+		if (tgtdev)
+			stgt_priv = mpi3mr_tgtdev_block_io_inc(mrioc, tgtdev);
 	}
 
 	mrioc->bsg_cmds.state = MPI3MR_CMD_PENDING;
@@ -2830,14 +2824,18 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 		dprint_bsg_err(mrioc,
 		    "%s: posting bsg request is failed\n", __func__);
 		rval = -EAGAIN;
-		if (block_io && stgt_priv)
-			atomic_dec(&stgt_priv->block_io);
+		if (tgtdev) {
+			mpi3mr_tgtdev_block_io_dec(mrioc, tgtdev, stgt_priv);
+			mpi3mr_tgtdev_put(tgtdev);
+		}
 		goto out_unlock;
 	}
 	wait_for_completion_timeout(&mrioc->bsg_cmds.done,
 	    (karg->timeout * HZ));
-	if (block_io && stgt_priv)
-		atomic_dec(&stgt_priv->block_io);
+	if (tgtdev) {
+		mpi3mr_tgtdev_block_io_dec(mrioc, tgtdev, stgt_priv);
+		mpi3mr_tgtdev_put(tgtdev);
+	}
 	if (!(mrioc->bsg_cmds.state & MPI3MR_CMD_COMPLETE)) {
 		timed_out = true;
 		mrioc->bsg_cmds.is_waiting = 0;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 99928fcc5bd7..e7833b24c509 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -788,6 +788,58 @@ struct mpi3mr_tgt_dev *mpi3mr_get_tgtdev_by_handle(
 	return tgtdev;
 }
 
+/**
+ * mpi3mr_tgtdev_block_io_inc - Block I/O on the SCSI target of a tgtdev
+ * @mrioc: Adapter instance reference
+ * @tgtdev: Target device reference, held by the caller
+ *
+ * Increment block_io of the SCSI target private data. The lookup and the
+ * increment are done under tgtdev_lock, which mpi3mr_target_destroy holds
+ * while it frees the private data.
+ *
+ * Return: The private data that was incremented, only to be handed back to
+ * mpi3mr_tgtdev_block_io_dec. NULL if the tgtdev has no SCSI target.
+ */
+struct mpi3mr_stgt_priv_data *mpi3mr_tgtdev_block_io_inc(struct mpi3mr_ioc *mrioc,
+							 struct mpi3mr_tgt_dev *tgtdev)
+{
+	struct mpi3mr_stgt_priv_data *stgt_priv = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
+	if (tgtdev->starget && tgtdev->starget->hostdata) {
+		stgt_priv = tgtdev->starget->hostdata;
+		atomic_inc(&stgt_priv->block_io);
+	}
+	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
+	return stgt_priv;
+}
+
+/**
+ * mpi3mr_tgtdev_block_io_dec - Undo mpi3mr_tgtdev_block_io_inc
+ * @mrioc: Adapter instance reference
+ * @tgtdev: Target device reference, held by the caller
+ * @stgt_priv: Value returned by mpi3mr_tgtdev_block_io_inc
+ *
+ * Decrement block_io only if the SCSI target still has the same private
+ * data. If the target was removed meanwhile the private data is gone
+ * and there is nothing to undo.
+ */
+void mpi3mr_tgtdev_block_io_dec(struct mpi3mr_ioc *mrioc,
+				struct mpi3mr_tgt_dev *tgtdev,
+				struct mpi3mr_stgt_priv_data *stgt_priv)
+{
+	unsigned long flags;
+
+	if (!stgt_priv)
+		return;
+
+	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
+	if (tgtdev->starget && tgtdev->starget->hostdata == stgt_priv)
+		atomic_dec_if_positive(&stgt_priv->block_io);
+	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
+}
+
 /**
  * __mpi3mr_get_tgtdev_by_perst_id -Get tgtdev from persist ID
  * @mrioc: Adapter instance reference
@@ -4953,10 +5005,9 @@ static void mpi3mr_target_destroy(struct scsi_target *starget)
 		mpi3mr_tgtdev_put(tgt_dev);
 		mpi3mr_tgtdev_put(tgt_dev);
 	}
-	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
-
 	kfree(starget->hostdata);
 	starget->hostdata = NULL;
+	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
 }
 
 /**
-- 
2.47.3

