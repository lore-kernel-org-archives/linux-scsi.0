Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.228
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793794243;
	b=Dx8z7QoUfxyYwLm+tx5pT0rymYHcpeMlc9x1ai7Cmx0lSidWML4szEpU/89JgR7tsx9R
	 fQmWal4CgLlp/CPbwkly7sgbRir4xFdsuqLSk7+2yZJaIHjV24vNi9FROeU6zonXTiXB+
	 SLw8Wx/8l56OamjlkjJygr/hjWINO0zIgMY4D1RLg45IKBYZ4V/XctZKA/pIYumw9K969
	 53fcw4VbvQnqmocTdce3FoO7KI1FYFS4dNPJr3kFX4x22geZi1p3Z4IRJVqqFmKh94jVi
	 MxMoUMxZkGlmKrLMbgOjTAb54j5ERZzBKSCExyex/i44ubfau9uBROUFQRZg6cWCuWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793794243;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=RDury+7GiWzt8Zq2G+kgcuFcl4bta8M3e+gPVadbOn4=;
	b=AUWwmnjs26FNGe1jSA2vIPfOsr1LJzChROCBLvhSpzulFQ5V9ciKdEgiP9+RJa51eY7P
	 tlwr/lH2LyDvmnsdKS8HqQcnap35lHjrNBXS/vXW4bRKcfivdgsZS5ZrE6QdoBGJAN78x
	 lXqZW1suzKKWw4/7OCmE0YEKAw0X2kI6gFK65mZ2khr4Ob/7l1raTE+rSOR/UqaAsPJwi
	 B4GvIQ3Hi8qsr5p0LWrbpV3Ni0SzrQmz2RTMG7WZbiDFDJMwbj6Tns/yy/Lqze5/j04RG
	 AQBa49fgc3EpASdgGyaBvO2qPBXEvFdm0wrELO2mZP8MvVYz/sI5LPNxxKE5a/M3uUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=TBlabHXC;
	arc=none smtp.remote-ip=209.85.214.228
Received: from mail-pl1-f228.google.com (mail-pl1-f228.google.com [209.85.214.228])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFA5606A330
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 12:10:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CCFA5606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=TBlabHXC
Received: by mail-pl1-f228.google.com with SMTP id d9443c01a7336-2e7e742a2c7so3661215ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:10:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793794242; x=1794399042;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RDury+7GiWzt8Zq2G+kgcuFcl4bta8M3e+gPVadbOn4=;
        b=0qkCvbToSUvqQZoRVkVaesxRDiIeOkm98rD0u8CXZVwXUVwUQ8jrNrweJiceYtRAe7
         2gYc8bcx/2LbgPGvANsGQDyrpfcugZHKqYmY9jVSn3tD9bbKDp3B3d9xvsH7mCJuxsqN
         CuSwTairMsI39HHTtm/nYAPrx9jzU3xfBLYPSW7nFNV/llUfg3BSHkXJ7n64HiWmZ7G4
         hV5vVOdoIio1XAuWX/u2Had6F+nm0saFuLBYi5INKhfAaUi30+e/otjsaxBvRnI0BQIK
         OAdXuoHyxrn+6s9xDrgagNTbikc7h2LODuVpqGNHIy+FlAKVLNISUb2bC0sLTCm8KBuN
         h/6A==
X-Gm-Message-State: APuU4Z9ZM+RAGFx/J6frtzlQP1aowYmJY0SKp9S1At/jlLbIJdY1fIJB
	qBEOSfinTt16MPx4pceAhOKsIkmctpnUFRQ7xYa+KH+NbibmBxgdMaOIIpJytvt0aOjJJ9rqzxP
	7KYNqI1WIhWiGylh2r+OBC8YOBJPHoFJEm6AQbaiWNaSbF8BYsZhqrGbXRxdEBQby9UzNI1pe3Y
	z+r257zxZ9QHF91ZS8ZBQIfLfS5JQiJdtFJOxdEivCrz5v057DD4D+en26mDzYfQuQzcso0jqc9
	7GukeyprHYJsnul
X-Gm-Gg: AYBFou3te5O0IQuhnA6p6h2qnOlDUrOSHZDANgjzbKcJECFMc2ifl7beLxKZy7s8ruR
	q7c1axw+DKMR6j1GJWAT95kUAkhyLGRZb3DBHqMQ3g2CldNXJVuBaCw9ZghCIaKwhtEA9UgC8IA
	yXq+1/rTgtJF4chEgJSnwIbSajHYurBXfSUzA3KdehJKntBz9F873DqrrsP5DCTK2M6NyOSlx5u
	EGAFZTRvku6kThhfdaz+I/F4pR0gwXTAxIn00Ce60YAiz6Y8DCQyvH/AtyNk1Zlu6YomjxxAO7U
	oM5Wq401vjNdfnsSZ9GBsQs3OaN6llCzEEdKupO4EwKgL3XnDqEY9pu+Sf5+DP0Ot/e9hs/8fYs
	1/uXKzgUrib0s8EcCjRM1JtW+KYP/OQFTYYw9CPVguNed2YnJ3z4ufCl1vkUTYNlJfTlWuXcFf+
	FinyEHzWhinwPD/pVgJZ1hDtQK8as4ZezfSpQ=
