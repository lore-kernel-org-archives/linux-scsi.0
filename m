Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795072809;
	b=jirec1+52rX6hb4cpXKXTChjqU/t0U2mrYkCjI8IKQAyGc21YqwlvrZLwSnLm+matn2p
	 xLg5H23AjsDMdMAVoTovoMsVgyC1BxX8KkciBli4p+sCa0cybZUgc404V6yMVTEDORlU3
	 2YO2pW/ebb53R9u9jdrJxOsmfRvmnPQ6vdwRR+UzNGic56NglFotClo/XX0nC0QGJjbOh
	 yB3nKnAzVsnKTxCMhm836V3wAslxjrBbxsR+kuHrc50QN7tQwCRnLDREuowtHT4e+sWXv
	 LY4pla4QRvOZVLSU18SlIl6q6KgjEb5suuZa0OKx5yRrKn3Lz/4Ld8UsGFzj4OTL3Dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795072809;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=YlnPJLfVNY64wBezogRYVTf8psdI0g7qGeW62d8i48E=;
	b=rnlNOy54xSjoN9Whe2/BDsxEiGMR4fpbeqRl+g5LUVB0hq5bSM3+JJXj7oSc3MvgTaRn
	 6aap3lsPIUThBoJDPSmfQL+buysCBtHUUOajvaO1w91agXZTdalEavcoF4qp/ITrRGYuX
	 AlXhPyGXPBRkS4YZ8EMa67QSLAI/G8YCMeSJ9Gr1iU3QqWN2YZxU/qr0LgcLNOm/EX/NF
	 65TOGWpBIMXaRuouLjBmVXH1OOkIYyl5U6yNc/PBzJWUZ4GUySWcvoRRmyAvWwbUZ4Wc+
	 A8uiIsoW6PADGm50pE7rGl4uMpG8yTEj1DmNrpSTnOZT9D15OSL6hSohPTgfY4ri5nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Qd9ZXdwS;
	arc=none smtp.remote-ip=209.85.210.226
Received: from mail-pf1-f226.google.com (mail-pf1-f226.google.com [209.85.210.226])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6BC606A320
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 07:20:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B6BC606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Qd9ZXdwS
Received: by mail-pf1-f226.google.com with SMTP id d2e1a72fcca58-8b5a6f2f27fso940023b3a.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:20:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795072808; x=1795677608;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YlnPJLfVNY64wBezogRYVTf8psdI0g7qGeW62d8i48E=;
        b=E9UclYLg93GfQ8V7mDirskLAz8RcYRNLduCtabSBFQ4gz0JwjkcbcKdFJJ9oawD1BI
         gKFIr06WWjhK6WxKPSwBBfHeBaty6M9vDIVlxlzGE+PNHB3xhZpl6m1iaJj0jUC7A+yU
         LVyeW+EpY8EQKIaYzl5F9H3bU06Be9XuAVUSXnvX2/gmQL9LkU2wcnLxPZZIbGjZkSq5
         2qQ4N4cUxk/B6dWlTjnv0sA2OSg+kbJIiXZLxtn7ikmUkb9YXBDz6rW+CjuoNDFbuUkM
         aXKSPQIDl2IM6FVkO4X55wx8j1UYwfhFpPuidZbE2OXCQ52sZ0jKSKng3WMPu4W4DMTG
         cJzg==
X-Gm-Message-State: APuU4Z/O31xtoE05VOfugpMxGdz98qQ6HkcoG3rdhIf1T4Z7zmLdVJaN
	v00YNJKhPJswJ09eymbKY+9/Mia8+wiCUekDm7AoFYnpYsRqC8eoT0F7AVTO4AQaKsLzAU49afw
	tYDyTfVRZbxm2awaCpXH8PF4bpXQb7GIXrzNaKPH0GCGe5KOBZovn0HrDmB0aBBlWpOHNRc7URm
	D2mWJs5+0ujeXLF+5uup42UfblVIKKcuGL3CkhVc5E670WUdTsUTmN4XRvPtFxXjTYCad5b5IQ1
	p7SCG+l6dI6Pk95
X-Gm-Gg: AYBFou1xWkf++LrWm5MqV42+YJlctr32JVsUv+9p3hSVkZq1NgPe9AhM9YyEWcP7JR3
	8PypYKDKujhJMv06uW/DJfGxBds0FPYJ0t+QF0hct+ecoYo4ZycmeGvHrC2uC9F+MQQTz4I4xZ+
	7PjyeCHreU6nK9z8Rpev+hw7VvGZHQ79B+wXPykKKe0Sr4ZagXPR3tZOqt2yaBFVqSI598RcUcw
	M+dFnbtY+6PooEQ59an1k3ddslcuMoCoc140mTS4d4AsvbgYLfGwR/YFt5SITewKNajhGTPNlo2
	rx+DOxn2GUzVdcqOhfc1N9GisUFWukR2anDPwu5ELsorWgmIbg7JsvwRBuwVRdAc4qS8xxiG+vi
	8/aiBq2+WcPa3y81hGZ7hVHaTNYFaMXJ0H18zy6VLJ2nwvcsg7mjxAIrVVKeP/TxpnQnB45PP/c
	pihH/qzGaDI88p/21HPTjNOZBVYYaI6G+4e/o=
