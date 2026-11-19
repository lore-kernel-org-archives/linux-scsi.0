Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.228
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795072776;
	b=YQgBougNd3g4pP8zGqZsxNDhejXgl8+4R58BrDfENUnJwy4aN2tn2pKALPXLxjHeQzb3
	 W5nPxfTMhOCU/85Tx2rTxwM3fU830xpr9bmrycJtTsYtgUhDeGRyxvlNPNaVKs4Uo5B3d
	 JFNy5lHqryTaDLHRxXhBLSrhL0/TCfYSs0CXsSi0mPYKrw7ZhncM+e3XnaH5ciBd6UAtG
	 UMIC82hSIZCPwlQFStGtseLvmz+bnXGjkWwJcY9LctCcK2/pCkBtHXC7zhGauxqZhJTTu
	 fpZYfNI0mzYBXr2/NEhmbB1SK6WEztEI22GNKxWKrbTZSmNfAWzYI+9Z75N/3Dq+S7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795072776;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=LtIETghHaetwvjhcQrkpDXNMjcopBBfE9vbcsp06TUc=;
	b=etfM/7aTDup+5mdF0dlctuM8x/7E6SHB+8U5gxWOL9jG5RncU1Zky6yxlKvoix64iCdC
	 nzmoPhkGS8SO6AM5tePqQlJHC7lMapf7Yns50qdYvanZLMvk6jT/ERJ4uFgWLYtE7KQlT
	 RbZpG8SNw1QirJ3YSAL+rtsuJPKwDsoMW0tCfC5UmjO/20ojjOUoxaZq/i4RHC1As60u4
	 OLl8Ltu6mudHxql0jy7FMBde6EL5KPTmHEZzC56uBaU571RkHxD41vv1/wlwM/5LKHyYk
	 bamddhtV3n6QQwarz+1RMa1qaxLFosvXm189ivJNV//elHKUPnaRDf7d87+kQiXMPYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Fr9UNhki;
	arc=none smtp.remote-ip=209.85.215.228
Received: from mail-pg1-f228.google.com (mail-pg1-f228.google.com [209.85.215.228])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAED2606A33B
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 07:19:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EAED2606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Fr9UNhki
Received: by mail-pg1-f228.google.com with SMTP id 41be03b00d2f7-cdb75699c7cso972304a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:19:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795072775; x=1795677575;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LtIETghHaetwvjhcQrkpDXNMjcopBBfE9vbcsp06TUc=;
        b=tCbUAvlYPTg90kMSl+DEjRfQfB1uahHW6zkzEwAURQrPpH9Gb3VAqyIivuttnr+RCQ
         l5spRUN3kVyB5vQMVfBI6nYfDkGHAXWrAtKmeoX5C/Sgb1i/Ss1m79H1CxksZT3G9rYs
         Y9jPDYKPr7FBxVNdE3OB+d8lutL5HZ9s6kKm07Cbug+N6t8cbe7kzhlbxi7nkv8lOoav
         OCc9f/GIjwHMyep0ie1XRh4ChqAZ949FMOlv7TKZpys4mhvbJz6+0Qd0nKZ+U7pDvXyp
         sr/DLizVcg52zh3pMU8RIOJCOE/5KUl8WNAXCJqaVSdwmpy0ro9qs1cx/jqU7pesHvyD
         CoAw==
X-Gm-Message-State: APuU4Z9PJVkB2sx2LaCVJuUlFF80qT8LO+LuygExdDHYm0KHkPKr1go9
	fCKRwsOWw23/qZwc0Pyls0G0FecQtHBJTXKEEI0HsPj52I/AC2tpGLm+mtnglaXjTPm1wgqurXy
	3gAmJn2+ug44ApdiJsGy3V+uB+YWxCzdR+68IgpWBoaU+4l2acZXl8n8wmcWPNRDP4K6awvmWz1
	bJuC1jnzjsnfxnAW/qSWo+0t8qDANPG7qOxHva3nuCAyjfngFQX7P52xlWnFQ8lM9uuOTG8xsuU
	rHmfsdmSg2HLpwb
