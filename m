Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.97
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793794187;
	b=bZ/Xipv/Ry73VHVkpWi8y64HF8Qhcs8Nyg8Spo/coW9NAZUs+BQk9TWOyDM8v05jSIIQ
	 D2xsVab4CF7gya847rv9tLChn96/1yBbGszvdiTByPFF5cz9PKLvQCEliaKuypZG5vaVg
	 Zqi5IhvbGMgFG0p7D4nvSrPP+bxrYRZzL4Mu5wMeoIV7C9JhxBTxt9H1X2rqMqyMwS/fc
	 zKQa5gMy07sfB96v8JzYLBLmK409pYzduIZYfsg1xoDAcOt6Gbnrp09mwRq5qp7QXGgIJ
	 emYPV0zDBosPC6chQ03BBitKQUSpKV83BFmZMb903sVjet6IHsddlklkwzSGsNedMPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793794187;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=S4pYIEMY3xYG/FJx3vzAd/ZB8OaU52T6sxhf5LCfVv4=;
	b=QwBeperJ0ZuwwPD7ifrfD9878c1Cr3jbmvkTuix6QUDnW4pzfnEvagTv3X7K7XM6XM6d
	 RZ0w4q1whFW7N7824JHPZUZYUmW+t0VO+dTs9Eci5fw/00/y9YwQyG83+e4H5Wvg8eMiL
	 zR8DLknOJ5lYjPqOKZaz2bCxH/3qb0KC/uB6Dvxe1kf4DIaE5PxSjZ8cb8cGaFd9nnY/K
	 m40ZDLbkzEejX0rYQcBVBYsxtYA5eJZtr1B+3eMK8NE6BYx/1BsRESrIQB9WIGYRDYE4w
	 JLuct3iqzdadok59dRtdh2agboLc1slpHjMGxmwjxFiGDyCwbM+NZUoOSI+0VfVsm6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=cMjQvIbv;
	arc=none smtp.remote-ip=209.85.216.97
Received: from mail-pj1-f97.google.com (mail-pj1-f97.google.com [209.85.216.97])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8B6606A31B
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 12:09:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8A8B6606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=cMjQvIbv
Received: by mail-pj1-f97.google.com with SMTP id 98e67ed59e1d1-3b08a162d4bso493525a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:09:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793794186; x=1794398986;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S4pYIEMY3xYG/FJx3vzAd/ZB8OaU52T6sxhf5LCfVv4=;
        b=o8gUbccAhVp/ts5kkuyTAGYKkbApTW4JOay6LuEXwJkC9rIrcoDzQ/YlSAvaKO4trG
         czuFjLdX0Yiz5ofkA6x1myldtL5eUkFiadfR6Dn7SITlieHPA5lUcZrCxEOqbAlyMNsg
         HervwNOcKm4ctp4Yqvwrrc+ZCOXRsk8t95aF5cCQd/jSmpIR6NUQwi4sHQhKtg0GejSe
         xPSsTBZLUDXZuLemFFlWyYwHtxCUdBVfcXF7IFLtIOnvx/wu7kKnbzUQo33WXiK1CdUn
         vLBwfTfinYyEktkD5jePcOtSZl0G5AMYb8Xcx6zy+VrxtLWJg6Z+iMMo+LiFiKy87L2D
         ol1A==
X-Gm-Message-State: APuU4Z8j7E6T94UvyRqhb7BQpuGPW0KCjAd3WJiQlRLKXSWUGMzdmB9U
	9xNRTi6gieQ+Ex7g7MEF9SBavlkmgaKS2lqGr8X7AP8SdbLFfKKbbCbZhwx8Dvdgymo2iwxNFgp
	H6Da122FTiocc0zuVmN6MrdlaOMP3aNzS59VRqPRfMFGF2XWzemycrh4hwizscRuCw1vuhz8VFZ
	h/KiYuL8FrgWZ52fIi6/qU8SncqW8dxXqywpYxHj2xrYGFDiMt11etvaCFWug3dau4P+6OxN1rI
	kMnstsViUpkz1eb
X-Gm-Gg: AYBFou12U5SNGGzomwysYzZhPy/w07MYDtowRIlBzWccHCxoLEce8aXJWmmChbRA1ps
	AmiGIbnreyldDk/RHhTcU4pACH8Jns7a3WpuCR2uxNrRrHSu07XypAvDpX+bsfsVUH+hs+ym0iD
	cea4rw9634/jFRG3WQmbKNKtl+3PIvd8oAuA+ZXfJf0mOfzBMms7rUU03okfZOwgugpW6pmvuAr
	lOYhQzGmhUkRcM22W4MJYdqF53wN3pyQr8tX0fyEnqBzJ53LGGERxIFEVPuI9X6Xm5EeCx9etzF
	2Jg1dC3eXKuO8ma/aO0E2xOtfIW4QU49ulD0ruGIffO95j9wMgvcvCwkblPpwwn6CXHqXIYS/pU
	SgiQzQuu+AaLxEKEMeARODeLbIToxdRo9tx/O7z4RtQxaoXZQw0v/s0kNZDuNP7q5FReeEiEXYT
	pKtSnu+8m1WCEgMUC8JDJvf0aTActcTF7+Sdg=
