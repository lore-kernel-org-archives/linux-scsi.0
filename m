Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.97
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795072762;
	b=Vk85TUIMQHRhIGSZ3F+3/Teh7HqhDZumQjGd7Itatp0RBu57Je5Pjx2kGM5m/tH8HBe6
	 WRH1J8lgnyfXvborP4OS155ZjhXU0xhPZ1/egW4kveVlkNqD005rUHt84sPODtaD7E0KT
	 Q/xAqh5uvbCrIp+BfRJCquFL6n/PKvB8QzKBpTTXajSBFdZ/h+Fk/al6EZBIwEE2fvn9O
	 B9ZM3ysYpPCReXYNbY/Jp+OKDMOzLLm5ZYaxa2f+W/dPXgPXnKBGv/lGFddKI3bo3NyLx
	 Rzq8xf1QG1rx76gviyH3jySD2GWwBN+KfqeMh4EP882cwLU+awgvnbqa5nU6wB0Vc/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795072762;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=IOFJiExGu9yXqJTIaqMC0n1tVOmtPLO6upRNeYJIcc0=;
	b=rUCcto0wwdqKPQ1CcXsXynAEXhJdnEqdFKCHMFbXRmKOFt861LOUHAW2DaVz9eJZlPWC
	 VoBkkMaboPlhlzfNiwH5ddOxs9NhfcCvGbTBa6/vC025tMMD7Zd0pP1uJGgXdhuD7vxSz
	 NNC3OpbC+FwfsHP+s9RCqj5YJPj9KWcQ4OdtSeBt6Ofvy75qKM3XbuNMUSo6d3xdiNE9z
	 ztqBMaIelmkL/+cyq2Js6YBHOJnQ3OYojxegqtfDReoz5lMlKfChrK6W9mRBxwnvpwIvl
	 9VRlXoX63Zr9rLWMZIid7PzuW3UTs+S/6XdIdMq2NyOO3iSsJloxr7Cv4u8Ws7bu7BQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=J0dZv6xY;
	arc=none smtp.remote-ip=209.85.216.97
Received: from mail-pj1-f97.google.com (mail-pj1-f97.google.com [209.85.216.97])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C11606A326
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 07:19:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 83C11606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=J0dZv6xY
Received: by mail-pj1-f97.google.com with SMTP id 98e67ed59e1d1-3b3af93b85cso1061719a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:19:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795072761; x=1795677561;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IOFJiExGu9yXqJTIaqMC0n1tVOmtPLO6upRNeYJIcc0=;
        b=V2vioftAYSdmYtVXYjWJS7ZHfeUI7/Dh4mVZeQEPqSkAiEEg6RfewiJ4/IpHZ0oAqy
         tst8OfOgmzRrGjLRrGRTgdjK+5COuJTGnGLzf7zD51+pi+0prx0ozHfaeoXzdIijKt7n
         knPaUMDjpyOU8swLuJ30La2vRR5QxePXUbI8r23uu53Jo6cP4ScA2/dvFpwOcj1iR3cy
         RnkmTbNKxuz+7fJfZLsad/bCwWMWdfLhz2O7i9o599RSuzwo7Awy7KNcdDOk/HFMfb3C
         RbK9LBJqYRGPfBEaV8XSoAAyiFSoMu3kfDuvstlnYMsf3TOgB2izW/kpf7H4VswVyDHr
         xeOQ==
X-Gm-Message-State: APuU4Z8rp7s3yG7/ETrFPh9XHJFIneyclOvCt3+Fbq81n57tkzmpjEqM
	8vBGGnd/bKcJMc0IGElh3ZsWBTHJ2cTUYkdPWHADdXA4IpTP9S8l9dfiA0mJxq8r00Lwf47kfxR
	OmfmbIVL8UUZo290lVc/iE+RpZhWBJrYee5T7ZkUxSKoIXDgdqnzkuPAo5XPMZSelSRZO5w2/Y1
	hzkDdimJpZ0GfWli/3QjYelzSG78ENO+HCEYMcOKE6S+CKlwL2A+jO3eNt3H3KPEgP9om+0wiOJ
	nM4LXn99cr/k09F
X-Gm-Gg: AZFdTZeKdqDRcUpu8Uc7fOonbOU62oe31D4o63UhCYxLAizhHCP/amMbb8Kumba2liA
	j9KRhCvZ5f3xZH754wIj3rSd4AzplgVLVQWZW5rDzuQ5Bb5nv6P1E9BtjeTwU04t4H0Y1+LxwZ6
	1769at18lUBnDjZXbzvWgvpozA7+MVJUtJdfT2xVXskbEgVegcj538RILrof/HaU1Mgedew5+WH
	10g2iGBxKRp2xcp5E9HFZgXNkubvTStx7Up959eNBSb2AI6wWXv/jX6FNF3IA60J7/H1yYHI4GU
	ibsBhFwj7gqEYhe3LkWWTcbBJkPquFInLZ408gViDnl51OfosKkTaFpuDlDM+uLqI+DshztT4m6
	DKQwGBpydFK96si818i9AAJC5tjD/UdjSo0RxOaGGJ8pJkW3ww3tfQi0O45XX1eYUlEtU5B2kUr
	NQIz6fAARFFLPS99heAPU47H9Ur51gy+HoATpBnQ==
