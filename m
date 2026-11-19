Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.227
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795072798;
	b=Jhr/JMidExpaO+3yZuhB9dwmNqxgRH37Q+2TSUL+o7npBbh03LL9R0asSUBx7fNaQYvf
	 OKi7/U+ArLHRCSRR0bXperyCFwMCus7dnWPsPssWZVG1s22DuKGSIH5uj5hRFX734oMFW
	 IU5QrJLuEK19oK9o+Hw9KzEsKrcGUzDdRTnJvzmPyRY2sfVymKTkzj9TBNj1euTg1AF8H
	 7ecJS/4wbll58Ya0R6GHl3iaAHVW3RfJPSguJN3x/fYB8SPbQPeclR1ThBBCmOLVofYdp
	 Np39ziD3BmpKloX5THVtNteGLB0r4zh33uSZ732IKvJUm2kQ4l7qSYZBcIwDTXUbU7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795072798;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=PIPw/UZIa4FpXZJ4+Bo+4KGLQRPkzbh7uaZhWCFq9kI=;
	b=ZoD5cBCSQtzYRYAnndPDB1OQ2k4IcANBJHxni34EwaVdizJmpeIxht+X93yKM9qdyy2K
	 9qN1RvKSpYjRUEwZ0Vm3AAsL62b3ot2DIF2hDoEO2EVEZuL+qPra+OSCTeLaAvHmxiQ2c
	 HhDkxjRD5GPHAg2fqwaUTW/ezjzxPyge5BFzoi3nGwX1eE0x/2vQjOA7J4EDnpBBhUlzc
	 /poL/i4FToM1Y2tcH9GjZx2im3iEtIQir82gowDH08FRrbQpmj2VG7arqOBDb+oxDxTZd
	 DbGZitzHney2nfZHWHNpudRDH3EnfjedC7DB2AOOs1sQN1v+Df5B90QE/ZUcUu29yzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=SSrl2FYb;
	arc=none smtp.remote-ip=209.85.215.227
Received: from mail-pg1-f227.google.com (mail-pg1-f227.google.com [209.85.215.227])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C06606A32F
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 07:19:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 34C06606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=SSrl2FYb
Received: by mail-pg1-f227.google.com with SMTP id 41be03b00d2f7-cdb9f760337so333309a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:19:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795072797; x=1795677597;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PIPw/UZIa4FpXZJ4+Bo+4KGLQRPkzbh7uaZhWCFq9kI=;
        b=wxS5uf6DPaNNpSo/rW/JBv6VlgOmkVCSWstlDLLr0Dxbwe213DzGjjC77WuHjK+OQk
         j+03TgJjJrai1vqE3NNP8M4Je+BZsKJGz+SE6POh5SspVHyGqQr4o4C2Yk6dh3K/bvtU
         XxDz4LrEQJAyjUJ8BkaZsPWf4a79gjZzrCTkNSaFf7ktqMzoEykmLu5Lx6qmjZjJjuMa
         WiAkYHni55AtqG0FLvzxgnfcsqPxz44p4eT5P5qm3F3ERT4HjoP/NoOFlUi0w5a76OG7
         vmVpCQ2Dwdf9lu5urt2FFagMUwx2aJaCzYOqYNzKL6Qi6DAL1L6SCNQ2N5xOmf7edtWd
         OYjQ==
X-Gm-Message-State: APuU4Z8P95pOqCuyFhzk0bEKiqVj5VeHoFdOLgAEo7gP5bojyQMPjayT
	PpUcGjWi+oMH7Lf+vb7IAJsVjJSnz7KMzvBh13GhT+FKhvPgp6HTAJBKmjekLwvt1cePWByQBPO
	ta+8/9/zITRyin3hmwwSGvi0ZpLAgsejvuUxipFi6wWGbEbkKObnsPDuky0j0ieStucpkMd188u
	95/GqH7dR7lL3zUgxpBjnd+R9424dwHfLW7i3Ib2SQUQHD4oUbjaEj96GFC5r8ruQWxNqSLalrv
	/F98D+Lu2hKKHvc