X-Received: by 2002:a17:90b:4c12:b0:3ae:5572:c4d1 with SMTP id 98e67ed59e1d1-3ae8986e3bamr14583207a91.62.1793794185564;
        Wed, 04 Nov 2026 04:09:45 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b09453d7f1sm1721541a91.4.2026.11.04.04.09.45
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2026 04:09:45 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-14373747468so1641893c88.1
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793794184; x=1794398984; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S4pYIEMY3xYG/FJx3vzAd/ZB8OaU52T6sxhf5LCfVv4=;
        b=cMjQvIbvMFyyhbBdI1PLVG45RpFhDTNd1XywUSM6Swp/MinKloIUNMXUdgbdrREUoY
         EOpk5AZsk29LP+Pdsh7POz3mjcRxNnIq8VYsfQqJ0w0u3VrhpXwBgPAPqbcgMuNxz+jN
         KIRHM8thkPuJZ7tHGRa5cgv50AhQjF1yPUg/U=
X-Received: by 2002:a05:701b:4502:10b0:163:fd28:5658 with SMTP id a92af1059eb24-1ac5b02289fmr23471271c88.22.1793794183592;
        Wed, 04 Nov 2026 04:09:43 -0800 (PST)
X-Received: by 2002:a05:701b:4502:10b0:163:fd28:5658 with SMTP id a92af1059eb24-1ac5b02289fmr23471208c88.22.1793794182748;
        Wed, 04 Nov 2026 04:09:42 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c6f0dcsm9377095c88.21.2026.11.04.04.09.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 04:09:42 -0800 (PST)
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
Subject: [PATCH 01/21] scsi: mpi3mr: Fix out-of-bounds read of the BSG request
Date: Wed,  4 Nov 2026 17:30:42 +0530
Message-ID: <20261104120103.503871-2-ranjan.kumar@broadcom.com>
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

The driver reads fields from a BSG request without checking its length. A
short request, or one that declares more buffer entries than it contains,
makes the driver read past the end of the buffer.

Return -EINVAL when the request is too short for the command or for the
number of buffer entries it declares.

Fixes: 4268fa751365 ("scsi: mpi3mr: Add bsg device support")
Fixes: f5e6d5a34376 ("scsi: mpi3mr: Add support for driver commands")
Fixes: 506bc1a0d6ba ("scsi: mpi3mr: Add support for MPT commands")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260818231426.58105-1-chandrakanth.patil@broadcom.com?part=1
Closes: https://sashiko.dev/#/patchset/20260818231426.58105-1-chandrakanth.patil@broadcom.com?part=2
Closes: https://sashiko.dev/#/patchset/20260818231426.58105-1-chandrakanth.patil@broadcom.com?part=4
Closes: https://sashiko.dev/#/patchset/20260825210411.301535-1-chandrakanth.patil@broadcom.com?part=1
Closes: https://sashiko.dev/#/patchset/20260825210411.301535-1-chandrakanth.patil@broadcom.com?part=2
Closes: https://sashiko.dev/#/patchset/20260825210411.301535-1-chandrakanth.patil@broadcom.com?part=3
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index eadad89bfcfb..ba70226f9cee 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1690,6 +1690,13 @@ static long mpi3mr_bsg_process_drv_cmds(struct bsg_job *job)
 	struct mpi3mr_bsg_packet *bsg_req = NULL;
 	struct mpi3mr_bsg_drv_cmd *drvrcmd = NULL;
 
+	if (job->request_len <
+	    offsetofend(struct mpi3mr_bsg_packet, cmd.drvrcmd.opcode)) {
+		pr_err("%s: invalid BSG driver command length(%u)\n",
+		    MPI3MR_DRIVER_NAME, job->request_len);
+		return -EINVAL;
+	}
+
 	bsg_req = job->request;
 	drvrcmd = &bsg_req->cmd.drvrcmd;
 
@@ -2416,10 +2423,22 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 	u8 *din_buf = NULL, *dout_buf = NULL;
 	u8 *sgl_iter = NULL, *sgl_din_iter = NULL, *sgl_dout_iter = NULL;
 	u16 rmc_size  = 0, desc_count = 0;
+	size_t req_min;
 
 	bsg_req = job->request;
 	karg = (struct mpi3mr_bsg_mptcmd *)&bsg_req->cmd.mptcmd;
 
+	req_min = offsetof(struct mpi3mr_bsg_packet,
+	    cmd.mptcmd.buf_entry_list.buf_entry);
+	if (job->request_len >= req_min)
+		req_min += karg->buf_entry_list.num_of_entries *
+		    sizeof(struct mpi3mr_buf_entry);
+	if (job->request_len < req_min) {
+		pr_err("%s: invalid BSG MPT command length(%u), need %zu\n",
+		    MPI3MR_DRIVER_NAME, job->request_len, req_min);
+		return -EINVAL;
+	}
+
 	mrioc = mpi3mr_bsg_verify_adapter(karg->mrioc_id);
 	if (!mrioc)
 		return -ENODEV;
@@ -2995,6 +3014,12 @@ static int mpi3mr_bsg_request(struct bsg_job *job)
 
 	struct mpi3mr_bsg_packet *bsg_req = job->request;
 
+	if (job->request_len < offsetofend(struct mpi3mr_bsg_packet, cmd_type)) {
+		pr_err("%s: invalid BSG request length(%u)\n",
+		    MPI3MR_DRIVER_NAME, job->request_len);
+		goto out;
+	}
+
 	switch (bsg_req->cmd_type) {
 	case MPI3MR_DRV_CMD:
 		rval = mpi3mr_bsg_process_drv_cmds(job);
@@ -3008,6 +3033,7 @@ static int mpi3mr_bsg_request(struct bsg_job *job)
 		break;
 	}
 
+out:
 	bsg_job_done(job, rval, reply_payload_rcv_len);
 
 	return 0;
-- 
2.47.3