X-Received: by 2002:a17:902:cccd:b0:2df:98a1:d0a7 with SMTP id d9443c01a7336-2eb1ac94b78mr128989525ad.33.1793794242004;
        Wed, 04 Nov 2026 04:10:42 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2ed0885a109sm276685ad.0.2026.11.04.04.10.41
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2026 04:10:41 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-3425098ae4bso2548934eec.0
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:10:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793794240; x=1794399040; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RDury+7GiWzt8Zq2G+kgcuFcl4bta8M3e+gPVadbOn4=;
        b=TBlabHXCAbRGJLue9hDoophX1pzq+2hxUjwnqX5YqlToLMjzVeiaaHX9itYc4utqeT
         d4QKTaUM8s03hNcOI2DS5F7ZN982emJtOVLUbPsoSBpICWEdC72+4lagHRBacUspj666
         ikgJcAppNVXwaq7qEZ4T+qOM3HW7H8TFjG3y0=
X-Received: by 2002:a05:701b:4188:20b0:14e:37c7:2b20 with SMTP id a92af1059eb24-1ac5bda85f2mr23193534c88.20.1793794239980;
        Wed, 04 Nov 2026 04:10:39 -0800 (PST)
X-Received: by 2002:a05:701b:4188:20b0:14e:37c7:2b20 with SMTP id a92af1059eb24-1ac5bda85f2mr23193491c88.20.1793794238889;
        Wed, 04 Nov 2026 04:10:38 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c6f0dcsm9377095c88.21.2026.11.04.04.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 04:10:38 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH 15/21] scsi: mpi3mr: Fix block_io accounting when a target is re-created during BSG
Date: Wed,  4 Nov 2026 17:30:56 +0530
Message-ID: <20261104120103.503871-16-ranjan.kumar@broadcom.com>
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
data when it starts and lowers it when it completes. If the target is
removed and created again while the command waits, the new private data
can be allocated at the address of the old one. The address check then
passes and the command lowers block_io of the new target, which may be
held by another path.

Give each private data a sequence number and lower block_io only when the
number is the same as when the command started.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h     |  8 +++----
 drivers/scsi/mpi3mr/mpi3mr_app.c |  8 +++----
 drivers/scsi/mpi3mr/mpi3mr_os.c  | 40 ++++++++++++++++++++------------
 3 files changed, 33 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index da47100d895e..8738fc2ce7e7 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -847,6 +847,7 @@ struct mpi3mr_stgt_priv_data {
 	u16 perst_id;
 	u32 num_luns;
 	atomic_t block_io;
+	u64 seq;
 	u8 dev_removed;
 	u8 dev_removedelay;
 	u8 dev_type;
@@ -1533,11 +1534,10 @@ int mpi3mr_issue_tm(struct mpi3mr_ioc *mrioc, u8 tm_type,
 	u16 handle, uint lun, u16 htag, ulong timeout,
 	struct mpi3mr_drv_cmd *drv_cmd,
 	u8 *resp_code, struct scsi_cmnd *scmd);
-struct mpi3mr_stgt_priv_data *mpi3mr_tgtdev_block_io_inc(struct mpi3mr_ioc *mrioc,
-							 struct mpi3mr_tgt_dev *tgtdev);
+u64 mpi3mr_tgtdev_block_io_inc(struct mpi3mr_ioc *mrioc,
+			       struct mpi3mr_tgt_dev *tgtdev);
 void mpi3mr_tgtdev_block_io_dec(struct mpi3mr_ioc *mrioc,
-				struct mpi3mr_tgt_dev *tgtdev,
-				struct mpi3mr_stgt_priv_data *stgt_priv);
+				struct mpi3mr_tgt_dev *tgtdev, u64 seq);
 struct mpi3mr_tgt_dev *mpi3mr_get_tgtdev_by_handle(
 	struct mpi3mr_ioc *mrioc, u16 handle);
 void mpi3mr_pel_get_seqnum_complete(struct mpi3mr_ioc *mrioc,
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 4df0dc81358b..30a01b02a9fc 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2440,7 +2440,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 	u32 erbsz = MPI3MR_SENSE_BUF_SZ, tmplen;
 	u16 dev_handle;
 	struct mpi3mr_tgt_dev *tgtdev = NULL;
-	struct mpi3mr_stgt_priv_data *stgt_priv = NULL;
+	u64 block_seq = 0;
 	struct mpi3mr_bsg_in_reply_buf *bsg_reply_buf = NULL;
 	u32 din_size = 0, dout_size = 0;
 	u8 *din_buf = NULL, *dout_buf = NULL;
@@ -2792,7 +2792,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 	if (block_io) {
 		tgtdev = mpi3mr_get_tgtdev_by_handle(mrioc, dev_handle);
 		if (tgtdev)
-			stgt_priv = mpi3mr_tgtdev_block_io_inc(mrioc, tgtdev);
+			block_seq = mpi3mr_tgtdev_block_io_inc(mrioc, tgtdev);
 	}
 
 	mrioc->bsg_cmds.state = MPI3MR_CMD_PENDING;
@@ -2825,7 +2825,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 		    "%s: posting bsg request is failed\n", __func__);
 		rval = -EAGAIN;
 		if (tgtdev) {
-			mpi3mr_tgtdev_block_io_dec(mrioc, tgtdev, stgt_priv);
+			mpi3mr_tgtdev_block_io_dec(mrioc, tgtdev, block_seq);
 			mpi3mr_tgtdev_put(tgtdev);
 		}
 		goto out_unlock;