X-Gm-Gg: AZFdTZepHn2mGaNuTVnegvDdoPgchrbm6GT4WzUdXlYGpH6Mal1b2QOW6MfSCzhccHq
	YBCV76lvibMyKhENLFOh4D90LBigZb5ByqkZbDExJMbD4v1c6q1+/Y69glGcf6yL8JA/iBuHnjG
	1yyD2iH8rBBZmplXhQwsgogC1WtvO+8+c+bqbO2kao8SiWvfv6ADRIVQ4r+MmjRfdExd/FrcJbz
	EXgnrCxWTGNXzcice2+szMFqnmEO2MnRxb84Bc7nEcEV0xlUjPx5wbvGlQsxoiiSxi3zi8GkWir
	bkwpl6PkmKwcMe40X+OyxXLVesK9kRELklfKCVfGXmVarRvASCZeYMoTNdVf5VQZynKFSa8c0fR
	hWEIIbSBpcNPDwJQhNwWZNij/pbQ50ZB2ed4EHxOCZck09923YlGmvQCGkL+d63pxMHD0BeiePX
	EYtc8ohnCPVxxHVBsXSCB1i0pOi/Cvb0d9rZY=
X-Received: by 2002:a17:90b:5848:b0:3b0:a4d1:6d75 with SMTP id 98e67ed59e1d1-3b40a647c0dmr212365a91.55.1795072797081;
        Wed, 18 Nov 2026 23:19:57 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b405960b36sm533465a91.1.2026.11.18.23.19.56
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 23:19:57 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ee2d612733so5256165ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1795072795; x=1795677595; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PIPw/UZIa4FpXZJ4+Bo+4KGLQRPkzbh7uaZhWCFq9kI=;
        b=SSrl2FYblcU8X4YlJ7YS6q0EEVarhIQWzS8gWeZ1+Eqis8CYVuV0gAM/ugTpGFA9Q9
         EtFzGaD9dHH+BKiZT3MFng1uWqIkrFkMYTCaTaVvEE7KtyXvGlQWdgEMxANoZ1Pn+puB
         OM3zCAOXSpE0NUcaH9WlLLIt5v4QLi0caH3Ts=
X-Received: by 2002:a17:90b:39a8:b0:3b3:b562:899c with SMTP id 98e67ed59e1d1-3b409d9ba20mr229151a91.9.1795072794795;
        Wed, 18 Nov 2026 23:19:54 -0800 (PST)
X-Received: by 2002:a17:90b:39a8:b0:3b3:b562:899c with SMTP id 98e67ed59e1d1-3b409d9ba20mr229137a91.9.1795072794229;
        Wed, 18 Nov 2026 23:19:54 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b402981814sm748560a91.2.2026.11.18.23.19.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 23:19:53 -0800 (PST)
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
Subject: [PATCH v2 14/20] scsi: mpi3mr: Fix target private data use after free in BSG passthrough
Date: Thu, 19 Nov 2026 12:41:26 +0530
Message-ID: <20261119071133.127282-15-ranjan.kumar@broadcom.com>
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

A BSG task management request raises block_io on the SCSI target private
data and lowers it after the command completes. The pointer is read
without a lock and the target device reference is dropped before the
wait. If the device is removed meanwhile, the private data is freed and
block_io is decremented in freed memory.

Update the count under the target device lock and keep the target device
reference until the count is released. Lower the count only if the target
still has the private data it was raised on.

