Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795072801;
	b=2fPi2UPWy5sfvO3VVTc9L6BLX5ke4uFzPlYzfjcLdEgPeh/xlJ3gZLK2e6CXHsNmqt4M
	 qG8MN6WdbmuK2Shl77/c8uTPsimole1qyYr3wbx4VeyU3mwf5Q5Kwge7k4YpHIcBqyr0G
	 UodjATcwLeNpeTLDVVoxGd/SQvH+j2C+wV+03LdWk5Wh/P9s13KTaK8qI16GUQWxo+D7E
	 sPpL7wlQY8twstU3FhuRCOsSiEibnd/YDRQ6cZu7/V19NZ4abOvM/ol0dEMA+HoBUqLDy
	 RPQA/dMjvJ7hfmb2r8yC106bVTvtbAiG7ztvrmuWQkForkK/175vguKPsS1qsTL2+wQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795072801;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=bnqf+laxUCJ83sCHK8lKBBbCCoqfwlbICRVvGHY/EVc=;
	b=WFRFoTzzeQqpFAUXwun2amxee9Qxl7E3T4bmq/lJQW0qLM8f/tR/j5zL9kB72Xa3Vvdk
	 T9cmHDL5bcyN9Yd11k/+ZuM8uEpvPjkLGslPNdySfJPatR3c7ec2AbGDgJ/KVZil07YLd
	 7TNTogcVuFiC3AX8GAdqHn407os4VVHznkt4RirRb7RxxDHNyRQPedZUn08ivoQYd8Yl+
	 wBRD6jvS+nBnRTepFUwTNpejMC86ri9TH1TB3Ncpu16lF4nNmFeSEO697TUHFlVqg5Ca1
	 hb1mKEeRodyZe+r3+6qlpVsKyYnCYGyjGTENVklyPHv/Lg2FTpA+s6VKLNJ4GgeVgAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=EprfAwoB;
	arc=none smtp.remote-ip=209.85.215.226
Received: from mail-pg1-f226.google.com (mail-pg1-f226.google.com [209.85.215.226])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB2D606A320
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 07:20:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4AB2D606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=EprfAwoB
Received: by mail-pg1-f226.google.com with SMTP id 41be03b00d2f7-cdadf7e248aso960904a12.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:20:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795072801; x=1795677601;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bnqf+laxUCJ83sCHK8lKBBbCCoqfwlbICRVvGHY/EVc=;
        b=Uo4tk0QvGhNPGciehaCVbfKiHYuVOW1Z322krGYio6KZAZ4xqyFXli6qTVW25EC6ih
         ZW/BiR22MhtUg2WCRSOfTvslci2vGpWBY8sBZF1XJib2HbB7SqxrYY/8cDiYjW7mwSHH
         9g83Q3AcuebE8KBvdD597BNepfw1kmyWukBQ0dk3jJWb0RZOfRIYf7gvcuXFEuf5PDF8
         VfevQQ9cn2fFQypfpbRNCKigixkiR6DGIQsDGbDuX9VmWA84OupBzi1jjTLzXkLUIk+o
         0agsWiB7+RwleCYyiAv6vJzXII6dSE4TSpAfEVuNjhVMlMK7iFnjKGr3dDNV/NTbwBw3
         +KBg==
X-Gm-Message-State: APuU4Z+xBJn1/0EDpYpx0VWVhLf38TUnzDFuda6F3ljNm38Oc3c4hTOI
	R+H4Wel7ZRT3RYlGpflZpw5uRg09kgm0VgIlRMTePNvkWF7ON0YKNfP6BHgS+N66bQdWycY/PrP
	ws4RKflswyoi1Q2RA0XkXfklgakbjrK2xsuZeVZNdbjE3cLu2TFdZFH7b2M6wNyZPxz1/p0wkRu
	kzQg8JpNDgRUShvqBSrQQuSicdkrCfESKAZqgiBhpywqD6soNczmgDmANfwcfmpClshwPm/fo8K
	8n2Bl2N4ZM4jqHg
X-Gm-Gg: AZFdTZcNEZ0hbndPU9xuy8lWf6Nnz32Rl+cxnM8BXtXuixM7AFIZXqLxEyPqS6B3Wvh
	h/h8+XG6nR5MavBjt75P1yMeyM+PHE/ItyNmbupJhqImOdxXsPsr+EM9zMyXmpoW6sgyJ+UavLp
	pMnZpdYFmfn8qvslSDce2AYi1m+9COjcduVRMrUnqfA8A4Y62VZ1uf/e/0Q90VWzR6BAAkqjIKq
	VN0iFJNrkUKd4wWEahHm+BwfmFebQ7a0RMaYqwwwNnnv2xfJnPujTaSlRh6Wc5ffTVlsId0uLAE
	iEwpgE8MYYASdjIxlxv5oB2eZrI2pPVmdYfVyQ+BeUVcQAliL6e0F2yDp7NZkgq6Ut28PG52WeL
	V2q7O2kPOlfDgKTTmP4mWaI1NmHaBi4rZeFsQeFgzIEY1v9Ffxcpbf2iDFmyLKHm4mWy/fPhByh
	JncH3tWZfrYcjBIFYG1RTpDwGgKY8lw9gmTQU=