@@ -2833,7 +2833,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 	wait_for_completion_timeout(&mrioc->bsg_cmds.done,
 	    (karg->timeout * HZ));
 	if (tgtdev) {
-		mpi3mr_tgtdev_block_io_dec(mrioc, tgtdev, stgt_priv);
+		mpi3mr_tgtdev_block_io_dec(mrioc, tgtdev, block_seq);
 		mpi3mr_tgtdev_put(tgtdev);
 	}
 	if (!(mrioc->bsg_cmds.state & MPI3MR_CMD_COMPLETE)) {
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index e7833b24c509..67d41e4a0a0a 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -788,6 +788,8 @@ struct mpi3mr_tgt_dev *mpi3mr_get_tgtdev_by_handle(
 	return tgtdev;
 }
 
+static atomic64_t mpi3mr_stgt_seq = ATOMIC64_INIT(0);
+
 /**
  * mpi3mr_tgtdev_block_io_inc - Block I/O on the SCSI target of a tgtdev
  * @mrioc: Adapter instance reference
@@ -797,46 +799,52 @@ struct mpi3mr_tgt_dev *mpi3mr_get_tgtdev_by_handle(
  * increment are done under tgtdev_lock, which mpi3mr_target_destroy holds
  * while it frees the private data.
  *
- * Return: The private data that was incremented, only to be handed back to
- * mpi3mr_tgtdev_block_io_dec. NULL if the tgtdev has no SCSI target.
+ * Return: Sequence number of the private data that was incremented, to be
+ * handed back to mpi3mr_tgtdev_block_io_dec. 0 if the tgtdev has no SCSI
+ * target.
  */
-struct mpi3mr_stgt_priv_data *mpi3mr_tgtdev_block_io_inc(struct mpi3mr_ioc *mrioc,
-							 struct mpi3mr_tgt_dev *tgtdev)
+u64 mpi3mr_tgtdev_block_io_inc(struct mpi3mr_ioc *mrioc,
+			       struct mpi3mr_tgt_dev *tgtdev)
 {
-	struct mpi3mr_stgt_priv_data *stgt_priv = NULL;
+	struct mpi3mr_stgt_priv_data *stgt_priv;
 	unsigned long flags;
+	u64 seq = 0;
 
 	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
 	if (tgtdev->starget && tgtdev->starget->hostdata) {
 		stgt_priv = tgtdev->starget->hostdata;
 		atomic_inc(&stgt_priv->block_io);
+		seq = stgt_priv->seq;
 	}
 	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
-	return stgt_priv;
+	return seq;
 }
 
 /**
  * mpi3mr_tgtdev_block_io_dec - Undo mpi3mr_tgtdev_block_io_inc
  * @mrioc: Adapter instance reference
  * @tgtdev: Target device reference, held by the caller
- * @stgt_priv: Value returned by mpi3mr_tgtdev_block_io_inc
+ * @seq: Value returned by mpi3mr_tgtdev_block_io_inc
  *
- * Decrement block_io only if the SCSI target still has the same private
- * data. If the target was removed meanwhile the private data is gone
- * and there is nothing to undo.
+ * Decrement block_io only if the SCSI target still has the private data
+ * that was incremented. A private data allocated later at the same address
+ * has a different sequence number and is left alone.
  */
 void mpi3mr_tgtdev_block_io_dec(struct mpi3mr_ioc *mrioc,
-				struct mpi3mr_tgt_dev *tgtdev,
-				struct mpi3mr_stgt_priv_data *stgt_priv)
+				struct mpi3mr_tgt_dev *tgtdev, u64 seq)
 {
+	struct mpi3mr_stgt_priv_data *stgt_priv;
 	unsigned long flags;
 
-	if (!stgt_priv)
+	if (!seq)
 		return;
 
 	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
-	if (tgtdev->starget && tgtdev->starget->hostdata == stgt_priv)
-		atomic_dec_if_positive(&stgt_priv->block_io);
+	if (tgtdev->starget && tgtdev->starget->hostdata) {
+		stgt_priv = tgtdev->starget->hostdata;
+		if (stgt_priv->seq == seq)
+			atomic_dec_if_positive(&stgt_priv->block_io);
+	}
 	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
 }
 
@@ -5139,6 +5147,8 @@ static int mpi3mr_target_alloc(struct scsi_target *starget)
 	if (!scsi_tgt_priv_data)
 		return -ENOMEM;
 
+	scsi_tgt_priv_data->seq = atomic64_inc_return(&mpi3mr_stgt_seq);
+
 	starget->hostdata = scsi_tgt_priv_data;
 
 	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
-- 
2.47.3