X-Received: by 2002:a17:90b:39a3:b0:3ac:b3ff:b476 with SMTP id 98e67ed59e1d1-3b3d07a29camr5103753a91.38.1795072760818;
        Wed, 18 Nov 2026 23:19:20 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-123.dlp.protect.broadcom.com. [144.49.247.123])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b4059714dcsm507213a91.1.2026.11.18.23.19.20
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 23:19:20 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cdaf2073b0cso1111306a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:19:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1795072759; x=1795677559; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IOFJiExGu9yXqJTIaqMC0n1tVOmtPLO6upRNeYJIcc0=;
        b=J0dZv6xY4QGHi7P7w8V/anOoZSbe5zruy4lPoQEq4x7j1MoIqrIaUW9x6bH2xvL/IC
         Lh3NlSxxdKTdwPCKPR4AjceyflMq39oUQDqFIyUKUnaEWVJu5Gd+3fGpGgsY8u2Ou1o8
         F+3cpS+Ai2dqGEQYW7pShT+T3O4nwOAcVLuc8=
X-Received: by 2002:a17:90b:3851:b0:3b0:a970:caad with SMTP id 98e67ed59e1d1-3b3d07617afmr5191548a91.28.1795072759060;
        Wed, 18 Nov 2026 23:19:19 -0800 (PST)
X-Received: by 2002:a17:90b:3851:b0:3b0:a970:caad with SMTP id 98e67ed59e1d1-3b3d07617afmr5191511a91.28.1795072758411;
        Wed, 18 Nov 2026 23:19:18 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b402981814sm748560a91.2.2026.11.18.23.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 23:19:17 -0800 (PST)
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
Subject: [PATCH v2 04/20] scsi: mpi3mr: Fix PRP list leak in BSG passthrough
Date: Thu, 19 Nov 2026 12:41:16 +0530
Message-ID: <20261119071133.127282-5-ranjan.kumar@broadcom.com>
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

The PRP list built for an NVMe passthrough request is freed only after the
command completes. If posting the request fails or the command times out,
the list is never freed. The next request then overwrites the pointer and
the old buffer is lost.

Free the PRP list on every exit from the request handler.

If a timed out command is still pending after recovery, the controller may
still use its list. Accept a small leak in that case instead of freeing
memory the controller may still read.

Fixes: 7dbd0dd8cde3 ("scsi: mpi3mr: Add support for NVMe passthrough")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260818231426.58105-1-chandrakanth.patil@broadcom.com?part=1
Closes: https://sashiko.dev/#/patchset/20260818231426.58105-1-chandrakanth.patil@broadcom.com?part=2
Closes: https://sashiko.dev/#/patchset/20260825210411.301535-1-chandrakanth.patil@broadcom.com?part=1
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 9ab17eab191d..a559c99e3b30 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2444,6 +2444,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 	u8 *sgl_iter = NULL, *sgl_din_iter = NULL, *sgl_dout_iter = NULL;
 	u16 rmc_size  = 0, desc_count = 0;
 	size_t req_min, buf_left;
+	bool prp_owned = false, timed_out = false;
 
 	bsg_req = job->request;
 	karg = (struct mpi3mr_bsg_mptcmd *)&bsg_req->cmd.mptcmd;
@@ -2748,6 +2749,8 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 				mutex_unlock(&mrioc->bsg_cmds.mutex);
 				goto out;
 			}
+			if (mrioc->prp_list_virt)
+				prp_owned = true;
 		} else if (nvme_fmt == MPI3MR_NVME_DATA_FORMAT_SGL1 ||
 			nvme_fmt == MPI3MR_NVME_DATA_FORMAT_SGL2) {
 			if (mpi3mr_build_nvme_sgl(mrioc,
@@ -2833,6 +2836,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 	if (block_io && stgt_priv)
 		atomic_dec(&stgt_priv->block_io);
 	if (!(mrioc->bsg_cmds.state & MPI3MR_CMD_COMPLETE)) {
+		timed_out = true;
 		mrioc->bsg_cmds.is_waiting = 0;
 		rval = -EAGAIN;
 		if (mrioc->bsg_cmds.state & MPI3MR_CMD_RESET)
@@ -2872,12 +2876,6 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 	}
 	dprint_bsg_info(mrioc, "%s: bsg request is completed\n", __func__);
 
-	if (mrioc->prp_list_virt) {
-		dma_free_coherent(&mrioc->pdev->dev, mrioc->prp_sz,
-		    mrioc->prp_list_virt, mrioc->prp_list_dma);
-		mrioc->prp_list_virt = NULL;
-	}
-
 	if ((mrioc->bsg_cmds.ioc_status & MPI3_IOCSTATUS_STATUS_MASK)
 	     != MPI3_IOCSTATUS_SUCCESS) {
 		dprint_bsg_info(mrioc,
@@ -2946,6 +2944,20 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 	}
 
 out_unlock:
+	if (prp_owned) {
+		/*
+		 * Do not free the PRP list if a timed out command may still be
+		 * using it. Leaking it is safer than letting the controller read
+		 * freed memory.
+		 */
+		if (!timed_out ||
+		    (mrioc->bsg_cmds.state & MPI3MR_CMD_COMPLETE) ||
+		    ((mrioc->bsg_cmds.state & MPI3MR_CMD_RESET) &&
+		    !mrioc->unrecoverable))
+			dma_free_coherent(&mrioc->pdev->dev, mrioc->prp_sz,
+			    mrioc->prp_list_virt, mrioc->prp_list_dma);
+		mrioc->prp_list_virt = NULL;
+	}
 	if (din_buf) {
 		job->reply_payload_rcv_len =
 			sg_copy_from_buffer(job->reply_payload.sg_list,
-- 
2.47.3

