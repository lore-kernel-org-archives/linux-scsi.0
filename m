Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795072814;
	b=rpAMeMTb1isPr0ExNVKVGfXteOBz68OsAvI0epHc3x6P01BslNBjAn/lBnIDn+tUtJjE
	 T5roZsQNaV6UkRzAnPZcvZYrLqLzjt7oKy6xLK8Ss5WLxe3dqbK8wcLrVv5HGbBbkiasF
	 iVk5D15nWoGqVl+qOezRnn83rOIbi+yFmUZatShHWcyBatO/uVv0zyz2lg2E+YzHpGS2y
	 C+vSFlQJQaqPZWLA9dnrvXMUapHRtG7eucZ/q6VCljI3o4Fm0L4W5QDqqB1QseQlWxXsS
	 5DYo3ejgsdp2Kzb6y9DTKsVY5+DXnQkRAO4pdD7zwszQAqV2gBuA6qVxWotEw4E2PFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795072814;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=JQldf9N54WSGLW8CVzkKe0sPRWFnTf6Yfkyg9Jd9yz4=;
	b=EfjY0wvCP8jMkvXBexkdPvh/81KWTZxWGK7uo+FFHnhltXc6JNv43Uc1EZxhx7wRRpX6
	 gxg+73c9IkjojcH2XYlX0MZua8Com6NwH/+7sFR1TjT+dHsHDS/GgWbdKNkLTdtbOOwAN
	 n/S/SHr1HffdA9hTEp16xtjX9i+IcF65E1JJ+OSHKmj6s02wyK7/8YUmqT1PbfJ4g/VZ8
	 7QYvJ+63neJCFLyLzLeN6bj7fJoWDb7ISmKSJaiuv22q7EhdOfZ3LjucRkvFd6Bbe1oyU
	 BC8CL65hXcKyiwoTxnZsVnviJZT2umGvY5Kf4o/9WZNTmDQcGvLe7CMb/EdOGRbQJGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b="T/V79gso";
	arc=none smtp.remote-ip=74.125.82.225
