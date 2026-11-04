Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.227
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793794207;
	b=zjgt2Lr6irHZ5nGSBhsrMn3qQxv/YT4l7n3Vpu6vyZUp5Q/hQs07oK1EDPVQdwvK13cW
	 puBbiNzWNz+KURSTTu8eSCo6gbzaHOktuyit8qqnPH0Q5sG7dvkA6Yi1P7aLkNu4gUI/v
	 ZUjx+T9P0Co8yLa9A+XYSC+/bJjaMxjZkCN6R6Y+u7f+neJkLzasAzzta4NxID8NXGWNo
	 Gb/zc9Rw8DVh6IB10xB1aVxLnbk62xqglvTyVKWeDXMSDGgocKR2LZkh/IP6wD6uHiecY
	 vCv3XLXNDwwnJ/cfGw4DdW45ScFjQrpSz8ajnb+Yesi30BS0+mlKDI2izvGwa/YzosA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793794207;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=hxg+mZ2q9eGQA/pGVPjbxp5mlhgJhPNVEUMn6doFsnw=;
	b=ugENIF2CDB0pCr3in4KuVnO/nGwTAslH8CNS8QLLHZLz93SV22kh5qpdJAAS4HdALkD6
	 yJ61hMlUIrgSKQMgLbo/dTqADeQlO98jgFpE+uJd1/OB0wKHTSl5fsmNpX9eQiR3zlk5A
	 O221srX0mgjC+9QRCsVAD9r7lr4Tuwo6KwRyYGRfcxqa6L6p7E/VZlTP3MCfeUUK9AEmX
	 VYpOqVH7SFzJWa0vczmZdETSbVf2dj46GpFA8w0RW8qhIX+WJfbm55mQXttGSu9+AOc0q
	 T8cAmVffYjq7qw4e46hIhgjBhd+9/rtGaOf8dsXDM7TLh/LGR9TrizhDfO+SxA4fO5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Uo2Xl53O;
	arc=none smtp.remote-ip=209.85.215.227
Received: from mail-pg1-f227.google.com (mail-pg1-f227.google.com [209.85.215.227])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5CB606A326
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 12:10:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D5CB606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Uo2Xl53O
Received: by mail-pg1-f227.google.com with SMTP id 41be03b00d2f7-cd8ca57ef64so687660a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:10:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793794206; x=1794399006;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hxg+mZ2q9eGQA/pGVPjbxp5mlhgJhPNVEUMn6doFsnw=;
        b=MJOVBUjN39Ho4Ek1bk0Ub3de5SmFulZywS79P2I9I0ktpkWJT3xB3Ei9R9TH9xi9bK
         JpLdP5jZGA0rld94Kk0JzCFfq0mlkH6uHiokbct4wr3dhrls0Y5A3a3bLpHt6dxU2P7C
         ig6fcHimYOz+sTnGHzT2XlDEgQsllrY3CEYDNybf5cGYwJzXfNkF8InfHRDjLM6uiWTR
         AA54UOq3mZ5Gcn64Ni4ywduKRceheoOsBkc2rfFx3OKsUeW9l/l2zj7qgrCni/qMry6a
         ZysQ8VHtiCi1ntf1V0P9jiRhJqvpoMtFF+2r3Sj22uQsiUea7q1u7zlyaF7iVhGNcPva
         GROg==
X-Gm-Message-State: APuU4Z8ixzv+SbQm1hmzpvDt6aqHMqhSim2A3pd8LbSt/dpby+zxnBRI
	f1CzO1Y4LHuBDcjebqlVmUbXeTvfTdkdG/3ktUN8Bv77rHBBLxjJ3uP+A7YYw3Ibmq7wRy7DQcV
	Sr0eoZAaQNSzcubApKtzpSknr4UByuESX4qTVu586Wk4lIK3Ta9XTWETI8sYop+weeaiu4F+xl0
	9UUDn8RjRz0tkerHgen83qwszmOSbohG4dWY+W6kF0SygZv0rqmowsHfBJ9azgu56dLYoImDyFf
	jjWMMuAoFdSN6wd
X-Gm-Gg: AYBFou33x86Yn2DWICXrUt6wnlDCjdbigbuEsZWx24G4PPHXTHBz4D+dxCbonRvQaTx
	tcQ+l5uT3oeVcYtTOv5qnUgd9cr8Q7pG7Uu36ceJa5QfrUAopKfDcYDVnxSayqUaP/j29/sy0qx
	c5rD2A/iShkEQKqgpLulKt9M987vKbI5qiLShmJ9Se3QdaaCxEzwGBb6TL4P0Y1EaBT68RpU7X0
	irm0d6PGJ4k8fWF3uGM9gfw/a+qh1z+D20SPzooa7BfmKlEevVM5k4M5f4raxBk8y9dB5Ma6l9u
	L3B1blbtAXn0eIFIW2XgcUNTbMTW0ROnUEpjnXdivC3/wHcDlWZa5krWxt2miBtSTbsyftDTXsp
	fIKc7vPSD1E80qWtBKLtlZebkCRydootczbV/9nSxiHV3vSpt1VocIIM66H3nrGAIU90ykGitus
	kfXsjq8RImRVeqJ/9D2ujxLncgtG2XP4t2MUI=