Fixes: 506bc1a0d6ba ("scsi: mpi3mr: Add support for MPT commands")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260818231426.58105-1-chandrakanth.patil@broadcom.com?part=3
Closes: https://sashiko.dev/#/patchset/20260818231426.58105-1-chandrakanth.patil@broadcom.com?part=4
Closes: https://sashiko.dev/#/patchset/20260825210411.301535-1-chandrakanth.patil@broadcom.com?part=1
Closes: https://sashiko.dev/#/patchset/20260825210411.301535-1-chandrakanth.patil@broadcom.com?part=3
Closes: https://sashiko.dev/#/patchset/20260825210411.301535-1-chandrakanth.patil@broadcom.com?part=4
Closes: https://sashiko.dev/#/patchset/20261104120103.503871-1-ranjan.kumar@broadcom.com?part=14
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h     |  7 ++++
 drivers/scsi/mpi3mr/mpi3mr_app.c | 24 +++++++-------
 drivers/scsi/mpi3mr/mpi3mr_os.c  | 55 ++++++++++++++++++++++++++++++++
 3 files changed, 73 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index d6e16707fd97..1960ca6b79e9 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -741,6 +741,7 @@ enum mpi3mr_dev_state {
  *
  * @list: List pointer
  * @starget: Scsi_target pointer
+ * @stgt_priv: Private data of the scsi_target
  * @dev_handle: FW device handle
  * @parent_handle: FW parent device handle
  * @slot: Slot number
@@ -766,6 +767,7 @@ enum mpi3mr_dev_state {
 struct mpi3mr_tgt_dev {
 	struct list_head list;
 	struct scsi_target *starget;
+	struct mpi3mr_stgt_priv_data *stgt_priv;
 	u16 dev_handle;
 	u16 parent_handle;
 	u16 slot;
@@ -1533,6 +1535,11 @@ int mpi3mr_issue_tm(struct mpi3mr_ioc *mrioc, u8 tm_type,
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
index 99928fcc5bd7..4b98ee9e5e03 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -788,6 +788,57 @@ struct mpi3mr_tgt_dev *mpi3mr_get_tgtdev_by_handle(
 	return tgtdev;
 }
 
+/**
+ * mpi3mr_tgtdev_block_io_inc - Block I/O on the SCSI target of a tgtdev
+ * @mrioc: Adapter instance reference
+ * @tgtdev: Target device reference, held by the caller
+ *
+ * Increment block_io of the SCSI target private data of the tgtdev. The
+ * private data is looked up and incremented under tgtdev_lock, which is
+ * also held when the target is destroyed.
+ *
+ * Return: The private data that was incremented, to be handed back when
+ * block_io is decremented. NULL if the tgtdev has no private data.
+ */
+struct mpi3mr_stgt_priv_data *mpi3mr_tgtdev_block_io_inc(struct mpi3mr_ioc *mrioc,
+							 struct mpi3mr_tgt_dev *tgtdev)
+{
+	struct mpi3mr_stgt_priv_data *stgt_priv = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
+	stgt_priv = tgtdev->stgt_priv;
+	if (stgt_priv)
+		atomic_inc(&stgt_priv->block_io);
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
+ * Decrement block_io only if the tgtdev still has the same private data.
+ * If the target was removed meanwhile the private data is gone and there
+ * is nothing to undo.
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
+	if (tgtdev->stgt_priv == stgt_priv)
+		atomic_dec_if_positive(&stgt_priv->block_io);
+	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
+}
+
 /**
  * __mpi3mr_get_tgtdev_by_perst_id -Get tgtdev from persist ID
  * @mrioc: Adapter instance reference
@@ -4948,6 +4999,8 @@ static void mpi3mr_target_destroy(struct scsi_target *starget)
 	    (tgt_dev->perst_id == starget->id))
 		tgt_dev->starget = NULL;
 	if (tgt_dev) {
+		if (tgt_dev->stgt_priv == scsi_tgt_priv_data)
+			tgt_dev->stgt_priv = NULL;
 		scsi_tgt_priv_data->tgt_dev = NULL;
 		scsi_tgt_priv_data->perst_id = 0;
 		mpi3mr_tgtdev_put(tgt_dev);
@@ -5100,6 +5153,7 @@ static int mpi3mr_target_alloc(struct scsi_target *starget)
 			scsi_tgt_priv_data->dev_type = tgt_dev->dev_type;
 			scsi_tgt_priv_data->tgt_dev = tgt_dev;
 			tgt_dev->starget = starget;
+			tgt_dev->stgt_priv = scsi_tgt_priv_data;
 			atomic_set(&scsi_tgt_priv_data->block_io, 0);
 			retval = 0;
 			if ((tgt_dev->dev_type == MPI3_DEVICE_DEVFORM_PCIE) &&
@@ -5133,6 +5187,7 @@ static int mpi3mr_target_alloc(struct scsi_target *starget)
 			scsi_tgt_priv_data->io_throttle_enabled = tgt_dev->io_throttle_enabled;
 			scsi_tgt_priv_data->wslen = tgt_dev->wslen;
 			tgt_dev->starget = starget;
+			tgt_dev->stgt_priv = scsi_tgt_priv_data;
 			atomic_set(&scsi_tgt_priv_data->block_io, 0);
 			retval = 0;
 		} else {
-- 
2.47.3