X-Gm-Gg: AZFdTZe2ioJyZRJwkQsn0UvyxVzAjm/X7/DnoVXGq1t8BSYfzOFqAw5hVg8xw3y5ZOg
	+ElwUTckvAlp1BhzTXJ1a6veK0TxeU3xl9+f4AAcQzwmuCt2o/h/ABcGLHNITCXsAMC5ihUJ4Aw
	QOJeHGc7uIaGGAXSNrazReVLur/4VEsmtKXEqjeGshoGaKxCiJLMCtspHPdA/e9ldgF4eVbtsab
	hooF5KTMI66/hXdks9mdU3Z9ulVqGRusdHG+D+SE4uFjQYw+bSZMCHexX2RGO09ryv1MOeumccw
	3UTdN6xs2+fjvnH2jwr+hOe9QaOOZBu1lL3Oe25cuNjrxx953XMKV3DOeyFIXdGguGwu9ex8Bhp
	MEmk2UkD7QNav47lPkdZUVm1cAxoAqGNxKVLmuxVMY6ZwdfCEHku7Zk2LKeg7Lz6JhyHmadYQS4
	cV/RNdK4w5iGYdyJgC+872lCpAcXocIW2ZTQWV5Q==
X-Received: by 2002:a17:90a:d44e:b0:3b3:8b61:c43d with SMTP id 98e67ed59e1d1-3b3d0764a8amr4852036a91.30.1795072775140;
        Wed, 18 Nov 2026 23:19:35 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-123.dlp.protect.broadcom.com. [144.49.247.123])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b40567890fsm578512a91.0.2026.11.18.23.19.34
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 23:19:35 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3b08aee6b3eso1748002a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:19:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1795072773; x=1795677573; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LtIETghHaetwvjhcQrkpDXNMjcopBBfE9vbcsp06TUc=;
        b=Fr9UNhkivIvIlQjil7GPTG/aJqLAEo+QQyImwnQmYrPyf0ijWKOVxZk4nrK8tSitOP
         xvtkG3CEvUxTM3Ct6RgfqmKGwU6uJIbx3krKJj5liDFLW1uNdtbjMfeun8zPwj2Ldx5J
         do8BVdabW06ixwS6lpRZ5VJ1hlIcZmbcS0NQY=
X-Received: by 2002:a17:90b:3908:b0:3ae:a531:4e73 with SMTP id 98e67ed59e1d1-3b3d0645d63mr4867926a91.7.1795072773394;
        Wed, 18 Nov 2026 23:19:33 -0800 (PST)
X-Received: by 2002:a17:90b:3908:b0:3ae:a531:4e73 with SMTP id 98e67ed59e1d1-3b3d0645d63mr4867904a91.7.1795072772884;
        Wed, 18 Nov 2026 23:19:32 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b402981814sm748560a91.2.2026.11.18.23.19.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 23:19:32 -0800 (PST)
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
Subject: [PATCH v2 08/20] scsi: mpi3mr: Fix integer overflow in the log data size calculation
Date: Thu, 19 Nov 2026 12:41:20 +0530
Message-ID: <20261119071133.127282-9-ranjan.kumar@broadcom.com>
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

The number of log entries and their total size are held in 16 bits. With a
large entry size the product wraps around, so the driver copies only part
of the log data and still reports success.

Use 32 bit variables for both values.

Fixes: f5e6d5a34376 ("scsi: mpi3mr: Add support for driver commands")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260825210411.301535-1-chandrakanth.patil@broadcom.com?part=5
Closes: https://sashiko.dev/#/patchset/20260825210411.301535-1-chandrakanth.patil@broadcom.com?part=13
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index a68552c9dafa..bd105efdd9cb 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1346,7 +1346,8 @@ static long mpi3mr_enable_logdata(struct mpi3mr_ioc *mrioc,
 static long mpi3mr_get_logdata(struct mpi3mr_ioc *mrioc,
 	struct bsg_job *job)
 {
-	u16 num_entries, sz, entry_sz = mrioc->logdata_entry_sz;
+	u16 entry_sz = mrioc->logdata_entry_sz;
+	u32 num_entries, sz;
 
 	if ((!mrioc->logdata_buf) || (job->request_payload.payload_len < entry_sz))
 		return -EINVAL;
-- 
2.47.3

