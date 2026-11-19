Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.227
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795072751;
	b=rNm+nkYxAKqp75WPdf4R7Uy4o8b57QG3RWs5VBZE+qM5RVPfST/papXh/9MhFNtq54J1
	 vwHSFxe9weRoXXm9GW0W972BoLQnsuXyNVElVJ1uUjZpRxGejnG5Xsq/1Zg3vs4pANL3F
	 BtONOrnU8Iu876IQ1wfmxhOLB/1HijN1SZi+0nNA/trekOr56A8jE4sRjMDLvAwFp+z3D
	 IO/xef6MJV1eaVaEN1FNT/hdkcY6Z3Z4YzUDy5NBtm1Vj9vtx8w3n/vvHiw79ewyHLH6/
	 gwIJpuuRh/qoaGZXcEjc7lJ30unV+Q6JmNPE2E09pYEziiQzW9MQgBbGfNZ1OAi/eIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795072751;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=S4pYIEMY3xYG/FJx3vzAd/ZB8OaU52T6sxhf5LCfVv4=;
	b=QUiFYRZSjZpvBmuj+kcBYFlJzpkjiQVcS9Z94n3Rb3+7g0jojqx8hEFIrPt+5mGiRR2N
	 52NEybf/xnG4DfFtqaBn+MGN113aZiZ6npKcYYwEg7inBF0DBK3eFFUBWxdvcrlAuJzH8
	 RO9Nq/OTlw+KKF5ybw3wsP13vdAVTa2+PCMoMhlC8JPUBdqRXkQxH2hAR32fAnXd85LQi
	 shqbqU4g4kflTB+UOrAfpz1hfvFFh2ns/lFLyOZNerzYSUNIfHuVCitXpqqMXmCFTno5k
	 Uy8DZ6Gwzejp/XC316SP/HHZ9ntRgva5ZoD5Jird1QPjd0BbQR1j4sZAHA5mm+D182Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Iw+fVQD6;
	arc=none smtp.remote-ip=209.85.215.227
Received: from mail-pg1-f227.google.com (mail-pg1-f227.google.com [209.85.215.227])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6661606A32C
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 07:19:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E6661606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Iw+fVQD6
Received: by mail-pg1-f227.google.com with SMTP id 41be03b00d2f7-cd6028ff33fso1341705a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:19:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795072750; x=1795677550;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S4pYIEMY3xYG/FJx3vzAd/ZB8OaU52T6sxhf5LCfVv4=;
        b=DFUnbHaXdKmdsMc1J5hVSe0zVAeg6m57OcMcOtqWAdTNKqm07g9M2PPF3bnpMC10ch
         Pf0wZ7B9pmT/Fzg8MLDi/huSrz2aTQtiAr0aevVAV6ZmXW+Sat3+Vn8sGctHsHId0sbX
         l3B5UE7KiBNXLvE5CL88PhKX2dlSwfc7VWvns48/oMinsyCwX3xiZFjSXdK0Xcz4SKhY
         uUIgVzBOyn+ON/0pegqPRfUTY3DznrFLvyLKbC6CW7UQhwf80lHmgZI8VALH90UPu0GB
         zmmATyWL0ohzLHvWl/v+txzfPMe3IsdUyVVQ+wqEwAbyoGsI/5gm+O/fA4BidHRT0eI+
         THMA==
X-Gm-Message-State: APuU4Z8S0+XUy0pVWNS2apz2ugncryWN0PMi90pMHkdk8qI4FNTO8vI6
	KP9r0IxOjxp2Uk3t0chgq4LFyNjVIKgkyjyhNtjwdEU7cgpAZmvcP496m2ROhWjeC6YlTvHPB8X
	/usS6OYes0DW+EGeWpJ63wGl/iFCMzlMh1JJqy7e6x54iJBi07nqgLjE3GkIpqxHMXY/Wx4J3HY
	kKjJOPAty7adWb2HgdNOwogQy43rSOB+e87HJZ8gF/e7NPmCXsKzS4cC4AY4g6kxtBaj2y0/VgI
	p/UVTbmq4YAlbi1
X-Gm-Gg: AZFdTZdTFzGgw0ue0L9zuOGhw5ArplRp1+hBP9HeNhy98kd0yyPOA49Eh5Sw3dds9CT
	myTqnJg7NWjiwhbp77sPPyZupQlmBafAXSnmIDmOB/DZqmOLRF+0kqS4H7KJayJZ4nLDVQvF4t6
	Dgi3GhGpGYf3OHfHHQkbSUSot7aa6Bx0t0m/rcXD1rT0Xz/oKne6sIxtGTSifERm67j3Y8hVa5K
	OC33jffVxWgpXYvR19K03uPtPk0zW5YpUfFVXvgcQj5OaQTo3b8UkFry2MvLaMO6VTKN5GjOZOl
	yZFtxz1URnAiKbXlbnE4z8yfFXWicjirij1MYWH45/U1Zo+QQ8FmohfY5iATzEUlwi9rVUJRKKJ
	aRDm/17ccIPE/Tg5ibiLo3Ql3c8gWAyKf0IGeV382vPIuLZFCL1UAQ+sK2Mi9ZDZHC+WP82+D5l
	Kpg9OEWjnNa4kNHubzetT/q9GVToOhiW396CLNyg==
X-Received: by 2002:a17:90b:2151:b0:3b0:9976:c1c6 with SMTP id 98e67ed59e1d1-3b40a8cde77mr177216a91.66.1795072750165;
        Wed, 18 Nov 2026 23:19:10 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-123.dlp.protect.broadcom.com. [144.49.247.123])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b405cece29sm513379a91.6.2026.11.18.23.19.09
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 23:19:10 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3ae1d132d52so1456488a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:19:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1795072748; x=1795677548; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S4pYIEMY3xYG/FJx3vzAd/ZB8OaU52T6sxhf5LCfVv4=;
        b=Iw+fVQD6WxTIR0ynL7TZ8SeiYZtxBZ9xIUpWPstObOxvNZC2Fw3SCAIpIAsJxX5wnp
         tyM4b6UN3UAyHUTcscdHRlH+vlHGF0Kt9M7kS3cEYg0ePhAUYD9aujEq7SQMV2fKmQEk
         mV61nBEmgFJ6PgPkEECTR3nz+5mLnid06lOtY=
X-Received: by 2002:a17:90b:53cf:b0:3b3:ae76:b880 with SMTP id 98e67ed59e1d1-3b3d07e09demr5108838a91.53.1795072748331;
        Wed, 18 Nov 2026 23:19:08 -0800 (PST)
X-Received: by 2002:a17:90b:53cf:b0:3b3:ae76:b880 with SMTP id 98e67ed59e1d1-3b3d07e09demr5108817a91.53.1795072747667;
        Wed, 18 Nov 2026 23:19:07 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b402981814sm748560a91.2.2026.11.18.23.19.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 23:19:07 -0800 (PST)
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
Subject: [PATCH v2 01/20] scsi: mpi3mr: Fix out-of-bounds read of the BSG request
Date: Thu, 19 Nov 2026 12:41:13 +0530
Message-ID: <20261119071133.127282-2-ranjan.kumar@broadcom.com>
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