Received: from mail-dy1-f225.google.com (mail-dy1-f225.google.com [74.125.82.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC00C606A324
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 07:20:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC00C606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=T/V79gso
Received: by mail-dy1-f225.google.com with SMTP id 5a478bee46e88-382c3c9671fso2382513eec.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:20:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795072812; x=1795677612;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JQldf9N54WSGLW8CVzkKe0sPRWFnTf6Yfkyg9Jd9yz4=;
        b=UUsd/HisKSh4EPjn9yaXKY+9r/Ys6GuV2tE2PEm9gk/0XeddKT5ZGECMskPVpTMDWH
         Kben5IlknLI8insySits6DAvzp08cb9wmxcOgt/Jb+cfi27tnrcI52eBR8EzPBhSBGUH
         VN8aW+8+6mzYWBA96E7J0/p+pVUOXS0m5WRQbylRDtSJJZwn2xk/MQDhKn+W1fBCs4tt
         iagX59+6lzJsUnIV5Uj4UeuhV1D1MmdJg4Bg+pxigrkKDUReYNWwM4Tz13pXVW5R5Ymr
         HBLE5bU8JiJyZC+DdaEVboT7nKqYan1aW6p2uRBfIdOV1tSE0hxI/BPkTWvnXJDCOfsj
         UAAQ==
X-Gm-Message-State: APuU4Z8n+H+xse1/5cfWfz42eb4DJeMrcXO08+G9mtnHm5eNhrqcPZKr
	hcPVW0muc5aaYBnF7GtsFl59Ag60zenyfTzug0+3H5cnjLuHosMujcOa0PzmulBaDtmxDab32F3
	EzHILyTGWE/wou1jQY8qcZaZ4QuWGy0ZWHBDyX9wyGcazTHxVu9Gry5tVFKsGz1SuZy6axfvhFl
	wEkJ7FQNCuniUNsnG79LkZE3qJ7j74Zpc1uMwiPd1/kt9l0FHXUW++qZF7MZsoYF2U+qujQNeyu
	iMefkuOENlIXkn5
X-Gm-Gg: AZFdTZddayXPh5XuLD9A4dLVOZYXIsyhe19/Dy5Cn2vHe6Pn7ddPK/yDaTF6YK2svWX
	5DCuVs0aHDvbdpAfrJ7dLxxWjyywcxexSnQDlMUD82DhgiRSgN0AGeiyKwtc3OqWI1fTuQHp2rn
	PSklsie1g9XE8yilt7K+QlJG4Xl9Z5NxMBV8TCtIS5dE9v6D19FJu2mceoZHuWufsASd/Nj+iJ9
	JLR1+0hSqUb/hIuEoRbGj8Uw2Uz0cXJmGqdt+VhCV0d3xk3G2/jBjRDC4L7DXhsCLmRSCd6C0UT
	NbOKW+oyI3omziRonMeryA1NhhaQV7+L9kq8QKPmbJ0pN+blkUlLHu0SHDho64OH+xFT5V7pANg
	deX2z8+TyYnKMEGEUGetXsHmCSt8PmqW2INTZSAAsTgJkYKfuHcuhXJ64nz3kmqQwTjtK9fF/J9
	xkR2oTz3q4+NEwOW/sQGpRoYKtFV3PwXasoCM=
X-Received: by 2002:a05:7300:b092:b0:374:ba43:ae2e with SMTP id 5a478bee46e88-38280078014mr5048547eec.14.1795072811676;
        Wed, 18 Nov 2026 23:20:11 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 5a478bee46e88-382a7ac20d6sm257078eec.21.2026.11.18.23.20.11
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 23:20:11 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3ad30487d55so2694208a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:20:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1795072809; x=1795677609; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JQldf9N54WSGLW8CVzkKe0sPRWFnTf6Yfkyg9Jd9yz4=;
        b=T/V79gsowATM7bg4iNkeBi5xaoQmHKCjlmLnhMvSanBDjpHR4NlScD6EKCTvyFOxzn
         3glBjmsvMN6zj4oNkgqsWkTBlxnPtG+XWpJE+QncHAIZFGUQehU4PTEXDKS7pczXfCKv
         gr6ZIGaIEkvYLIxQOh1ZSqUSa6SVoadCc+aLU=
X-Received: by 2002:a17:90b:448b:b0:3ac:9d83:8856 with SMTP id 98e67ed59e1d1-3b3d0641d19mr5268455a91.9.1795072809300;
        Wed, 18 Nov 2026 23:20:09 -0800 (PST)
X-Received: by 2002:a17:90b:448b:b0:3ac:9d83:8856 with SMTP id 98e67ed59e1d1-3b3d0641d19mr5268432a91.9.1795072808797;
        Wed, 18 Nov 2026 23:20:08 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b402981814sm748560a91.2.2026.11.18.23.20.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 23:20:08 -0800 (PST)
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
Subject: [PATCH v2 18/20] scsi: mpi3mr: Fix byte order handling in the NVMe passthrough commands
Date: Thu, 19 Nov 2026 12:41:30 +0530
Message-ID: <20261119071133.127282-19-ranjan.kumar@broadcom.com>
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

The NVMe passthrough code reads the command dword that selects PRP or SGL
and applies the SGE modifier to the addresses without converting between
CPU and little endian byte order. On a big endian host the wrong data
format is chosen and the modifier bits end up in the wrong place of the
address.

Convert the command dword when reading it, and keep the modifier mask and
value in little endian form like the address fields they are applied to.

Fixes: 7dbd0dd8cde3 ("scsi: mpi3mr: Add support for NVMe passthrough")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260825210411.301535-1-chandrakanth.patil@broadcom.com?part=2
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 145b198b5506..3359393dff5c 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1966,7 +1966,7 @@ static unsigned int mpi3mr_get_nvme_data_fmt(
 {
 	u8 format = 0;
 
-	format = ((nvme_encap_request->command[0] & 0xc000) >> 14);
+	format = ((le32_to_cpu(nvme_encap_request->command[0]) & 0xc000) >> 14);
 	return format;
 
 }
@@ -1995,10 +1995,10 @@ static int mpi3mr_build_nvme_sgl(struct mpi3mr_ioc *mrioc,
 	u16 available_sges = 0, i;
 	u32 sge_element_size = sizeof(struct mpi3mr_nvme_pt_sge);
 	struct mpi3mr_buf_map *drv_buf_iter = drv_bufs;
-	u64 sgemod_mask = ((u64)((mrioc->facts.sge_mod_mask) <<
-			    mrioc->facts.sge_mod_shift) << 32);
-	u64 sgemod_val = ((u64)(mrioc->facts.sge_mod_value) <<
-			  mrioc->facts.sge_mod_shift) << 32;
+	__le64 sgemod_mask = cpu_to_le64(((u64)((mrioc->facts.sge_mod_mask) <<
+			    mrioc->facts.sge_mod_shift) << 32));
+	__le64 sgemod_val = cpu_to_le64(((u64)(mrioc->facts.sge_mod_value) <<
+			  mrioc->facts.sge_mod_shift) << 32);
 	u32 size;
 
 	nvme_sgl = (struct mpi3mr_nvme_pt_sge *)
@@ -2094,10 +2094,10 @@ static int mpi3mr_build_nvme_prp(struct mpi3mr_ioc *mrioc,
 	size_t length = 0, desc_len;
 	u8 count;
 	struct mpi3mr_buf_map *drv_buf_iter = drv_bufs;
-	u64 sgemod_mask = ((u64)((mrioc->facts.sge_mod_mask) <<
-			    mrioc->facts.sge_mod_shift) << 32);
-	u64 sgemod_val = ((u64)(mrioc->facts.sge_mod_value) <<
-			  mrioc->facts.sge_mod_shift) << 32;
+	__le64 sgemod_mask = cpu_to_le64(((u64)((mrioc->facts.sge_mod_mask) <<
+			    mrioc->facts.sge_mod_shift) << 32));
+	__le64 sgemod_val = cpu_to_le64(((u64)(mrioc->facts.sge_mod_value) <<
+			  mrioc->facts.sge_mod_shift) << 32);
 	u16 dev_handle = le16_to_cpu(nvme_encap_request->dev_handle);
 	struct mpi3mr_tgt_dev *tgtdev;
 	u16 desc_count = 0;
-- 
2.47.3

