Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793794256;
	b=lBZFzM8YWHV3e6FfDXOS361oOCaU+1E2FumNUwxtC9F/ibXSmbE+6Xh7FiOAnobnFJzR
	 475dV7LESJnBcMVQFzzlYLj2MdZpk1r/tMWZRIVMDFE3VQwIo2DGQaN8iitpbLxxOnYiX
	 mC6pIBXZCMMkx5G/6Yv1feZ9NTJzQ1p5zeehH1m47icD51mPdtD6UXzGj+1UT0PJjrwDt
	 VDiU1hOIPr0oOJvQCwJcxu05+Wu32ekrOgOxmDWhQ8KnZkpG6LfHN+COziLQo10sxXL6H
	 f04IuY3GLmqsY39oJV509mRFuyJMdA0TW/l5SjdIdNnXbSoyJLDeokQje/wq8yIQ6EA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793794256;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=xKig14eCpaGfVXM2fE6If+4E00EVwH9HLnob0D9r6L8=;
	b=aWH5GoHwhn22HH3r3LvtqKN95MMrwnvFgr+qH7Wa0oNp3jh8UGWmk5ig8yILBL4OKX5c
	 p2tOCBeWNbVd4BM5bhAxs9ntY4K/NAsWRRJyJp4k3JzP8r/mfzEudixABDLsxtIX4hxZ3
	 TkPbj4nQcF3uCENcZtp7y5GOx7ka8OjUm9Gl13liPw7L1C+dR7+kLlH9E8F9hcUbW0QGy
	 +TIP5vEPk7GoOpkkz6/R2N99Wh+DG9sp7XEqfH1h+33wohX/H82KYMzI5iakXlpYgcTvm
	 VWGMG/oUzqtQ3CJbvy9oWQoZ/sR1c6UPS+JU4gkIPiAvrNq/RWVyDlzbximH/G5q12A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=J7xvmv5d;
	arc=none smtp.remote-ip=209.85.217.100
Received: from mail-vs1-f100.google.com (mail-vs1-f100.google.com [209.85.217.100])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C096F606A31B
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 12:10:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C096F606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=J7xvmv5d
Received: by mail-vs1-f100.google.com with SMTP id ada2fe7eead31-7cc603a168fso143206137.3
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:10:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793794255; x=1794399055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xKig14eCpaGfVXM2fE6If+4E00EVwH9HLnob0D9r6L8=;
        b=RNQb58GzyrjbdbK4yTXlFyeOw6z+Zpvc2nWT6PW/GU4UODiTkeroA0BwP/Fmfr61dZ
         UaFD9AJt1v6EiqNFbmrPYiLm+d1XYkGHwBeHanxv0Jmpe0zwmlPySWW/qS2xJn0ZXD7y
         HEsLQOn3vJ04OUONE/O/umL4GLkLlFZKOasWcLxd284IhPrhzaDKNkyHKc1jC1mLoEPP
         q8oVcxjD0qJ5IJkfnxk7dcFFD4rGpNn2mdnjWrggHMQh9Ks/Az1qVLsFPF5oR/7RwnWx
         yELlUw1H1Ncl7WKJhsqQLjaDo4jiO5jbb74wQeoJ/X5O9KXEeJcNWpmd+d1mLCdh4Z7E
         7VgQ==
X-Gm-Message-State: APuU4Z+pltNou6rdqkz7Z984VteqxKDWOD5IrTxGiLGMf2iynycepPe6
	ETLbRqrPERjPiC6nwNOHQGWIq7+bBrQe5xK3u6L/MVqt1bbGQBMjqUsgzDO2YoAyYDagpZYhGXa
	azQ9xDo/FSo3cxcKMz5VhrS215RKEVaD9OQAaWdjCFpF8jEoJGSysLXKwnr3x3rwE00Nr9yXCGZ
	iyEslAHhgzHFh2cjicMctr6dvh+eSEH2Tn+ZqAUZ4FoZ6XzzxYDnsGJP5frkWs+sbJgwjfY1SZu
	WtoGbVQTeAeLWla
X-Gm-Gg: AYBFou2LOhuj2+4etfFIP3PF1k7t196JbOcaeErug0HMNMVolpQ3eNlRAfPaG2Ed9rb
	RtNlroAQAh9FZGeFkIsKjbpTW11LqzskP8tmqiyiAz21cYulBF1sx9MeWbvp72Sa4FOtOgld+UR
	3H3w8ZZRYIVXAm1QcVWWKoq5SR0VJG/pzNsBdSsUHIRswygM4n5mmn9juYpWtLcwp8csVpcMLxt
	2oxgX+c/TCvLMkkP3+1JNCW/SI2jbYU9Hu11NJL1EpiP8Wne+uo4mTewadgup4SeHMo7hioYIoS
	uT81f9czWOESbHsih55nzCRuVbGbbGXn4esM4zE03vc8zQY0yJKTJoHFVsAuwndLTUzkUJO7hPf
	x95vAZVbMEwHuyQpz4/WK2TGTfRZbEucAB57Glk4IMWm1E7MrYkAjd2t3EX9BJziyKAwgNtoMu6
	6IcLaMFcKUOMJDA4fT0AR7Oghra+sd7ir/S7k=