X-Received: by 2002:a05:6a20:1a28:b0:400:78ff:badc with SMTP id adf61e73a8af0-40078ffbb4cmr573312637.47.1795072807916;
        Wed, 18 Nov 2026 23:20:07 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 41be03b00d2f7-cde534abbd4sm28371a12.21.2026.11.18.23.20.07
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 23:20:07 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3acc98e3b3cso1480878a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:20:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1795072806; x=1795677606; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YlnPJLfVNY64wBezogRYVTf8psdI0g7qGeW62d8i48E=;
        b=Qd9ZXdwSMetoFOOKnU47JhDFRPqplNVpDciLSj1U9QbsS+jgYN3SOfBb6oSVX3ZHPL
         WUqoVLAmDPDfD90UtRsyZKc9jytdS2Lt8J87tm5LNwwmS8UbqEdpBjzVU10y6DgCPWcC
         NmahXYezujYLJ18oHhDa5wYEYnWxQlj0ecEqQ=
X-Received: by 2002:a17:90b:4a12:b0:3a4:b30b:b501 with SMTP id 98e67ed59e1d1-3b3d064116cmr5525158a91.9.1795072805825;
        Wed, 18 Nov 2026 23:20:05 -0800 (PST)
X-Received: by 2002:a17:90b:4a12:b0:3a4:b30b:b501 with SMTP id 98e67ed59e1d1-3b3d064116cmr5525116a91.9.1795072805112;
        Wed, 18 Nov 2026 23:20:05 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b402981814sm748560a91.2.2026.11.18.23.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 23:20:04 -0800 (PST)
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
Subject: [PATCH v2 17/20] scsi: mpi3mr: Fix partly written and lost entries in the log data buffer
Date: Thu, 19 Nov 2026 12:41:29 +0530
Message-ID: <20261119071133.127282-18-ranjan.kumar@broadcom.com>
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

Log data events are saved from the event handlers while the get and enable
ioctls read and publish the same buffer, index and entry size, all without
a lock. A read can return an entry that is only partly written, and two
events handled at the same time can take the same index so one is lost.

Add a lock for the log data buffer and take it in the writer and in both
ioctls.