X-Received: by 2002:a17:90b:4a05:b0:3b0:a511:fb75 with SMTP id 98e67ed59e1d1-3b3d07a467dmr5318785a91.40.1795072800389;
        Wed, 18 Nov 2026 23:20:00 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b4062a77f5sm461377a91.6.2026.11.18.23.19.59
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 23:20:00 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3b08364cdc7so1731676a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:19:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1795072799; x=1795677599; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bnqf+laxUCJ83sCHK8lKBBbCCoqfwlbICRVvGHY/EVc=;
        b=EprfAwoB224Fi7ML9ypyUdikK2KGjiHNjcR3B6/uWU10vPGBo7n0HkU3r3sMDHGNbI
         QszdWrJYpdhPfoc+R1XVV/9h9KHNrKYU6ge3Z8Fuc1Sem21S8VmXI41IQN/LY8iIFpJU
         /kTos4dW2DgdxWqwcjii2WkDRe6eYbJBl2fmo=
X-Received: by 2002:a17:90a:e18c:b0:3b3:cab4:5060 with SMTP id 98e67ed59e1d1-3b3d074d77dmr4948602a91.17.1795072798642;
        Wed, 18 Nov 2026 23:19:58 -0800 (PST)
X-Received: by 2002:a17:90a:e18c:b0:3b3:cab4:5060 with SMTP id 98e67ed59e1d1-3b3d074d77dmr4948579a91.17.1795072797895;
        Wed, 18 Nov 2026 23:19:57 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b402981814sm748560a91.2.2026.11.18.23.19.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 23:19:57 -0800 (PST)
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
Subject: [PATCH v2 15/20] scsi: mpi3mr: Fix block_io accounting when a target is re-created during BSG
Date: Thu, 19 Nov 2026 12:41:27 +0530
Message-ID: <20261119071133.127282-16-ranjan.kumar@broadcom.com>
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
data when it starts and lowers it when it completes. If the target is
removed and created again while the command waits, the new private data
can be allocated at the address of the old one. The address check then
passes and the command lowers block_io of the new target, which may be
held by another path.

Give each private data a sequence number and lower block_io only when the
number is the same as when the command started.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20261104120103.503871-1-ranjan.kumar@broadcom.com?part=15
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h     |  9 ++++----
 drivers/scsi/mpi3mr/mpi3mr_app.c |  8 +++----
 drivers/scsi/mpi3mr/mpi3mr_os.c  | 39 ++++++++++++++++++++------------
 3 files changed, 33 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 1960ca6b79e9..c516c00a1dd1 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -831,6 +831,7 @@ static inline void mpi3mr_tgtdev_put(struct mpi3mr_tgt_dev *s)
  * @perst_id: FW assigned Persistent ID
  * @num_luns: Number of Logical Units
  * @block_io: I/O blocked to the device or not
+ * @seq: Sequence number, unique for every allocated private data
  * @dev_removed: Device removed in the Firmware
  * @dev_removedelay: Device is waiting to be removed in FW
  * @dev_type: Device type
@@ -849,6 +850,7 @@ struct mpi3mr_stgt_priv_data {
 	u16 perst_id;
 	u32 num_luns;
 	atomic_t block_io;
+	u64 seq;
 	u8 dev_removed;
 	u8 dev_removedelay;
 	u8 dev_type;
@@ -1535,11 +1537,10 @@ int mpi3mr_issue_tm(struct mpi3mr_ioc *mrioc, u8 tm_type,
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
index 4b98ee9e5e03..7a8bd20844e6 100644
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
@@ -797,44 +799,49 @@ struct mpi3mr_tgt_dev *mpi3mr_get_tgtdev_by_handle(
  * private data is looked up and incremented under tgtdev_lock, which is
  * also held when the target is destroyed.
  *
- * Return: The private data that was incremented, to be handed back when
- * block_io is decremented. NULL if the tgtdev has no private data.
+ * Return: Sequence number of the private data that was incremented, to be
+ * handed back when block_io is decremented. 0 if the tgtdev has no private
+ * data.
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
 	stgt_priv = tgtdev->stgt_priv;
-	if (stgt_priv)
+	if (stgt_priv) {
 		atomic_inc(&stgt_priv->block_io);
+		seq = stgt_priv->seq;
+	}
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
- * Decrement block_io only if the tgtdev still has the same private data.
- * If the target was removed meanwhile the private data is gone and there
- * is nothing to undo.
+ * Decrement block_io only if the tgtdev still has the private data that was
+ * incremented. A private data allocated later at the same address has a
+ * different sequence number and is left alone.
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
-	if (tgtdev->stgt_priv == stgt_priv)
+	stgt_priv = tgtdev->stgt_priv;
+	if (stgt_priv && stgt_priv->seq == seq)
 		atomic_dec_if_positive(&stgt_priv->block_io);
 	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
 }
@@ -5141,6 +5148,8 @@ static int mpi3mr_target_alloc(struct scsi_target *starget)
 	if (!scsi_tgt_priv_data)
 		return -ENOMEM;
 
+	scsi_tgt_priv_data->seq = atomic64_inc_return(&mpi3mr_stgt_seq);
+
 	starget->hostdata = scsi_tgt_priv_data;
 
 	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
-- 
2.47.3

