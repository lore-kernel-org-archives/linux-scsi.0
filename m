Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793794198;
	b=t0dmNW6uLrdfgn3zP56PFzX9sBijKeoJMUbJbG3tkAJMtiCK71U1nfINHBNK4hFImsZj
	 TrN2GtwMFwuitRq1kmXS9ChfHKy3H+uXAmygogO7s0kWaTgbO1j4DWRQ3VeYLB+G84jAe
	 GP9fE8X4bZzd8UN7lUnPgsW/tBsZsO5jno/jnbbh/bFLDmw9XRh3K42rG619Jvk426/W3
	 /dCoVbqCwf5nlpJZrjsTbfVEH/4XyCvDOVSinLCQ5Hk4BQ5Du3M+3IE+3LxGUUSqIL0M9
	 ltKMTQO7NjK6IfLBYDujEnnNYKOb+kPhUnDCbaDQkpU1qRTah/e4iTtmuBwPy26MjCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793794198;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=IOFJiExGu9yXqJTIaqMC0n1tVOmtPLO6upRNeYJIcc0=;
	b=QKBBzWaaGLrtXVOoutKO1viPgiCwsNrV6Km6S61Mpazk66UhZVlHyPsv7+InTNAZJvET
	 edPv3wscFiJD1r6mw2MkPm7Q4dDJpiKlQS0D+XJV20mUtqHNT4DoEK+e3b70CCh7tj6sa
	 IDoljcpKyQT/pRUqPNJdhWphwEn4RvvxK0iAMhHpf5o1fwGbZQjDXphLY+wuvUXhShXrw
	 ydbZQN7gy0MorT6Snm4PDp0S7U6jV+PCU2Yx2O4lwRSeoRWTB+b55ZQPd4oi9ZieFPI23
	 EyzWSl67NHGqtHvlMYpTCQ5rFDkIF6ec92WR4e/ff52DSdiidjhPwwY20Ss6MAZSvUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Rvv51Zt5;
	arc=none smtp.remote-ip=209.85.216.98
Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601F0606A326
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 12:09:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 601F0606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Rvv51Zt5
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-3ace1f3897cso364875a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:09:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793794198; x=1794398998;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IOFJiExGu9yXqJTIaqMC0n1tVOmtPLO6upRNeYJIcc0=;
        b=bTFnfs7M5hp8Hz7nUvw3fZ3Owl1tja0fWv6H0gZcTLxDcyBzODur1HA0oKWBhoI1oS
         k2icvuSIIZnA1FXLEYsn8neTgr0TS3k+g35yUrZWew40aT6w1X83kHJ/OHJOf8EmHtOV
         FojegJj7pb3/C2NwtKOvL/4Xrla6lmaXi5ozZXNVsgefbTYZ4VyPCjiVBQXIt/FF5pIj
         ZftMLUwhwcVHs5MpSWj423iJg8b6rYG45+cCqwxppoCuqHZmOW/8acRfwv4/xl5aLNeo
         j4ZMzJeLbwxUrJSsm1PC/bJbO4qb4hokFFhVxo7JvS1l225eQIAQjqrDbE5C+E6138jG
         GPiQ==
X-Gm-Message-State: APuU4Z/a7o5K/t/ReCbYDS5XdcmNMN6KLkFyrRbC1spibbblQJTU4QIj
	9g9gv4xoIArbDxk9HduaLJMWzX9uuEY/AFP0DN1rWeW8/w/Ei7P6pj5+z29AW77VkSrJ/YjkDhi
	Ay9bHL9+XQqwVRT0V3hjKNrIwMR5qgVxcTD5pO77wb3nLc1t5cHwcTAkXyXpUk3oJan4a1vNosC
	n/PH6u3dK7/5JFmUIyjY9gkaHAtVWEgArEfzAsZqVwWBpUK3EyCZXMGn8l0stLrnVBtNg3L6WI+
	dYSdHNMVIk46SFW
X-Gm-Gg: AYBFou1B0kEgkiQtgr1LoftAkx10L++6qAgtTpup+/ZkCA2icjN0L500NYpfCorI/KL
	xTPo7iB1xIlt45bjo1AU8oAaWKwhycZJ2a0yMv8B7vn/ymMIOwxKadmivCRRAk0dtjRKiAH0xg8
	Wgp13VrugbxJFP8zYzvs13HlI042gOMbzRoQE69JE9d1Rqr9RrqYXYOAkFXZW+qcibjgOCdbhv+
	7N07Xg7LRYKC8Ncc+k2Spp4AVN5fzNQk+qlqdTbt0eO1FmJt8DsYDyGLN/VgAJQJ4UO5Fs5fDCO
	5vKYf/8lutVlN1bDwtAd+B0omPVZKgaQp/d6mmh1pJK2ta/FTtyK6C0nlri1vJ2k/nKUoFSkdgX
	tsqwzTmiRjCv9d9R+ol7Rmsxo4RPBEgUAX+FiBmnh0fH9o5uXtqGrQ+1w4kPfMafEfx7u/p/95T
	QGboZtuD7BKsAztXMhrREr+3vdVrP8Z7rayUQ=
X-Received: by 2002:a17:90b:4ac3:b0:3ac:8897:7ba5 with SMTP id 98e67ed59e1d1-3ae8986566amr13793730a91.59.1793794197629;
        Wed, 04 Nov 2026 04:09:57 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b07cabc00asm3978666a91.8.2026.11.04.04.09.57
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2026 04:09:57 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-14373747468so1641992c88.1
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:09:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793794196; x=1794398996; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IOFJiExGu9yXqJTIaqMC0n1tVOmtPLO6upRNeYJIcc0=;
        b=Rvv51Zt5XNwObme05j5x0JfzWb7FSFycMMC91KUM4Gp8wWDgTY6Qs4WEwfQ0p0RssW
         BaaFRB/PLBkDqXhjaB7XqpuNRfsRXik+4NBRjekFSMy3+quVc/mm3ioKkSL3fQOhCsLs
         CYdABZMBQcFyYoFrohiY3DKwUFhtz/tFNPDog=
X-Received: by 2002:a05:7023:d0b:b0:191:ac4:55a7 with SMTP id a92af1059eb24-1ac5b024d1emr25124009c88.23.1793794195343;
        Wed, 04 Nov 2026 04:09:55 -0800 (PST)
X-Received: by 2002:a05:7023:d0b:b0:191:ac4:55a7 with SMTP id a92af1059eb24-1ac5b024d1emr25123933c88.23.1793794194492;
        Wed, 04 Nov 2026 04:09:54 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c6f0dcsm9377095c88.21.2026.11.04.04.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 04:09:54 -0800 (PST)
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
Subject: [PATCH 04/21] scsi: mpi3mr: Fix PRP list leak in BSG passthrough
Date: Wed,  4 Nov 2026 17:30:45 +0530
Message-ID: <20261104120103.503871-5-ranjan.kumar@broadcom.com>
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