Fixes: f5e6d5a34376 ("scsi: mpi3mr: Add support for driver commands")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260825210411.301535-1-chandrakanth.patil@broadcom.com?part=5
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h     |  2 ++
 drivers/scsi/mpi3mr/mpi3mr_app.c | 43 +++++++++++++++++++++++---------
 drivers/scsi/mpi3mr/mpi3mr_fw.c  |  3 +++
 drivers/scsi/mpi3mr/mpi3mr_os.c  |  1 +
 4 files changed, 37 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 403ca56c26ac..257649d9d95e 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -1169,6 +1169,7 @@ struct scmd_priv {
  * @logdata_buf: Circular buffer to store log data entries
  * @logdata_buf_idx: Index of entry in buffer to store
  * @logdata_entry_sz: log data entry size
+ * @logdata_lock: Lock for the log data buffer, index and entry size
  * @adm_req_q_bar_writeq_lock: Admin request queue lock
  * @adm_reply_q_bar_writeq_lock: Admin reply queue lock
  * @pend_large_data_sz: Counter to track pending large data
@@ -1378,6 +1379,7 @@ struct mpi3mr_ioc {
 	u8 *logdata_buf;
 	u16 logdata_buf_idx;
 	u16 logdata_entry_sz;
+	spinlock_t logdata_lock;
 	spinlock_t adm_req_q_bar_writeq_lock;
 	spinlock_t adm_reply_q_bar_writeq_lock;
 
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index fb54bd8093da..145b198b5506 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1309,17 +1309,24 @@ static long mpi3mr_enable_logdata(struct mpi3mr_ioc *mrioc,
 	struct bsg_job *job)
 {
 	struct mpi3mr_logdata_enable logdata_enable;
+	unsigned long flags;
+	u16 entry_sz;
+	u8 *buf;
 
 	if (!mrioc->logdata_buf) {
-		mrioc->logdata_entry_sz =
+		entry_sz =
 		    (mrioc->reply_sz - (sizeof(struct mpi3_event_notification_reply) - 4))
 		    + MPI3MR_BSG_LOGDATA_ENTRY_HEADER_SZ;
-		mrioc->logdata_buf_idx = 0;
-		mrioc->logdata_buf = kcalloc(MPI3MR_BSG_LOGDATA_MAX_ENTRIES,
-		    mrioc->logdata_entry_sz, GFP_KERNEL);
-
-		if (!mrioc->logdata_buf)
+		buf = kcalloc(MPI3MR_BSG_LOGDATA_MAX_ENTRIES, entry_sz,
+			      GFP_KERNEL);
+		if (!buf)
 			return -ENOMEM;
+
+		spin_lock_irqsave(&mrioc->logdata_lock, flags);
+		mrioc->logdata_entry_sz = entry_sz;
+		mrioc->logdata_buf_idx = 0;
+		mrioc->logdata_buf = buf;
+		spin_unlock_irqrestore(&mrioc->logdata_lock, flags);
 	}
 
 	memset(&logdata_enable, 0, sizeof(logdata_enable));
@@ -1346,11 +1353,15 @@ static long mpi3mr_enable_logdata(struct mpi3mr_ioc *mrioc,
 static long mpi3mr_get_logdata(struct mpi3mr_ioc *mrioc,
 	struct bsg_job *job)
 {
-	u16 entry_sz = mrioc->logdata_entry_sz;
+	unsigned long flags;
+	u16 entry_sz;
 	u32 num_entries, sz;
+	long rval = -EINVAL;
 
+	spin_lock_irqsave(&mrioc->logdata_lock, flags);
+	entry_sz = mrioc->logdata_entry_sz;
 	if ((!mrioc->logdata_buf) || (job->request_payload.payload_len < entry_sz))
-		return -EINVAL;
+		goto out;
 
 	num_entries = job->request_payload.payload_len / entry_sz;
 	if (num_entries > MPI3MR_BSG_LOGDATA_MAX_ENTRIES)
@@ -1361,9 +1372,11 @@ static long mpi3mr_get_logdata(struct mpi3mr_ioc *mrioc,
 		sg_copy_from_buffer(job->request_payload.sg_list,
 				    job->request_payload.sg_cnt,
 				    mrioc->logdata_buf, sz);
-		return 0;
+		rval = 0;
 	}
-	return -EINVAL;
+out:
+	spin_unlock_irqrestore(&mrioc->logdata_lock, flags);
+	return rval;
 }
 
 /**
@@ -3020,13 +3033,18 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 void mpi3mr_app_save_logdata_th(struct mpi3mr_ioc *mrioc, char *event_data,
 	u16 event_data_size)
 {
-	u32 index = mrioc->logdata_buf_idx;
+	u32 index;
 	size_t entry_payload_len, sz;
 	struct mpi3mr_logdata_entry *entry;
+	unsigned long flags;
 
-	if (!(mrioc->logdata_buf))
+	spin_lock_irqsave(&mrioc->logdata_lock, flags);
+	if (!(mrioc->logdata_buf)) {
+		spin_unlock_irqrestore(&mrioc->logdata_lock, flags);
 		return;
+	}
 
+	index = mrioc->logdata_buf_idx;
 	entry = (struct mpi3mr_logdata_entry *)
 		(mrioc->logdata_buf + (index * mrioc->logdata_entry_sz));
 	entry->valid_entry = 1;
@@ -3039,6 +3057,7 @@ void mpi3mr_app_save_logdata_th(struct mpi3mr_ioc *mrioc, char *event_data,
 	memcpy(entry->data, event_data, sz);
 	mrioc->logdata_buf_idx =
 		((++index) % MPI3MR_BSG_LOGDATA_MAX_ENTRIES);
+	spin_unlock_irqrestore(&mrioc->logdata_lock, flags);
 	atomic64_inc(&event_counter);
 }
 
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 6d43112aebb7..637cf575e6bb 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -5029,6 +5029,7 @@ void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc)
 void mpi3mr_free_mem(struct mpi3mr_ioc *mrioc)
 {
 	u16 i, j;
+	unsigned long flags;
 	struct mpi3mr_intr_info *intr_info;
 	struct diag_buffer_desc *diag_buffer;
 
@@ -5197,8 +5198,10 @@ void mpi3mr_free_mem(struct mpi3mr_ioc *mrioc)
 	kfree(mrioc->throttle_groups);
 	mrioc->throttle_groups = NULL;
 
+	spin_lock_irqsave(&mrioc->logdata_lock, flags);
 	kfree(mrioc->logdata_buf);
 	mrioc->logdata_buf = NULL;
+	spin_unlock_irqrestore(&mrioc->logdata_lock, flags);
 
 }
 
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 3fb9d4de2d65..10789163b710 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5720,6 +5720,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	spin_lock_init(&mrioc->adm_reply_q_bar_writeq_lock);
 	spin_lock_init(&mrioc->sas_node_lock);
 	spin_lock_init(&mrioc->trigger_lock);
+	spin_lock_init(&mrioc->logdata_lock);
 
 	INIT_LIST_HEAD(&mrioc->fwevt_list);
 	INIT_LIST_HEAD(&mrioc->tgtdev_list);
-- 
2.47.3

