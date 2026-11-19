Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795072769;
	b=mf4JNu/l1bFTS8hawitfUtMPlz02muE17dSvfru6dz0Ro8EDiLk4kjUS/rL4LFKiLMd7
	 t4Y9BGCLp0pK5i+3b7Y6nJ5aBVEgZuhvBYnQmG0iloyrmbOleNyyvpcOGZLhxDmLRN33Z
	 74h2AQBTmOCkStLHLJFkOP6SgQSSnDztvzNo4+Y4jUUAjZjdg4HSmILBxvLxIK88uWPYN
	 qlDmHhL7XgPHP3gyjy0cBuFdsxB6RByGfEfBkrq99yTCyojg5D675WeGmDlQzf8Jq13fO
	 wBo0C8IeEgQ/J8StIVVrktYxkmcTVfCPr+mhJtRx4D9So/YVb2OCnx+WCbs8eAweGuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795072769;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=hxg+mZ2q9eGQA/pGVPjbxp5mlhgJhPNVEUMn6doFsnw=;
	b=kAZrhBd424DtQmJNl63COeBhShrcjdVdSxheuHKmOjFRN831JVVQR21Zy/v8gLnf6Xhx
	 Z6ZpCuUr03l7Azx8wiIwy8PFdGTXJz+/S8BxN4IVtu+OBzwJWc1lQXiBkTR71niSRIIoO
	 LnXMuYT0OOqgqBeYL7bfGzY4xo9l6QKK89KMa5W+NmVlAVahyAJm/rfyu2+56KA/+p0qT
	 gplRlQl9MjszgUj9ZQ85CWY7K6fAreOUaBfP7mc10PYx9ksizkMg/UFBpFpF0sPTCTH/T
	 wco82SmTLokpmih+6C8rX2+DFtOnYI8lV7Is914spDCQGwXUnEKAkJKF02h19v6pgxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=a2hQtwhn;
	arc=none smtp.remote-ip=209.85.216.99
Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E28A606A320
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 07:19:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8E28A606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=a2hQtwhn
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-3b08cf16decso1190555a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:19:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795072768; x=1795677568;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hxg+mZ2q9eGQA/pGVPjbxp5mlhgJhPNVEUMn6doFsnw=;
        b=X7sXHS7NMaA9/85vuuFveQNhYGP9WiChf7zPGHYqSuOFriaL9pzQOmYVvUCzkziJeh
         Jzt6JX3DezmXWFjRQPgkoQwnIVBz5okwInWSdMcTfQOVsI09uwNv5IQVbXs9hmgiDRlW
         PTSy4pHyOk375zKpracUVqvgjsp53QmM/OFtxMD0I3lFx9GEhN/soD40iRZEJeVYGujw
         xZa3fCFq+qz2ogyxQUUuAEXGUXdg9stLXSB1PPiL3z1Jujvsem+fwGdQNu1uxB0BCvXl
         0NKpb6hsmSYz617aOUzW4axFDnMVCPw7btGwl6JeHcUePQ0yPo48wN9Q4x6WOQJdxls5
         6XXQ==
X-Gm-Message-State: APuU4Z9wZVYe+DyCYtkm9hNaWdVDYyFBA6rhnc1CP4dcZYYCl2czw4jj
	YOwOwXSLqVf54j23C7p5f0y/QO/Ph/rM9lLxMAxdE4kCHXSpeELDUQKnnp2NjddUY9e2lXXlrmG
	1uc7vqmRzwa3KFcbbbU27bUJVWLChm8rNd8YhFG6nBN9CqSGzUj/LUcrexRm1WLROCbfsYuJFYl
	gLRdGKvaF35WmVk7/CX+LmFHaW5mLZmgYiGbKFnw3vS3wLsI0kdKLHpSXrAslcJAgJIJpfhNVym
	Idu/DpCxQIHIkSa
X-Gm-Gg: AZFdTZeooc/XWmBHuAFG3OZy38qF4KDzR2rJmKZvMVmcoTRG5OBNklxQSUcL+YpYFed
	JkUqv0YaQ+yjYeikRDGzccqECkj7jP32rukhYXVuo/p1u6TFwlenBzU7JD59CBuKnKDhgIDt7az
	l49ucOHcM+hJISvAVKCptGSvqP0z79WT+IFQGcIK9oGZJzkuzdsvZq6mtn/cGQ75+MjFsx/eDPv
	IjqBUvAaqI2zvtPO5Io1Og1YVJBOgBB2Ih+dTfUvHwxw44Oz1nmkL9bMJbjg9MSXhcOETqwwxv5
	J4W7L7N6jtm/7SJWXJv+6Zppi+QatgRGq4knK8szqYzy/laOzl/Aa2W7oBFK4W0rr1IE15qET0L
	CwIwtXbHrkhczn0kLqzP2b1yjngsNW1qJzrk0rwM+DQyvH5lMUJUXWywVc24NhUWs6O1PLH4JAE
	dKUWjqa+OHSx7cgl0P98C8htCt+q3JXzcUKFc=
X-Received: by 2002:a17:90b:2642:b0:3b3:ab8c:c7e5 with SMTP id 98e67ed59e1d1-3b3d07da2afmr4977195a91.56.1795072767705;
        Wed, 18 Nov 2026 23:19:27 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b40567890fsm578285a91.0.2026.11.18.23.19.27
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 23:19:27 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3b4092b645aso169171a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:19:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1795072766; x=1795677566; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hxg+mZ2q9eGQA/pGVPjbxp5mlhgJhPNVEUMn6doFsnw=;
        b=a2hQtwhnC73hbcgSBfprnUtd51pqkG54wJAabTRBxG3Zz+G/ZjbGxRJu+OK5gw+wRF
         ddoFBAOkV3oe6xE7ciz/N/WhJJnRTKMxeRzA3R3Ib3OFb0qaypmr/1YL6y1vqnckXfSe
         5CuCJeGIDd5q0+So+jqD6RS6QACRjnBVaNHgw=
X-Received: by 2002:a17:90a:dfc8:b0:3ab:2737:3392 with SMTP id 98e67ed59e1d1-3b3d07d9dc7mr5162915a91.53.1795072766119;
        Wed, 18 Nov 2026 23:19:26 -0800 (PST)
X-Received: by 2002:a17:90a:dfc8:b0:3ab:2737:3392 with SMTP id 98e67ed59e1d1-3b3d07d9dc7mr5162886a91.53.1795072765559;
        Wed, 18 Nov 2026 23:19:25 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b402981814sm748560a91.2.2026.11.18.23.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 23:19:25 -0800 (PST)
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
Subject: [PATCH v2 06/20] scsi: mpi3mr: Fix endianness of device handles in BSG requests
Date: Thu, 19 Nov 2026 12:41:18 +0530
Message-ID: <20261119071133.127282-7-ranjan.kumar@broadcom.com>
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