X-Received: by 2002:a05:6102:c01:b0:7cc:776:6c41 with SMTP id ada2fe7eead31-7d072c9f864mr4883035137.22.1793794254393;
        Wed, 04 Nov 2026 04:10:54 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id a1e0cc1a2514c-998d9c8bb49sm110613241.16.2026.11.04.04.10.53
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2026 04:10:54 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-351788121cfso2831597eec.0
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:10:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793794252; x=1794399052; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xKig14eCpaGfVXM2fE6If+4E00EVwH9HLnob0D9r6L8=;
        b=J7xvmv5dZbYwCaucAU/+iGM+cfKi9Z7ejvJiPvguqNHSG6aClMaK4oownPQr+dREur
         VcKwTxzNb21rSMW7ndr89ykE4svrMKljsntE1CJ6pze5iWNhhn0TS37RQg0UOIcphiql
         LGK0PKryEoKI1RzAV2PuWG2jgLyr7wF9vmZUw=
X-Received: by 2002:a05:701b:2084:20b0:153:21e5:4328 with SMTP id a92af1059eb24-1ac5a9670abmr25573569c88.17.1793794252082;
        Wed, 04 Nov 2026 04:10:52 -0800 (PST)
X-Received: by 2002:a05:701b:2084:20b0:153:21e5:4328 with SMTP id a92af1059eb24-1ac5a9670abmr25573525c88.17.1793794251125;
        Wed, 04 Nov 2026 04:10:51 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c6f0dcsm9377095c88.21.2026.11.04.04.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 04:10:50 -0800 (PST)
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
Subject: [PATCH 18/21] scsi: mpi3mr: Fix partly written and lost entries in the log data buffer
Date: Wed,  4 Nov 2026 17:30:59 +0530
Message-ID: <20261104120103.503871-19-ranjan.kumar@broadcom.com>
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
index deb8a1eea917..c87c85adb680 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -1165,6 +1165,7 @@ struct scmd_priv {
  * @logdata_buf: Circular buffer to store log data entries
  * @logdata_buf_idx: Index of entry in buffer to store
  * @logdata_entry_sz: log data entry size
+ * @logdata_lock: Lock for the log data buffer, index and entry size
  * @adm_req_q_bar_writeq_lock: Admin request queue lock
  * @adm_reply_q_bar_writeq_lock: Admin reply queue lock
  * @pend_large_data_sz: Counter to track pending large data
@@ -1374,6 +1375,7 @@ struct mpi3mr_ioc {
 	u8 *logdata_buf;
 	u16 logdata_buf_idx;
 	u16 logdata_entry_sz;
+	spinlock_t logdata_lock;
 	spinlock_t adm_req_q_bar_writeq_lock;
 	spinlock_t adm_reply_q_bar_writeq_lock;
 
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index bf2c8c413a80..310ead2c644e 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1309,20 +1309,27 @@ static long mpi3mr_enable_logdata(struct mpi3mr_ioc *mrioc,
 	struct bsg_job *job)
 {
 	struct mpi3mr_logdata_enable logdata_enable;
+	unsigned long flags;
+	u16 entry_sz;
+	u8 *buf;
 
 	if (!mrioc->logdata_buf) {
 		if (mrioc->reply_sz <=
 		    (sizeof(struct mpi3_event_notification_reply) - 4))
 			return -EINVAL;
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
@@ -1349,11 +1356,15 @@ static long mpi3mr_enable_logdata(struct mpi3mr_ioc *mrioc,
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
@@ -1364,9 +1375,11 @@ static long mpi3mr_get_logdata(struct mpi3mr_ioc *mrioc,
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
@@ -3023,13 +3036,18 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
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
@@ -3042,6 +3060,7 @@ void mpi3mr_app_save_logdata_th(struct mpi3mr_ioc *mrioc, char *event_data,
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
index ed9e83a4119c..7a7ef199d3cd 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5717,6 +5717,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	spin_lock_init(&mrioc->adm_reply_q_bar_writeq_lock);
 	spin_lock_init(&mrioc->sas_node_lock);
 	spin_lock_init(&mrioc->trigger_lock);
+	spin_lock_init(&mrioc->logdata_lock);
 
 	INIT_LIST_HEAD(&mrioc->fwevt_list);
 	INIT_LIST_HEAD(&mrioc->tgtdev_list);
-- 
2.47.3