X-Received: by 2002:a17:90b:1845:b0:3ab:8288:b8ce with SMTP id 98e67ed59e1d1-3ae8974d028mr8360348a91.24.1793794205772;
        Wed, 04 Nov 2026 04:10:05 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b09941be80sm620151a91.5.2026.11.04.04.10.05
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2026 04:10:05 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-15a84442a0bso212224c88.0
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:10:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793794204; x=1794399004; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hxg+mZ2q9eGQA/pGVPjbxp5mlhgJhPNVEUMn6doFsnw=;
        b=Uo2Xl53Oac2q4b57EMRJh9Bjd8bpWLMsDcxC+bhrz1/tVe59epsrpjSjeuswufY36m
         lPO1a8lHPV5td9jR/F+JOA12V7nMW44/5I03u07ZpKbTU5MgCuQ6fGaHftzJT6YQV8Uz
         HGqiQjKcK0v8USn75DZPStBkiXRQqqxcCtbxk=
X-Received: by 2002:a05:7022:619b:b0:144:eb3f:563a with SMTP id a92af1059eb24-1a9497b9d52mr39409523c88.15.1793794203597;
        Wed, 04 Nov 2026 04:10:03 -0800 (PST)
X-Received: by 2002:a05:7022:619b:b0:144:eb3f:563a with SMTP id a92af1059eb24-1a9497b9d52mr39409391c88.15.1793794202527;
        Wed, 04 Nov 2026 04:10:02 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c6f0dcsm9377095c88.21.2026.11.04.04.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 04:10:02 -0800 (PST)
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
Subject: [PATCH 06/21] scsi: mpi3mr: Fix endianness of device handles in BSG requests
Date: Wed,  4 Nov 2026 17:30:47 +0530
Message-ID: <20261104120103.503871-7-ranjan.kumar@broadcom.com>
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

The device handle of a task management request, an NVMe encapsulated
request and the target reset sent after a timeout is read from a little
endian field and used as a CPU order value. On a big endian system this
gives the wrong device handle.

Convert the handle to CPU byte order before it is used.

Fixes: 506bc1a0d6ba ("scsi: mpi3mr: Add support for MPT commands")
Fixes: 7dbd0dd8cde3 ("scsi: mpi3mr: Add support for NVMe passthrough")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260818231426.58105-1-chandrakanth.patil@broadcom.com?part=4
Closes: https://sashiko.dev/#/patchset/20260825210411.301535-1-chandrakanth.patil@broadcom.com?part=4
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index a559c99e3b30..83f798c4e9af 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2082,7 +2082,7 @@ static int mpi3mr_build_nvme_prp(struct mpi3mr_ioc *mrioc,
 			    mrioc->facts.sge_mod_shift) << 32);
 	u64 sgemod_val = ((u64)(mrioc->facts.sge_mod_value) <<
 			  mrioc->facts.sge_mod_shift) << 32;
-	u16 dev_handle = nvme_encap_request->dev_handle;
+	u16 dev_handle = le16_to_cpu(nvme_encap_request->dev_handle);
 	struct mpi3mr_tgt_dev *tgtdev;
 	u16 desc_count = 0;
 
@@ -2782,7 +2782,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 		tm_req = (struct mpi3_scsi_task_mgmt_request *)mpi_req;
 		if (tm_req->task_type !=
 		    MPI3_SCSITASKMGMT_TASKTYPE_ABORT_TASK) {
-			dev_handle = tm_req->dev_handle;
+			dev_handle = le16_to_cpu(tm_req->dev_handle);
 			block_io = 1;
 		}
 	}
@@ -2861,10 +2861,11 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 			(mpi_header->function == MPI3_BSG_FUNCTION_SCSI_IO)) {
 			dprint_bsg_err(mrioc, "%s: bsg request timedout after %d seconds,\n"
 				"issuing target reset to (0x%04x)\n", __func__,
-				karg->timeout, mpi_header->function_dependent);
+				karg->timeout,
+				le16_to_cpu(mpi_header->function_dependent));
 			mpi3mr_issue_tm(mrioc,
 			    MPI3_SCSITASKMGMT_TASKTYPE_TARGET_RESET,
-			    mpi_header->function_dependent, 0,
+			    le16_to_cpu(mpi_header->function_dependent), 0,
 			    MPI3MR_HOSTTAG_BLK_TMS, MPI3MR_RESETTM_TIMEOUT,
 			    &mrioc->host_tm_cmds, &resp_code, NULL);
 		}
-- 
2.47.3

